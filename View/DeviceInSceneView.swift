//
//  DeviceInSceneView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 07/12/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct DeviceInSceneView: View {
    @ObservedObject var dvcObj : LoadJSONData
    @State var device : Device
    @State private var selectedScene : Scene? = nil
    var body: some View {
        //NavigationView{
            VStack{
                Form{
                    ForEach(dvcObj.getDeviceInScenes(device: device)){scene in
                        SceneListItemView(scene: scene, device: device).onTapGesture {
                            self.selectedScene = scene
                        }
                    }
                }
            }.sheet(item: $selectedScene){ scene in
                SceneDetailView(sc: $selectedScene,dvcObj: dvcObj,scene: scene,devicesInRoom: dvcObj.getDevicesInScene(scene: scene))
            }.navigationBarTitle(Text("Scenes"), displayMode: .inline)
        //}
    }
}

struct DeviceInSceneView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceInSceneView(dvcObj: LoadJSONData(), device: Device(id: 0, device_name: "test", device_custom_name: nil, glyph: nil, is_active: false, type: "Switch", value: 0.0, max_level: nil, room: nil))
    }
}
