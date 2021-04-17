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
    @State var sliderIcons : [String] = ["thermometer.snowflake","thermometer.sun.fill"]
    
    @State var percentage: Float = 50.0 // or some value binded
    
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
                                        selectionFeedbackGenerator.selectionChanged()

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
                                            let correctedStartVal = Double(activationValue ) - minValue
                                            self.percentage = Float((correctedStartVal * 100) / (100 - minValue))
                                            self.sliderIcons = ["thermometer.snowflake","thermometer.sun.fill"]
                                        }
                                        else{
                                            minValue = 0
                                            if(activationValue < 0){
                                                activationValue = 0
                                                automatization.sensor_value = 0
                                            }
                                            let correctedStartVal = Double(activationValue ) - minValue
                                            self.percentage = Float((correctedStartVal * 100) / (100 - minValue))
                                            self.sliderIcons = ["drop","drop.fill"]
                                        }
                                        dvcObj.updateAutomatization(automatization: automatization)
                                        dvcObj.updateBackendAutomatization(automatizationx: automatization)
                                    }
                            }
                        }
                    }
                    
                    HStack{
                        Text("Condition:")
                        Picker("Options", selection: $condition) {
                            ForEach(0 ..< settings.count) { index in
                                Text(self.settings[index])
                                    .tag(index)
                            }
                        }
                        .onChange(of: condition){ end in
                            selectionFeedbackGenerator.selectionChanged()
                            automatization.sensor_condition = (condition != 0)
                            dvcObj.updateAutomatization(automatization: automatization)
                            dvcObj.updateBackendAutomatization(automatizationx: automatization)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                    }
                    
//                    HStack{
//                        Text("Activation Value:")
//                        Spacer()
//                        Text("\(String(format: "%.0f%", activationValue))") + Text("\(selectedSensor?.type == "sensor_temperature" ? "°C" : "%")")
//                    }
//                    Slider(value: $activationValue,
//                           in: minValue...100,
//                           step:1,
//                           onEditingChanged: { data in
//                            if(!data){
//                                automatization.sensor_value = Float(activationValue)
//                                dvcObj.updateAutomatization(automatization: automatization)
//                                dvcObj.updateBackendAutomatization(automatizationx: automatization)
//                            }
//                           },
//                           minimumValueLabel: Text("\(String(format: "%.0f%",minValue))"),
//                           maximumValueLabel: Text("100"),label:{Text("\(String(format: "%.0f%", activationValue))")})
                    slider
                    //.onEditng
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
                Section(){
                    Button(action: {
                        dvcObj.deleteBackendAutomatization(automatization: automatization)
                        self.showSelf = false
                    }){
                        Text("Delete Automatization").foregroundColor(.red)
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
            sliderIcons = selectedSensor?.type == "sensor_temperature" ? ["thermometer.snowflake","thermometer.sun.fill"] : ["drop","drop.fill"]
            activationValue = Double(automatization.sensor_value ?? 0)
            
            let correctedStartVal = Double(automatization.sensor_value ?? 0) - minValue
            self.percentage = Float((correctedStartVal * 100) / (100 - minValue))
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
    
    var slider: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .leading) {
                
                Rectangle()
                    //                        .foregroundColor(.gray)
                    .foregroundColor(Color(UIColor(.init(.systemGray3))))
                
                Rectangle()
                    //                        .foregroundColor(.accentColor)
                    .foregroundColor(Color(UIColor(.init(.systemGray))))
                    
                    .frame(width: geometry.size.width * CGFloat(self.percentage / 100))
                    .animation(.linear(duration: 0.1))
                
                HStack{
                    Image(systemName: sliderIcons[0])
                    Spacer()
                    Text("\(String(format: "%.0f%",activationValue))") + Text("\(selectedSensor?.type == "sensor_temperature" ? "°C" : "%")")
                    Spacer()
                    Image(systemName: sliderIcons[1])
                    
                }.padding(.horizontal,5)
            }
            .cornerRadius(12)
            .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
                            self.activationValue =  ((100 - minValue) * (Double(percentage)/100) + minValue).rounded()
                        }).onEnded({_ in
                            automatization.sensor_value = Float(activationValue)
                            dvcObj.updateAutomatization(automatization: automatization)
                            dvcObj.updateBackendAutomatization(automatizationx: automatization)
                        })
            )
        }
    }
}

struct ModifySensorAutomatization_Previews: PreviewProvider {
    static var previews: some View {
        ModifySensorAutomatization(dvcObj: LoadJSONData(), addAutType: .constant(nil), showSelf: .constant(true))
    }
}
