//
//  SceneSettingsView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 21/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct TestData: Identifiable {
    var id : Int
    var devices: [Device]
}

struct SceneSettingsView: View {
    @Binding var sc : Scene?
    @ObservedObject var dvcObj : LoadJSONData
    @State var scene : Scene
    @State var selectedScene : Scene? = nil
    @State var devicesInRoom : [TestData]
    @State var selectedDevice : Device? = nil
    
    var arr:[Int] = []
    
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
                            TextField("Name", text: $scene.scene_name, onEditingChanged: { _ in
                                print("changed")
                                dvcObj.updateBackendScene(scene: scene)
                            })
                                .onChange(of: scene.scene_name){ _ in
                                    dvcObj.updateScene(scene: scene)
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
                                            if(!dvcObj.scenes[arrr[0]].devices[arrr[1]].is_active && dvcObj.scenes[arrr[0]].devices[arrr[1]].value == 0.0 ){
                                                dvcObj.scenes[arrr[0]].devices[arrr[1]].value = Float(dvcObj.scenes[arrr[0]].devices[arrr[1]].max_level ?? 1)
                                                print("set to max")
                                            }
                                            dvcObj.scenes[arrr[0]].devices[arrr[1]].is_active.toggle()
                                            dvcObj.updateBackendScene(scene: dvcObj.scenes[arrr[0]])
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
                            Text("Test Scene// not implemented").foregroundColor(Color(.systemOrange))
                        }
                        Button(action: {
                            self.selectedScene = scene
                        }){
                            Text("Add/Remove Accesories").foregroundColor(Color(.systemOrange))
                        }.sheet(item: $selectedScene){ scene in
                            SelectDeviceInSceneView(dvcObj: dvcObj, scene: scene, devicesInRoom: dvcObj.getDevicesInRooms())
                        }
                    }
                    Section(){
                        Button(action: {dvcObj.deleteScene(scene: scene)
                                self.sc = nil
                                print("deleting scene")}){
                            Text("Delete Scene").foregroundColor(Color(.systemRed))
                        }
                    }
                }.sheet(item: $selectedDevice){ device in
                    SceneDeviceDetailView(sd: $selectedDevice, dvcObj: dvcObj, device: device, scene: scene)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarItems(leading:
                                    HStack{
                                        Image(systemName: "lightbulb").font(.system(size:25, weight: .semibold))
                                        Text(scene.scene_name).font(.system(size:17, weight: .semibold))
                                    }, trailing: Button(action:{self.sc = nil}){Image(systemName: "xmark.circle.fill")
                                        .font(.system(size:25, weight: .bold)).accentColor(.gray)}).navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SceneDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SceneSettingsView(sc: .constant(nil),dvcObj: LoadJSONData(),scene: Scene(scene_name: "Scene_name", id: 0, is_favorite: true, glyph: nil, is_active: true, devices: [], scene_devices: []), devicesInRoom: [])
            .preferredColorScheme(.dark)
    }
}
