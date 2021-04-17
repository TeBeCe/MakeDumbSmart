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
    var roomName: String
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
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
        GridItem(.adaptive(minimum: 110, maximum: 120))

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
                                ).onChange(of: scene.glyph){_ in
                                    dvcObj.updateSceneGlyph(scene: scene )
                                    dvcObj.updateBackendScene(scenex: scene )
                                }
                            TextField("Name", text: $scene.scene_name, onEditingChanged: {isStarted in
                                print("changed")
                                if(!isStarted){
                                    dvcObj.updateBackendScene(scenex: scene)
                                }
                            })
                                .onChange(of: scene.scene_name){ _ in
                                    dvcObj.updateScene(scene: scene)
                                }
                            .disableAutocorrection(true)
                        }.padding(.leading, -20)
                    }

//                    TODO: Rework variables
                    ForEach(dvcObj.getDevicesInScene(scene: scene)){ dvcsInRoom in
                        Section(header: Text(dvcsInRoom.roomName)){
                            LazyVGrid(columns: columns,spacing: 10){
                                ForEach(dvcsInRoom.devices.indices,id: \.self){ indx in
                                    let arrr = dvcObj.modifyDeviceInScene(scene: scene, device: dvcsInRoom.devices[indx])
//                                    DevicesView(device:dvcInRoom.devices[indx], rooms:dvcObj.rooms)
                                    
                                    DevicesView(device:dvcObj.scenes[arrr[0]].devices[arrr[1]], rooms:dvcObj.rooms, showSpinner: false)
                                        .onTapGesture{
                                            if(!dvcObj.scenes[arrr[0]].devices[arrr[1]].is_active && dvcObj.scenes[arrr[0]].devices[arrr[1]].value == 0.0 ){
                                                dvcObj.scenes[arrr[0]].devices[arrr[1]].value = Float(dvcObj.scenes[arrr[0]].devices[arrr[1]].max_level ?? 1)
                                                print("set to max")
                                            }
                                            dvcObj.scenes[arrr[0]].devices[arrr[1]].is_active.toggle()
                                            dvcObj.updateBackendScene(scenex: dvcObj.scenes[arrr[0]])
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
                        Button(action: {
                            self.selectedScene = scene
                        }){
                            Text("Add/Remove Accesories").foregroundColor(Color(.systemOrange))
                        }.sheet(item: $selectedScene){ scene in
                            SelectDeviceInSceneView(dvcObj: dvcObj, scene: $scene, devicesInRoom: dvcObj.getDevicesInRooms())
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
                                        Image(systemName: scene.glyph).font(.system(size:25, weight: .semibold))
                                        Text(scene.scene_name).font(.system(size:17, weight: .semibold))
                                    }, trailing: Button(action:{self.sc = nil}){Image(systemName: "xmark.circle.fill")
                                        .font(.system(size:25, weight: .bold)).accentColor(.gray)}).navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform:{
                    print(scene)
        })
        .onDisappear(perform: {
//            scene = dvcObj.updateScene(scene: scene)
//            print(scene)
            dvcObj.updateBackendScene(scenex: scene)
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

struct SceneDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SceneSettingsView(sc: .constant(nil),dvcObj: LoadJSONData(),scene: Scene(scene_name: "Scene_name", id: 0, is_favorite: true, glyph: "lightbulb", is_active: true, devices: [], scene_devices: []), devicesInRoom: [])
            .preferredColorScheme(.dark)
    }
}
