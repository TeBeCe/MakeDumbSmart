//
//  ModifySensorAutomatization.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 09/04/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct ModifySensorAutomatization: View {
    @ObservedObject var dvcObj : LoadJSONData
    @Binding var addAutType: automatizationType?
    @State var sheetAutomatization: Automatization? = nil
    @State var automatization = Automatization(id: 0,devices:[],scenes: [],time: nil)
    @State var selectedDevice : Device? = nil
    @State var condition:Int = 0
    @State var selectedSensorID: Int = 0
    @State var selectedSensor: Device? = nil
    @State var minValue : Double = 0
    @State var activationValue: Double = 0
    @Binding var showSelf : Bool

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
                Section(header: Text("Select Sensor"), footer: footerDevices){
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(dvcObj.devices.filter({$0.type.contains("sensor")})){dvc in
                                CheckableSensorView(device: dvc,rooms:dvcObj.rooms,checked: dvc.id == automatization.sensor_id)
                                    .onTapGesture{
                                        if(automatization.sensor_id != dvc.id){
                                            automatization.sensor_id = dvc.id
                                            selectedSensor = dvc
                                        }
                                        else{
                                            automatization.sensor_id = 0
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
                                        dvcObj.updateAutomatization(automatization: automatization)
                                        dvcObj.updateBackendAutomatization(automatizationx: automatization)
                                    }
                            }
                        }
                    }
                    Picker("Options", selection: $condition) {
                        ForEach(0 ..< settings.count) { index in
                            Text(self.settings[index])
                                .tag(index)
                        }
                        
                    }
                    .onChange(of: condition){ end in
                            automatization.sensor_condition = (condition != 0)
                            dvcObj.updateAutomatization(automatization: automatization)
                            dvcObj.updateBackendAutomatization(automatizationx: automatization)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack{
                        Text("Activation Value:")
                        Spacer()
                        Text("\(String(format: "%.0f%", activationValue))") + Text("\(selectedSensor?.type == "sensor_temperature" ? "°C" : "%")")
                    }
                    Slider(value: $activationValue,
                           in: minValue...100,
                           step:1,
                           onEditingChanged: { data in
                            if(!data){
                                automatization.sensor_value = Float(activationValue)
                                dvcObj.updateAutomatization(automatization: automatization)
                                dvcObj.updateBackendAutomatization(automatizationx: automatization)
                            }
                           },
                           minimumValueLabel: Text("\(String(format: "%.0f%",minValue))"),
                           maximumValueLabel: Text("100"),label:{Text("\(String(format: "%.0f%", activationValue))")})
//                        .onEditng
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
                    Button(action: {
                        self.sheetAutomatization = automatization
                    }){
                        Text("Add/Remove Accesories").foregroundColor(Color(.systemOrange))
                    }.sheet(item: $sheetAutomatization){ automatization in
                        AssignDevicesToAutomationView(dvcObj: dvcObj, automatization: $automatization, devicesInRoom: dvcObj.getDevicesInRooms())
                    }
                }
            }.sheet(item: $selectedDevice){ device in
                SceneDeviceDetailView(sd: $selectedDevice, dvcObj: dvcObj, device: device, automatization: automatization)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarHidden(true)
//            .navigationBarTitle(Text("Sensor Based Automatization"), displayMode: .inline)
//            .navigationBarItems(trailing: Button(action:{
//                self.addAutType = nil
//            }){
//                Image(systemName: "xmark.circle.fill")
//                    .font(.system(size:25, weight: .bold)).accentColor(.gray)})
        }.onAppear(perform: {
            dvcObj.continueRefresh = false
            condition = automatization.sensor_condition ?? false ? 1 : 0
            selectedSensor = dvcObj.getSensor(id: automatization.sensor_id ?? 0)
            minValue = selectedSensor?.type == "sensor_temperature" ? -100.0 : 0
            activationValue = Double(automatization.sensor_value ?? 0)
        })
        
    }
    private var footerDevices : some View {
        
           VStack(alignment: .leading){
            if(automatization.devices.count > 0){
                Text("Devices")
                    .textCase(nil)
                    .font(.system(size:25, weight: .semibold))
                    .foregroundColor(Color(UIColor.init(named:"textColor")!))
                Text("Configure devices in automatization by taping or holding devices")
                    .textCase(nil)
                    .foregroundColor(Color(UIColor.init(named:"textColor")!))
            }
            else{
                Text("")
            }
        }
       
    }
}

struct ModifySensorAutomatization_Previews: PreviewProvider {
    static var previews: some View {
        ModifySensorAutomatization(dvcObj: LoadJSONData(), addAutType: .constant(nil), showSelf: .constant(true))
    }
}
