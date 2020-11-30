//
//  ContentView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 03/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case first, second
    
    var id: Int {
        hashValue
    }
}

struct ContentView: View {
    @State private var selectedDevice : Device? = nil
    @State private var selectedScene : Scene? = nil
    @ObservedObject var dvcObj = LoadJSONData()
    @State var selectedIndx :Int = 0
    @State private var islong: Bool = false
    @State private var didScale: Bool = false
    @State var activeSheet: ActiveSheet?
    
    let animationDuration = 0.1
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let rows = [
        GridItem(.fixed(60)),
        GridItem(.fixed(60))
    ]
    
    var body: some View {
        VStack(alignment: .leading){
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
                } )
            } label: {
                Label(title: { Text("Add") }, icon: {
                        Image(systemName: "plus")
                            .font(.system(size:30, weight: .semibold))
                }).foregroundColor(.black)
            }.padding(.leading , 20)
            
            .sheet(item: $activeSheet, onDismiss: {dvcObj.validateScenes()}) { item in
                        switch item {
                        case .first:
                            AddDeviceView(activeSheet: $activeSheet)
                        case .second:
                            AddSceneView(activeSheet: $activeSheet, dvcObj: dvcObj, devicesInRoom: [])
                        }
            }
            
            Text(dvcObj.home.home_name).font(.system(size: 45, weight: .bold))
                .fontWeight(.bold)
                .padding(.leading, 20)
                .padding(.top, 20)
            
            ScrollView(){
                VStack(alignment: .leading){
                    Text("Favorite scenes").padding(.leading, 20)
                    
                    ScrollView(.horizontal,showsIndicators: false){
                        LazyHGrid(rows: rows,alignment: .center, spacing: 10)
                        {
                            ForEach(dvcObj.scenes.indices,id: \.self){ indx in
                                Button(action: {print("tapx")})
                                {
                                    SceneView(scene: self.dvcObj.scenes[indx])
                                        .onTapGesture{
                                            print(dvcObj.scenes[indx])
                                            self.selectedIndx = indx
                                            dvcObj.scenes[indx].is_active.toggle()
                                            let animation = Animation.linear(duration: animationDuration).repeatCount(1, autoreverses: true)
                                            withAnimation(animation){
                                                self.didScale.toggle()
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration) {
                                                self.didScale.toggle()
                                            }
                                            print("tap")}
                                        .onLongPressGesture{
                                            self.selectedScene = dvcObj.scenes[indx]
                                            
                                            print("longtap")}
//                                        .updating(self.$islong) { value, state, transcation in
//                                                print(value)
//                                                print(state)
//                                                print(transcation)
//                                            }
                                        .scaleEffect(didScale && indx == selectedIndx ? 0.95 : 1)
                                        .animation(Animation.linear(duration: self.animationDuration).repeatCount(1, autoreverses: true))
                                        
                                }
                                //                                .simultaneousGesture(
                                //                                    LongPressGesture(minimumDuration: 1).onEnded { _ in self.didLongPress = true }.onChanged{value in print("changed\(value)")}
                                
                                //                                )
                                
                            }
                        }.padding(.leading,20)
                    }.sheet(item: $selectedScene){ scene in
                        SceneDetailView(sc: $selectedScene,dvcObj: dvcObj,scene: scene,devicesInRoom: dvcObj.getDevicesInScene(scene: scene))
                        
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
                                DevicesView(device: self.dvcObj.devices[indx], rooms: dvcObj.rooms)
                            }
                        }
                    }.sheet(item: $selectedDevice){ device in
                        DeviceDetailView(sd: $selectedDevice, dvcObj: dvcObj, device: device)
                    }
                    .padding(.horizontal)
                }
            }
        }.onAppear(perform: {self.dvcObj.loadData()
        })
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9695343375, green: 0.5495890379, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.9504212737, green: 0.8822066784, blue: 0.2864913642, alpha: 1))]), startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
