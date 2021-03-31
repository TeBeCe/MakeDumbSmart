//
//  ContentView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 03/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case first, second, third
    
    var id: Int {
        hashValue
    }
}

struct ContentView: View {
    @AppStorage("wallpaper") var wallpaper = images[0]
    
    @State private var selectedDevice : Device? = nil
    @State private var selectedScene : Scene? = nil
    @ObservedObject var dvcObj = LoadJSONData()
    @State var selectedIndx :Int = 0
    @State private var islong: Bool = false
    @State private var didScale: Bool = false
    @State var activeSheet: ActiveSheet?
    
    let animationDuration = 0.1
    
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 120))]
    let rows = [
        GridItem(.fixed(60)),
        GridItem(.fixed(60))
    ]
    
    var body: some View {
        //        NavigationView{
        VStack(alignment: .leading){
            
            topMenu
            
            ScrollView(){
                VStack(alignment: .leading){
                    Text(dvcObj.home.home_name)
                        .font(.system(size: 45, weight: .bold))
                        .fontWeight(.bold)
                        .padding([.leading,.bottom], 20)
                        .foregroundColor(Color(UIColor.init(named:"textColor")!))
                    Text("Favorite scenes").padding(.leading, 20)
                    
                    ScrollView(.horizontal,showsIndicators: false){
                        LazyHGrid(rows: rows,alignment: .center, spacing: 10)
                        {
                            ForEach(dvcObj.scenes.indices,id: \.self){ indx in
                                Button(action: {})
                                {
                                    SceneView(scene: self.dvcObj.scenes[indx])
                                        .onTapGesture{
                                            self.selectedIndx = indx
                                            let animation = Animation.linear(duration: animationDuration).repeatCount(1, autoreverses: true)
                                            withAnimation(animation){
                                                self.didScale.toggle()
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration) {
                                                self.didScale.toggle()
                                            }
                                            dvcObj.activateScene(scene: self.dvcObj.scenes[indx])
                                            dvcObj.findAndActivateScene()
                                            let impactMedium = UIImpactFeedbackGenerator(style: .medium)
                                            impactMedium.impactOccurred()
                                        }
                                        .onLongPressGesture{
                                            self.selectedScene = dvcObj.scenes[indx]
                                            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                                            impactHeavy.impactOccurred()
                                        }
                                        .scaleEffect(didScale && indx == selectedIndx ? 0.95 : 1)
                                        .animation(Animation
                                                    .linear(duration: self.animationDuration)
                                                    .repeatCount(1, autoreverses: true))
                                }
                            }
                        }.padding(.leading,20)
                        .padding(.trailing,20)
                        .animation(.easeIn)
                        //.padding(.bottom,20)
                    }.sheet(item: $selectedScene){ scene in
                        SceneSettingsView(sc: $selectedScene, dvcObj: dvcObj,scene: scene,devicesInRoom: dvcObj.getDevicesInScene(scene: scene))
                    }.padding(.leading, 0.0)
                    
                }.padding(.bottom, 10)
                
                VStack(alignment: .leading){
                    Text("Favorite Functions").padding(.leading, 20)
                    
                    LazyVGrid(columns: columns, spacing: 10){
                        ForEach(dvcObj.devices.indices,id: \.self ) { indx in
                            Button(action: {
                                self.selectedDevice = self.dvcObj.devices[indx]
                                print(self.dvcObj.devices[indx])
                            })
                            {
                                if(["sensor_temperature","sensor_humidity"].contains(self.dvcObj.devices[indx].type)){
                                    SensorView(device: self.dvcObj.devices[indx], rooms: dvcObj.rooms);
                                }
                                else{
                                    DevicesView(device: self.dvcObj.devices[indx], rooms: dvcObj.rooms)
                                }
                            }
                        }
                    }.sheet(item: $selectedDevice){ device in
                        if(["sensor_temperature","sensor_humidity"].contains(device.type)){
                            //                              SensorChartsView(device: device)
                            SensorDetailView(sd: $selectedDevice, dvcObj: dvcObj, device: device)
                            
                        }
                        else {
                            DeviceDetailView(sd: $selectedDevice, dvcObj: dvcObj, device: device)
                        }
                    }
                    .animation(.easeIn)
                    .padding(.horizontal)
                    .padding(.bottom,20)
                }
            }
        }
        .onAppear(perform: {
            self.dvcObj.loadData()
        })
        .onDisappear(perform: {
            print("ContetnView dissapear")
            dvcObj.continueRefresh = false
        })
        .background(Image(decorative: wallpaper)
                        .resizable())
        .navigationTitle(dvcObj.home.home_name)
        .edgesIgnoringSafeArea(.all)
        
        //        }
    }
    var topMenu: some View {
        HStack{
            Menu {
                Button(action: {self.activeSheet = .first}, label: {
                    HStack{
                        Text("Add Device")
                        Image(systemName: "plus")
                    }
                } )
                Button(action: {self.activeSheet = .second}, label: {
                    HStack{
                        Text("Add Scene")
                        Image(systemName: "plus")
                    }
                })
            } label: {
                Label(title: { Text("Add") }, icon: {
                    Image(systemName: "plus")
                        .font(.system(size:25, weight: .semibold))
                }).foregroundColor(Color(UIColor.init(named:"textColor")!))
                
            }
            Spacer()
            Menu {
                Button(action: {self.activeSheet = .third}, label: {
                    HStack{
                        Text("Home Settings")
                        Image(systemName: "gear")
                    }
                })
            } label: {
                Label(title: { Text("") }, icon: {
                    Image(systemName: "gear")
                        .font(.system(size:25, weight: .semibold))
                }).foregroundColor(Color(UIColor.init(named:"textColor")!))
            }
        }.padding(.horizontal , 20)
        .padding(.top,20)
        .sheet(item: $activeSheet, onDismiss: {dvcObj.validateScenes()}) { item in
            switch item {
            case .first:
                AddDeviceView(activeSheet: $activeSheet, dvcObj: dvcObj)
            case .second:
                AddSceneView(activeSheet: $activeSheet, dvcObj: dvcObj, devicesInRoom: [])
            case .third:
                HomeSettingsView(activeSheet: $activeSheet, dvcObj: dvcObj, home: $dvcObj.home)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//            .previewDevice("iPhone 11")

    }
}
