//
//  DeviceSettingsView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 19/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct DeviceSettingsView: View {
    @ObservedObject var dvcObj : LoadJSONData
    @Binding var device : Device
    @State private var roomIndex = 0
    @State var isFavorite : Bool = false
    @State private var sceneIndex = 0
    @State var showInState : Bool = false
    var body: some View {
        VStack{
            Form{
                Section(){
                    TextField("Name", text: $device.device_name)
                        .onChange(of: device.device_name){ _ in
                            dvcObj.updateDevice(device: device)
                        }
                }
                Section(){
                    Picker(selection: $roomIndex, label: Text("Room")) {
                        ForEach(0 ..< dvcObj.rooms.count) {indx in
                            Text(self.dvcObj.rooms[indx].room_name)
                        }
                    }.onChange(of: roomIndex){ _ in
                        device.room = roomIndex
                        dvcObj.updateDevice(device: device)
                    }
                    //                .pickerStyle(InlinePickerStyle())
                    Toggle(isOn: $isFavorite) {
                        Text("Add to Favorite")
                    }
                }
                Section(){
                    Picker(selection: $sceneIndex, label: Text("Scene")) {
                        ForEach(0 ..< dvcObj.scenes.count) {indx in
                            Text(self.dvcObj.scenes[indx].scene_name)
                        }
                    }
                }
                Section(){
                    Toggle(isOn: $isFavorite) {
                        Text("Add to Favorite")
                    }
                }
            }
            Spacer()
        }.navigationBarTitle(Text(""),displayMode: .inline)
//        .navigationBarHidden(true)
    }
}

struct DeviceSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSettingsView(dvcObj: LoadJSONData(), device: .constant(Device(id: 0, device_name: "Device Name", device_custom_name: nil, glyph: nil, is_active: true, type: "Levels", value: 1.0, max_level: 3)))
    }
}
