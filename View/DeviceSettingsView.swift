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
    @State var roomIndex = 0
    @State var moduleIndex = 0
    @State var isFavorite : Bool = false
    @State private var sceneIndex = 0
    @State var showInState : Bool = false
    @State var showPicker : Bool = false
    @State var showModulePicker : Bool = false
    @Binding var sd : Device?
    
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Function Name"), footer: Text("Entitled function name will appear in main screen.")) {
                    HStack{
                        NavigationLink(destination: GlyphSelectionView(selectedGlyph: $device.glyph, glyphArray: glyphSceneArray) ){
                            EmptyView()
                        }
                        .hidden()
                        .frame(width:0)
                        Image(systemName: device.glyph )
                            .font(.system(size:17, weight: .semibold))
                            .padding(4)
                            .frame(width:30,height:30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color(.systemOrange), lineWidth: 2)
                            ).onChange(of: device.glyph){_ in
                                dvcObj.updateBackendDevice(device: device)
                            }
                        
                        //                        }
                        TextField("Name", text: $device.device_name, onEditingChanged: { isStarted in
                            print("isStarted: \(isStarted)")
                            if(!isStarted){
                                dvcObj.updateBackendDevice(device: device)
                            }
                        })
                        .onChange(of: device.device_name){ _ in
                            dvcObj.updateDevice(device: device)
                        }
                        .disableAutocorrection(true)
                    }.padding(.leading,-20)
                }
                Section(){
                    HStack{
                        Text("Room")
                        Spacer()
                        Text(getRoomFrom(rooms: dvcObj.rooms, device: device))
                            .foregroundColor(.orange)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        //                        withAnimation(.linear(duration:0.2)){
                        self.showPicker.toggle()
                        //                        }
                    })
                    if self.showPicker {
                        Picker(selection: $roomIndex, label: Text("Room")) {
                            ForEach(dvcObj.rooms,id: \.id){
                                Text($0.room_name).tag($0.id)
                            }
                        }.onChange(of: roomIndex){ end in
                            print(end)
                            print("picker changed index: \(roomIndex)")
                            device.room = roomIndex
                            print(device.room)
//                            device.room = dvcObj.rooms[roomIndex-1].id
                            dvcObj.changeRoomInSceneDevices(device: device, toId: roomIndex)
                            dvcObj.updateDevice(device: device)
                            dvcObj.updateBackendDevice(device: device)
                        }
                        .pickerStyle(InlinePickerStyle())
                    }
                    Toggle(isOn: $isFavorite) {
                        Text("Add to Favorite")
                    }
                }
                Section(){
                    HStack{
                        Text("Module")
                        Spacer()
                        Text(getModuleNameFrom(modules: dvcObj.modules, device: device))
                            .foregroundColor(.orange)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        //                        withAnimation(.linear(duration:0.2)){
                        self.showModulePicker.toggle()
                        //                        }
                    })
                    if self.showModulePicker {
                        Picker(selection: $moduleIndex, label: Text("Module")) {
                            ForEach(dvcObj.modules,id: \.id){
                                Text($0.module_name).tag($0.id)
                            }
                        }.onChange(of: moduleIndex){ _ in
                            print("picker changed")
//                            device.module_id = dvcObj.modules[moduleIndex-1].id
                            dvcObj.changeModuleInSceneDevices(device: device, toId: moduleIndex)
                            dvcObj.updateDevice(device: device)
                            dvcObj.updateBackendDevice(device: device)
                        }
                        .pickerStyle(InlinePickerStyle())
                    }
                }
                Section(){
                    NavigationLink(
                        destination: DeviceInSceneView(dvcObj: dvcObj,device: device),
                        label: {
                            HStack{
                                Text("Scenes")                                    
                                Spacer()
                                Text("\(dvcObj.getDeviceInScenes(device: device).count)")
                            }
                        })
                }
                Button(action:{dvcObj.deleteBackendDevice(device: device)
                    dvcObj.deleteDevice(device: device)
                    dvcObj.removeDevicesFromScene(device: device)
                    self.sd = nil
                    //                    dvcObj.loadData()
                }){
                    Text("Delete device").foregroundColor(Color(.systemRed))
                }
            }
            Spacer()
        }.navigationBarTitle(Text(""),displayMode: .inline)
        .onAppear(perform:{
            print(device)
        })
    }
}

struct DeviceSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSettingsView(dvcObj: LoadJSONData(), device: .constant(Device(id: 0, device_name: "Device Name", device: nil, reseting: false, glyph: "lightbulb", is_active: true, type: "Levels", value: 1.0, max_level: 3, room: 1, processing: 0)),sd:.constant(nil))
    }
}
