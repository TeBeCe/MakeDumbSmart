//
//  AutomatizationsView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 05/04/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct AutomatizationViewSummaryItem: View {
    @ObservedObject var dvcObj : LoadJSONData
    var automatization : Automatization
    @State var addAutType : automatizationType? = nil
    @State var showing :Bool =  false


    var body: some View {
        VStack(alignment: .leading){
            HStack{
                if(automatization.time != nil){
                    Image(systemName: "clock.fill")
                }
                else{
                    Image(systemName: "antenna.radiowaves.left.and.right")
                }
                Image(systemName: "arrow.right")
                ForEach(automatization.devices ){device in
                    Image(systemName: "\(device.glyph)")
                }
                ForEach(automatization.scenes ){scene in
                    Image(systemName: "\(scene.glyph)")
                }
            }.font(.system(size:23))
            HStack{
                if(automatization.time != nil){
                    NavigationLink(destination: ModifyTimeAutomatization(dvcObj: dvcObj, addAutType: $addAutType, automatization: automatization, showSelf: $showing) ){
                        Text("\(automatization.time ?? "") \(footerDaysRepeat(selectedDays: automatization.days ?? [], footerDayType: .short))")}
                }
                else {
                    let sensor = dvcObj.getSensor(id: automatization.sensor_id!)
                    Text("\(sensor?.device_name ?? "null") value \(automatization.sensor_condition! ? "more" : "less") than \(String(format: "%.0f%",automatization.sensor_value!)) ") + Text("\(sensor != nil && sensor!.type.contains("temperature") ? "°C" : "%" )")
                }
            }
            HStack{
                Text("\(getSceneAndDeviceLabel(automatization: automatization))")
            }
        }
    }
}

struct AutomatizationsView: View {
    @ObservedObject var dvcObj : LoadJSONData
    @Binding var activeSheet: ActiveSheet?
    @State var automatization: Automatization? = nil
    @State var addAutType : automatizationType? = nil
    @State var showing :Bool =  false
    //    var aut : [Automatization] = [
    //        Automatization(id: 1,devices: exampleDeviceArray,scenes: [], days: [true,true,true,true,true,true,true], sensor: Device(id: 1, device_name: "Sensor name",device: "Cust name", reseting: false,glyph: "lightbulb", is_active: false, type: "sensor_temperature", value: Float(19.0), max_level: 3, room: 1, processing: 0),value: 27.0,condition: true),
    //        Automatization(id: 2,devices: [],scenes: [], time: Date.init(), days: [true,true,false,true,true,true,true])]
    var body: some View {
        NavigationView {
            VStack{
                Form {
                    Section(header:
                                VStack(alignment: .leading){
                                    Text("Automatizations")
                                        .textCase(nil)
                                        .font(.system(size:25, weight: .semibold))
                                        .foregroundColor(Color(UIColor.init(named:"textColor")!))
                                    Text("Allow your devices to react based on time or sensor values.")
                                        .textCase(nil)
                                        .foregroundColor(Color(UIColor.init(named:"textColor")!))
                                    
                                }){
                        //                List{
                        ForEach(dvcObj.automatizations.indices, id: \.self){ind in
                            if(dvcObj.automatizations[ind].id != 0){
                                AutomatizationViewSummaryItem(dvcObj: dvcObj, automatization: dvcObj.automatizations[ind])
                            }
                        }.onDelete(perform: { indexSet in
                            let deletedAutIndex = Array(indexSet)[0]
                            dvcObj.deleteBackendAutomatization(automatization: dvcObj.automatizations[deletedAutIndex])
                            dvcObj.automatizations.remove(atOffsets: indexSet)
                        })
                        //                }
                        //                .listStyle(InsetGroupedListStyle())
                    }
                    NavigationLink(destination: AddTimeAutomatizationView(dvcObj: dvcObj,addAutType: $addAutType, showSelf: $showing), isActive: $showing ){
                                            Button(action:{}){
                                                Text("Add time based automatization")
                                            }
                                        }
//                                        NavigationLink(destination: AddSensorBasedAutomatizationView(dvcObj: dvcObj)){
//                                            Button(action:{}){
//                                                Text("Add sensor based automatization")
//                                            }
//                                        }
                    Button(action:{
                        addAutType = .time
                    }){
                        Text("Add time based automatization")
                    }
                    Button(action:{
                        addAutType = .sensor
                    }){
                        Text("Add sensor based automatization")
                    }
                }
                .sheet(item: $addAutType){ item in
                    switch item {
                    case .time:
                        AddTimeAutomatizationView(dvcObj: dvcObj, addAutType: $addAutType, showSelf: $showing)
                    case .sensor:
                        AddSensorBasedAutomatizationView(dvcObj: dvcObj, addAutType: $addAutType)
                    }
                }
            }
            .navigationBarTitle(Text("Add New Automatization"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action:{self.activeSheet = nil}){
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size:25, weight: .bold)).accentColor(.gray)})
        }.onAppear(perform: {
            dvcObj.continueRefresh = false
        })
        .onDisappear(perform: {
            print("dissapear :(")
            dvcObj.continueRefresh = true
            dvcObj.loadData()
        })
    }
}

struct AutomatizationsView_Previews: PreviewProvider {
    static var previews: some View {
        AutomatizationsView(dvcObj:LoadJSONData(), activeSheet: .constant(nil))
        //            .environmentObject(LoadJSONData())
    }
}
