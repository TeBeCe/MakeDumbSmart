//
//  AddTimeAutomatizationView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 07/04/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct AddTimeAutomatizationView: View {
    @ObservedObject var dvcObj : LoadJSONData
    @Binding var addAutType: automatizationType?
    @State var sheetAutomatization: Automatization? = nil
    @State var days : [String]=[] //["mo","tu","we","th","fr","sa","su"]
    @State var automatization = Automatization(id: 0,devices:[],scenes: [],time: getStringFromDate(date: Date()))
    @State var selectedDays : [Bool] = Array.init(repeating: true, count: 7)
    @State var time = Date()
    @State var selectedDevice : Device? = nil
    @Binding var showSelf : Bool

    let columns = [
        //        GridItem(.flexible()),
        //        GridItem(.flexible()),
        //        GridItem(.flexible())
        GridItem(.adaptive(minimum: 110, maximum: 120))
        
    ]
    
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Time")){
                    HStack{
                        Text("Activation Time")
                        DatePicker("Activation Time", selection: $time, displayedComponents: .hourAndMinute)
                            .datePickerStyle(GraphicalDatePickerStyle())
                    }
                }
                .padding(.top, 10)
                Section(header: Text("Repeating"), footer: footerDevices){
                    HStack(){
                        ForEach(0..<7){ind in
                            ZStack{
                                Circle()
                                    .foregroundColor(selectedDays[ind] ? .orange : .gray)
                                    .onTapGesture {
                                        selectedDays[ind].toggle()
                                        selectionFeedbackGenerator.selectionChanged()
                                    }
                                    .frame(height: 50)
                                Text(days[ind])
                                    .foregroundColor(.white)
                            }
                        }
                    }
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
                        self.automatization.days = selectedDays
                        self.automatization.time = getStringFromDate(date: time)
                        dvcObj.createBackendAutomatization(automatization: automatization)
                        self.addAutType = nil
//                        self.presentation.wrappedValue.dismiss()
                        self.showSelf = false

                    }){
                        Text("Create Automatization")
                    }
                }
            }.sheet(item: $selectedDevice){ device in
                SceneDeviceDetailView(sd: $selectedDevice, dvcObj: dvcObj, device: device, automatization: automatization)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarHidden(true)
//            .navigationBarTitle(Text("Time Based Automatization"), displayMode: .inline)
//            .navigationBarItems(trailing: Button(action:{
//                self.addAutType = nil
//            }){
//                Image(systemName: "xmark.circle.fill")
//                    .font(.system(size:25, weight: .bold)).accentColor(.gray)})
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            let calendar = Calendar(identifier: .gregorian)
            self.days = calendar.weekdaySymbols
            self.days = Array(days[2-1..<days.count]) + days[0..<2-1]
            
            dvcObj.createAutomatization(automatization: automatization)
            dvcObj.continueRefresh = false
        })
        .onDisappear(perform: {
            dvcObj.validateAutomatizations()
        })
    }
    
    private var footerDevices : some View {
           VStack(alignment: .leading){
            Text(footerDaysRepeat(selectedDays: selectedDays, footerDayType: .long))
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

struct AddTimeAutomatizationView_Previews: PreviewProvider {
    static var previews: some View {
        AddTimeAutomatizationView(dvcObj: LoadJSONData(), addAutType: .constant(nil), showSelf: .constant(true))
    }
}
