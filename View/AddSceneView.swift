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
    @State var scene : Scene = Scene(scene_name: "", id: 0, is_favorite: false, glyph: nil, is_active: false, devices: [],scene_devices: [])
    @State var selectedScene : Scene? = nil
    @State var devicesInRoom : [TestData]
    @State var enabledButton : Bool = false
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
                    Section(){
                        HStack{
                            Image(systemName: "lightbulb")
                                .font(.system(size:20, weight: .semibold))
                                .padding(4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color(.systemOrange), lineWidth: 2)
                                )
                                .frame(width:25,height:25)
                            
                            TextField("Scene Name", text: $scene.scene_name)
                                .onChange(of: scene.scene_name){ _ in
                                    dvcObj.updateScene(scene: scene)
                                    if(scene.scene_name.count > 0){
                                        dvcObj.createScene(scene: scene)
                                        self.enabledButton = true
                                    }
                                    else{
                                        self.enabledButton = false
                                    }
                                }
                        }.padding(.leading, -10)
                    }
//                    TODO: Rework variables
                    ForEach(dvcObj.getDevicesInScene(scene: scene)){ dvcsInRoom in
                        Section(header: Text(dvcObj.rooms[dvcsInRoom.id-1].room_name)){
                            LazyVGrid(columns: columns,spacing: 10){
                                ForEach(dvcsInRoom.devices.indices,id: \.self){ indx in
                                    let arrr = dvcObj.modifyDeviceInScene(scene: scene, device: dvcsInRoom.devices[indx])
//                                    DevicesView(device:dvcInRoom.devices[indx], rooms:dvcObj.rooms)
                                    DevicesView(device:dvcObj.scenes[arrr[0]].devices[arrr[1]], rooms:dvcObj.rooms)
                                        .onTapGesture{
                                            dvcObj.scenes[arrr[0]].devices[arrr[1]].is_active.toggle()
                                            print(dvcObj.scenes[arrr[0]].devices[arrr[1]])
//                                            self.selectedIndx = indx
                                            
                                        }
                                        .onLongPressGesture{
                                            print("long")
                                            self.selectedDevice = dvcObj.scenes[arrr[0]].devices[arrr[1]]
                                        }
                                    
                                    
                                }
                            }.padding(.leading,-20).padding(.trailing,-20)
                        }.listRowBackground(Color(UIColor.init(named:"bgColor")!))
                    }
                    Section(){
                        Button(action: {print("testing scene// not implemented")}){
                            Text("Test scene// not implemented")
                                .foregroundColor(Color(.systemOrange))
                        }
                        Button(action: {
                            self.selectedScene = scene
                        }){
                            Text("Add or remove Accesories")
                                .foregroundColor(self.enabledButton ? Color(.systemOrange) : Color(.gray))
                        }.disabled(!self.enabledButton)
                        .sheet(item: $selectedScene){ scene in
                            SelectDeviceInSceneView(dvcObj: dvcObj, scene: scene, devicesInRoom: dvcObj.getDevicesInRooms())
                        }
                    }
                    Section(){
                        Button(action: {print("Create scene")
                            
                            dvcObj.createScene(scene: Scene(scene_name: scene.scene_name, id: Int.random(in: 10..<100), is_favorite: false, glyph: nil, is_active: false, devices: dvcObj.getDevicesInSceneArray(scene: scene), scene_devices: []))
                            activeSheet = nil
                        }){
                            Text("Create scene")
                        }.disabled(!self.enabledButton)
                    }
                }.sheet(item: $selectedDevice){ device in
                    SceneDeviceDetailView(sd: $selectedDevice, dvcObj: dvcObj, device: device, scene: scene)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarTitle(Text("Add Scene"), displayMode: .inline)

        }
    }
}

struct AddSceneView_Previews: PreviewProvider {
    static var previews: some View {
        AddSceneView(activeSheet: .constant(nil), dvcObj: LoadJSONData(), scene: Scene(scene_name: "xx", id: 0, is_favorite: true, glyph: nil, is_active: true, devices: [], scene_devices: []), devicesInRoom: [])
    }
}
