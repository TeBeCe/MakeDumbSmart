//
//  SelectDeviceInSceneView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 24/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct SelectDeviceInSceneView: View {
    @ObservedObject var dvcObj : LoadJSONData
    @Binding var scene : Scene
    @State var devicesInRoom : [TestData]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
//        GridItem(.adaptive(minimum: 120, maximum: 120))
    ]
    var body: some View {
        NavigationView{
            List{
                ForEach(devicesInRoom){ xx in
                    Section(header: Text(dvcObj.rooms[xx.id-1].room_name)){
                        LazyVGrid(columns: columns,spacing: 10){
                            ForEach(xx.devices){device in
                                CheckableDeviceView(device:device,checked:dvcObj.isDeviceInScene(scene: scene, device: device))
                                    .onTapGesture {
                                        scene = dvcObj.addOrRemoveDeviceToScene(scene: scene, device: device)
//                                        dvcObj.addOrRemoveSceneDeviceToScene(scene: scene, device: device)
                                    }
                            }
                        }.padding(.leading,-20)
                        .padding(.trailing,-20)
                    }.listRowBackground(Color(UIColor.init(named:"bgColor")!))
                }
            }.navigationBarTitle(Text("Add / Remove Accesory"), displayMode: .inline)
        }
    }
}

struct SelectDeviceInSceneView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDeviceInSceneView(dvcObj: LoadJSONData(), scene: .constant(Scene(scene_name: "Test", id: 0, is_favorite: true, glyph: "lightbulb", is_active: false, devices: [], scene_devices: [])), devicesInRoom: [])
    }
}
