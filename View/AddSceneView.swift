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
    @State var scene : Scene = Scene(scene_name: "", id: 0, is_favorite: false, glyph: nil, is_active: false, devices: [])
    @State var selectedScene : Scene? = nil
    @State var devicesInRoom : [TestData]
    @State var enabledButton : Bool = false
    
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
                            TextField("Scene Name", text: $scene.scene_name)
                                .onChange(of: scene.scene_name){ _ in
                                    //dvcObj.updateDevice(device: device)
                                    if(scene.scene_name.count > 0){
                                        dvcObj.createScene(scene: scene)
                                        self.enabledButton = true
                                    }
                                    else{
                                        self.enabledButton = false
                                    }
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
                            Text("Test scene// not implemented").foregroundColor(Color(.systemOrange))
                        }
                        Button(action: {
                            self.selectedScene = scene
                        }){
                            Text("Add or remove Accesories").foregroundColor(self.enabledButton ? Color(.systemOrange) : Color(.gray))
                        }.disabled(!self.enabledButton)
                        .sheet(item: $selectedScene){ scene in
                            SelectDeviceInSceneView(dvcObj: dvcObj, scene: scene, devicesInRoom: dvcObj.getDevicesInRooms())
                        }
                    }
                    Section(){
                        Button(action: {print("Create scene")
                            
                            dvcObj.createScene(scene: Scene(scene_name: scene.scene_name, id: Int.random(in: 10..<100), is_favorite: false, glyph: nil, is_active: false, devices: dvcObj.getDevicesInSceneArray(scene: scene)))
                            activeSheet = nil
                        }){
                            Text("Create scene")
                        }.disabled(!self.enabledButton)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationBarTitle(Text("Add Scene")
            ).navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
//                dvcObj.createScene(scene: scene)
//                mayber we can create invisible scene, and then replace with created one
            })
        }
    }
}

struct AddSceneView_Previews: PreviewProvider {
    static var previews: some View {
        AddSceneView(activeSheet: .constant(nil), dvcObj: LoadJSONData(), scene: Scene(scene_name: "xx", id: 0, is_favorite: true, glyph: nil, is_active: true, devices: []), devicesInRoom: [])
    }
}
