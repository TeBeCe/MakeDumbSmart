//
//  AddSceneView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 28/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct AddSceneView: View {
    @Binding var activeSheet: ActiveSheet?
    @ObservedObject var dvcObj : LoadJSONData
    @State var scene : Scene = Scene(scene_name: "", id: 0, is_favorite: false, glyph: "lightbulb", is_active: false, devices: [],scene_devices: [])
    @State var selectedScene : Scene? = nil
//    @State var devicesInRoom : [TestData]
//    @State var enabledButton : Bool = false
    @State var selectedDevice : Device? = nil

    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack{
                List{
                    Section(footer: footerDevices){
                        HStack{
                            NavigationLink(destination: GlyphSelectionView(selectedGlyph: $scene.glyph, glyphArray: glyphSceneArray) ){EmptyView()}.hidden().frame(width:0)
                            Image(systemName: scene.glyph )
                                .font(.system(size:20, weight: .semibold))
                                .padding()
                                .frame(width:35,height:35)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color(.systemOrange), lineWidth: 2)
                                )
                            
                            TextField("Scene Name", text: $scene.scene_name)
                                .onChange(of: scene.scene_name){ _ in
                                    dvcObj.updateScene(scene: scene)
                                    if(scene.scene_name.count > 0){
//                                        dvcObj.createScene(scene: scene)
//                                        self.enabledButton = true
                                    }
                                    else{
//                                        self.enabledButton = false
                                    }
                                }
                                .disableAutocorrection(true)
                        }.padding(.leading, -10)
                    }
                    
//                    TODO: Rework variables
                    ForEach(dvcObj.getDevicesInScene(scene: scene)){ dvcsInRoom in
                        Section(header: Text(dvcsInRoom.roomName)){
                            LazyVGrid(columns: columns,spacing: 10){
                                ForEach(dvcsInRoom.devices.indices,id: \.self){ indx in
                                    let arrr = dvcObj.modifyDeviceInScene(scene: scene, device: dvcsInRoom.devices[indx])
                                    //DevicesView(device:dvcInRoom.devices[indx], rooms:dvcObj.rooms)
                                    DevicesView(device:dvcObj.scenes[arrr[0]].devices[arrr[1]], rooms:dvcObj.rooms, showSpinner: false)
                                        .onTapGesture{
                                            dvcObj.scenes[arrr[0]].devices[arrr[1]].is_active.toggle()
                                            print(dvcObj.scenes[arrr[0]].devices[arrr[1]])
                                            //self.selectedIndx = indx
                                            
                                        }
                                        .onLongPressGesture{
                                            //print("long")
                                            self.selectedDevice = dvcObj.scenes[arrr[0]].devices[arrr[1]]
                                        }
                                }
                            }.padding(.leading,-20).padding(.trailing,-20)
                        }.listRowBackground(Color(UIColor.init(named:"bgColor")!))
                    }
                    Section(){
                        Button(action: {
                            self.selectedScene = scene
                            print(scene)
                        }){
                            Text("Add or remove Accesories")
                                .foregroundColor(scene.scene_name != "" ? Color(.systemOrange) : Color(.gray))
                        }.disabled(scene.scene_name == "")
                        .sheet(item: $selectedScene){ scene in
                            SelectDeviceInSceneView(dvcObj: dvcObj, scene: $scene, devicesInRoom: dvcObj.getDevicesInRooms())
                        }
                    }
                    Section(){
                        Button(action: {print("Create scene")
                            
                            dvcObj.createScene(scene: Scene(scene_name: scene.scene_name, id: Int.random(in: 9999..<99999), is_favorite: false, glyph: scene.glyph, is_active: false, devices: dvcObj.getDevicesInSceneArray(scene: scene), scene_devices: []))
                            dvcObj.createBackendScene(scene: Scene(scene_name: scene.scene_name, id: Int.random(in: 9999..<99999), is_favorite: false, glyph: scene.glyph, is_active: false, devices: dvcObj.getDevicesInSceneArray(scene: scene), scene_devices: []))
                            //dvcObj.loadData()

                            activeSheet = nil
                        }){
                            Text("Create scene")
                        }.disabled(scene.scene_name == "")
                    }
                }.sheet(item: $selectedDevice){ device in
                    SceneDeviceDetailView(sd: $selectedDevice, dvcObj: dvcObj, device: device, scene: scene)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarTitle(Text("Add Scene"), displayMode: .inline)

        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            dvcObj.continueRefresh = false
            dvcObj.createScene(scene: scene)
        })
        .onDisappear(perform: {
            dvcObj.continueRefresh = true
            dvcObj.loadData()
        })
    }
    
    private var footerDevices : some View {
           VStack(alignment: .leading){
            if(scene.devices.count > 0){
                Text("Devices")
                    .textCase(nil)
                    .font(.system(size:25, weight: .semibold))
                    .foregroundColor(Color(UIColor.init(named:"textColor")!))
                Text("Configure devices in scene \(scene.scene_name) by pushing or holding")
                    .textCase(nil)
                    .foregroundColor(Color(UIColor.init(named:"textColor")!))
            }
            else{
                Text("")
            }
        }
    }
}

struct AddSceneView_Previews: PreviewProvider {
    static var previews: some View {
        AddSceneView(activeSheet: .constant(nil), dvcObj: LoadJSONData(), scene: Scene(scene_name: "xx", id: 0, is_favorite: true, glyph: "lightbulb", is_active: true, devices: [], scene_devices: [])/*, devicesInRoom: []*/)
    }
}
