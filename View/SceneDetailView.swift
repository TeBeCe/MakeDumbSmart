//
//  SceneDetailView.swift
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

struct SceneDetailView: View {
    @Binding var sc : Scene?
    @ObservedObject var dvcObj : LoadJSONData
    @State var scene : Scene
    @State var selectedScene : Scene? = nil
    @State var devicesInRoom : [TestData]
    
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
                            Image(systemName: "lightbulb").font(.system(size:20, weight: .semibold)).padding(.leading,-10)
                            TextField("Name", text: $scene.scene_name)
                                .onChange(of: scene.scene_name){ _ in
                                    //dvcObj.updateDevice(device: device)
                                }
                        }
                    }
//                    TODO: Rework variables
                    ForEach(dvcObj.getDevicesInScene(scene: scene)){ xx in
                        Section(header: Text(dvcObj.rooms[xx.id-1].room_name)){
                            LazyVGrid(columns: columns,spacing: 10){
                                ForEach(xx.devices){device in
                                    DevicesView(device:device, rooms:dvcObj.rooms)
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
        SceneDetailView(sc: .constant(nil),dvcObj: LoadJSONData(),scene: Scene(scene_name: "Scene_name", id: 0, is_favorite: true, glyph: nil, is_active: true, devices: []), devicesInRoom: [])
            .preferredColorScheme(.dark)
    }
}
