//
//  FirstRunView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 21/03/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI
import Combine

struct NewHome {
    var homeName: String
    var roomName: String
    var modules : [String]
    var sensors: [newSensor]
}

struct newSensor : Hashable, Encodable {
    var sensorName:String
    var sensorType:String
    var arduinoPin: Int
    var assignedModule: String
}

struct newModule : Hashable, Identifiable {
    let id = UUID()
    var moduleName: String
    var sensors: [newSensor] = []
}

struct FirstRunView: View {
    //to delete later
    @AppStorage("logged_status") var validated = false
    @AppStorage("first_run_done") var firstRunDone = false
    @AppStorage("register") var register = false
    
    //to delete
    
    @ObservedObject var loginMng = loadLoginJSONData()
    @State var homeName : String = ""
    @State var moduleName : String = ""
    @State var modules : [String] = []
    @State var roomName : String = ""
    @State var sensorName : String = ""
    @State var sensorTypeArray : [String] = ["Temperature","Humidty","Temperature and Humidity"]
    @State var sensorType : String = "Temperature"
    @State var assignedToModule : String = ""
    @State var sensors : [newSensor] = []
    @State var showPicker : Bool = false
    @State var showPickerMod : Bool = false
    
    @State var pin : String = ""
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Set Home Name")) {
                    TextField("e.g. Sweet Home", text: $homeName, onEditingChanged: { editing in
                        if !editing{
                            
                        }
                    }).disableAutocorrection(true)
                }
                Section(header: Text("Set Defaul Room Name"),footer: Text("Set default room name. This room cannot be edited later.")) {
                    TextField("e.g Bedroom", text: $roomName, onEditingChanged: { editing in
                        if !editing{
                            
                        }
                    }).disableAutocorrection(true)
                }
                Section(header: Text("Add Modules"),footer: Text("Set default module name. This module cannot be edited later.")) {
                    List{
                        ForEach(modules, id: \.self){ module in
                            
                            Text(module)
                            
                        }.onDelete(perform: { indexSet in
                            
                            let deletedModuleIndex = Array(indexSet)[0]
                            print(deletedModuleIndex)
                            modules.remove(atOffsets: indexSet)
                        })
                        HStack{
                            TextField("Module Name",text: $moduleName)
                                .disableAutocorrection(true)
                            Button(action:{
                                modules.isEmpty ? assignedToModule = moduleName : nil
                                modules.append(moduleName)
                                moduleName = ""
                            } ){
                                Text("Create Module")
                            }.disabled(moduleName == "" ? true : false)
                            .help(Text("Help Content"))
                        }
                    }
                }
                Section(header: Text("Add Sensors"),footer: Text("Add sensor to your initial home \n • Select sensor type \n • Assign to created module \n • Assign to ArduinoPin ")) {
                    List{
                        ForEach(sensors, id: \.self){ sensor in
                            VStack(alignment: .leading){
                                HStack{
                                    Text(sensor.sensorName)
                                    Spacer()
                                    Text(String(sensor.arduinoPin))
                                }
                                Text(sensor.sensorType)
                                Text("\(sensor.assignedModule)")
                            }
                        }.onDelete(perform: { indexSet in
                            
                            let deletedModuleIndex = Array(indexSet)[0]
                            print(deletedModuleIndex)
                            sensors.remove(atOffsets: indexSet)
                        })
                        VStack{
                            HStack{
                                Text("Sensor Type")
                                Spacer()
                                Text(sensorType)
                                    .foregroundColor(.orange)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture(perform: {
                                //withAnimation(.linear(duration:0.2)){
                                self.showPicker.toggle()
                                //}
                            })
                            if self.showPicker {
                                Picker(selection: $sensorType, label: Text("Sensor")) {
                                    ForEach(sensorTypeArray,id: \.self){
                                        Text($0).tag($0)
                                    }
                                }.onChange(of: sensorType){ _ in
                                    print("picker changed")
                                    //device.room = dvcObj.rooms[roomIndex-1].id
                                }
                                .pickerStyle(InlinePickerStyle())
                            }
                            
                            HStack{
                                Text("Assign to module")
                                Spacer()
                                Text(assignedToModule)
                                    .foregroundColor(.orange)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture(perform: {
                                //withAnimation(.linear(duration:0.2)){
                                self.showPickerMod.toggle()
                                //}
                            })
                            if self.showPickerMod {
                                Picker(selection: $assignedToModule, label: Text("Sensor")) {
                                    ForEach(modules,id: \.self){
                                        Text($0).tag($0)
                                    }
                                }.onChange(of: assignedToModule){ _ in
                                    print("picker changed")
                                    //device.room = dvcObj.rooms[roomIndex-1].id
                                }
                                .pickerStyle(InlinePickerStyle())
                            }
                            HStack{
                                Text("Arduino Pin")
                                Spacer()
                                TextField("Pin",text: $pin).frame(width:25)
                                    .disableAutocorrection(true)
                                    .keyboardType(.numberPad)
                                    .onReceive(Just(pin)) { newValue in
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        if filtered != newValue {
                                            self.pin = filtered
                                        }
                                    }
                            }
                            HStack{
                                TextField("Sensor Name",text: $sensorName)
                                    .disableAutocorrection(true)
                                Button(action:{
                                    let sensor =  newSensor(sensorName: sensorName, sensorType: sensorType, arduinoPin: Int(pin) ?? 1, assignedModule: assignedToModule)
                                    sensors.append(sensor)
                                    sensorName = ""
                                } ){
                                    Text("Create Sensor")
                                }.disabled(sensorName == "" ? true : false)
                                .help(Text("Help Content"))
                            }
                        }
                    }
                }
                Button(action:{
                    let newHome = NewHome(homeName: homeName, roomName: roomName, modules: modules, sensors: sensors)
                    print(newHome)
                    loginMng.loadfirstRunData(newHome: newHome)
                    //do create
                } ){
                    Text("Create new Home")
                }.disabled(homeName == "" || modules.count < 1 || roomName == "")
                Button(action:{
                    validated = false
                    register = false
                }){
                    Text("Back to login")
                }
            }
            .navigationTitle("First Run")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct FirstRunView_Previews: PreviewProvider {
    static var previews: some View {
        FirstRunView()
    }
}
