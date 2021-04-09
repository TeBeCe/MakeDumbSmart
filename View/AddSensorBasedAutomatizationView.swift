//
//  AddSensorBasedAutomatizationView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 07/04/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct AddSensorBasedAutomatizationView: View {
    @ObservedObject var dvcObj : LoadJSONData
    @Binding var addAutType: automatizationType?
    @State var sheetAutomatization: Automatization? = nil
    @State var automatization = Automatization(id: 0,devices:[],scenes: [],time: nil)
    @State var selectedDevice : Device? = nil
    @State var condition:Int = 0
    @State var selectedSensorID: Int = 0
    @State var selectedSensor: Device? = nil
    @State var minValue : Double = 0
    @State var maxValue : Double = 100
    @State var activationValue: Double = 0
//    @Environment(\.presentationMode) var presentation
    var settings = ["Less", "More"]
    
    let columns = [
        //        GridItem(.flexible()),
        //        GridItem(.flexible()),
        //        GridItem(.flexible())
        GridItem(.adaptive(minimum: 110, maximum: 120))
        
    ]
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Select Sensor")){
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(dvcObj.devices.filter({$0.type.contains("sensor")})){dvc in
                                CheckableSensorView(device: dvc,rooms:dvcObj.rooms,checked: dvc.id == selectedSensorID)
                                    .onTapGesture{
                                        if(selectedSensorID != dvc.id){
                                            selectedSensorID = dvc.id
                                            selectedSensor = dvc
                                        }
                                        else{
                                            selectedSensorID = 0
                                            selectedSensor = nil
                                        }
                                        if(selectedSensor?.type == "sensor_temperature"){
                                            minValue = -100
                                        }
                                        else{
                                            minValue = 0
                                            if(activationValue < 0){
                                                activationValue = 0
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    Picker("Options", selection: $condition) {
                        ForEach(0 ..< settings.count) { index in
                            Text(self.settings[index])
                                .tag(index)
                        }
                        
                    }.pickerStyle(SegmentedPickerStyle())
                    HStack{
                        Text("Activation Value:")
                        Spacer()
                        Text("\(String(format: "%.0f%", activationValue))")
                    }
                    Slider(value: $activationValue,
                           in: minValue...maxValue,
                           step:1,
                           minimumValueLabel: Text("\(String(format: "%.0f%",minValue))"),
                           maximumValueLabel: Text("\(String(format: "%.0f%",maxValue))"),label:{Text("\(String(format: "%.0f%", activationValue))")})
                    
                }
                if(automatization.devices.count > 0){
                VStack(alignment: .leading){
                    Text("Automatizations")
                        .textCase(nil)
                        .font(.system(size:25, weight: .semibold))
                        .foregroundColor(Color(UIColor.init(named:"textColor")!))
                    Text("Allow your devices to react based on time or sensor values.")
                        .textCase(nil)
                        .foregroundColor(Color(UIColor.init(named:"textColor")!))
                    
                }.listRowBackground(Color(UIColor.init(named:"bgColor")!))
                }
                ForEach(dvcObj.getDevicesInAutomatization(automatization: automatization)){ dvcsInRoom in
                    Section(header: Text(dvcsInRoom.roomName)){
                        LazyVGrid(columns: columns,spacing: 10){
                            ForEach(dvcsInRoom.devices.indices,id: \.self){ indx in
                                let arrr = dvcObj.modifyDeviceInAutomatization(automatization: automatization, device: dvcsInRoom.devices[indx])
                                DevicesView(device:dvcObj.automatizations[arrr[0]].devices[arrr[1]], rooms:dvcObj.rooms, showSpinner: false)
                                    .onTapGesture{
                                        if(!dvcObj.automatizations[arrr[0]].devices[arrr[1]].is_active && dvcObj.automatizations[arrr[0]].devices[arrr[1]].value == 0.0 ){
                                            dvcObj.automatizations[arrr[0]].devices[arrr[1]].value = Float(dvcObj.automatizations[arrr[0]].devices[arrr[1]].max_level ?? 1)
                                            print("set to max")
                                        }
                                        dvcObj.automatizations[arrr[0]].devices[arrr[1]].is_active.toggle()
                                        print(dvcObj.automatizations[arrr[0]].devices[arrr[1]])
                                    }
                                    .onLongPressGesture{
                                        print("long")
                                        self.selectedDevice = dvcObj.automatizations[arrr[0]].devices[arrr[1]]
                                    }
                            }
                        }.padding(.leading,-20).padding(.trailing,-20)
                    }.listRowBackground(Color(UIColor.init(named:"bgColor")!))
                }
                Section(){
                    //                    NavigationLink(destination: AssignDevicesToAutomationView(dvcObj: dvcObj, automatization: $automatization,devicesInRoom: dvcObj.getDevicesInRooms())){
                    //                        Text("Add/Remove Accesories").foregroundColor(Color(.systemOrange))
                    //                    }
                    Button(action: {
                        self.sheetAutomatization = automatization
                    }){
                        Text("Add/Remove Accesories").foregroundColor(Color(.systemOrange))
                    }.sheet(item: $sheetAutomatization){ automatization in
                        AssignDevicesToAutomationView(dvcObj: dvcObj, automatization: $automatization, devicesInRoom: dvcObj.getDevicesInRooms())
                    }
                }
                Section(){
                    
                    Button(action: {
                        self.automatization.sensor_id = selectedSensorID
                        self.automatization.sensor_condition = (condition != 0)
                        self.automatization.sensor_value = Float(activationValue)
                        dvcObj.createBackendAutomatization(automatization: automatization)
                        self.addAutType = nil
                        
                    }){
                        Text("Create Automatization")
                    }.disabled(selectedSensorID == 0)
                }
            }.sheet(item: $selectedDevice){ device in
                SceneDeviceDetailView(sd: $selectedDevice, dvcObj: dvcObj, device: device, automatization: automatization)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("Sensor Based Automatization"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action:{
                self.addAutType = nil
            }){
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size:25, weight: .bold)).accentColor(.gray)})
        }.onAppear(perform: {
            dvcObj.createAutomatization(automatization: automatization)
            dvcObj.continueRefresh = false
        })
        
    }
}

struct AddSensorBasedAutomatizationView_Previews: PreviewProvider {
    static var previews: some View {
        AddSensorBasedAutomatizationView(dvcObj: LoadJSONData(), addAutType: .constant(nil))
    }
}
