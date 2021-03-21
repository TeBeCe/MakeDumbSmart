//
//  SensorDetailView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 31/01/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct SensorDetailView: View {
    @Binding var sd : Device?
    @ObservedObject var dvcObj : LoadJSONData
    @ObservedObject var sensorObj = LoadJSONSensorData()

    @State var device : Device
    @State var test : Bool = false
    var body: some View {
        NavigationView(){
            VStack{
                Spacer()
                SensorChartsView(data: sensorObj.data, device: device)
//                SensorChartsView(device: device)
                    .onAppear(perform: {
                    sensorObj.loadData(param: "device_id=1" +
                                       "&sensor_type=\(device.type == "sensor_temperature" ? "temp":"humid")")
                })
                    
                Spacer()
                HStack(alignment: .top){
                    Spacer()

                    NavigationLink(
                        destination: DeviceSettingsView(dvcObj: dvcObj,device: $device,roomIndex: device.room , sd: $sd),
                        label: {
                            Image(systemName: "gear")
                                .font(.system(size:30, weight: .bold))
                        })
//                        .onTapGesture {
//                            print("tap")
//                            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
//                                        impactHeavy.impactOccurred()
//                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .accentColor(.gray)
                }.padding([.trailing,.bottom], 20)
            }
                .navigationBarItems(leading:
                                    HStack(){
                                        Image(systemName:device.glyph)
                                            .foregroundColor(Color(UIColor.systemGray2))
                                            .font(.system(size:35, weight: .semibold))

                                        VStack(alignment: .leading){
                                            Text(device.device_name)
                                                .font(.system(size: 18, weight: .bold))

                                            Text(DetermineValue(device: device))
                                                .font(.system(size: 18, weight: .semibold ))
                                        }
                                        Spacer()
                                    }, trailing: Button(action:{self.sd = nil}){Image(systemName: "xmark.circle.fill")
                                        .font(.system(size:25, weight: .bold)).accentColor(.gray)})
        }.onAppear(perform: {
            dvcObj.continueRefresh = false
        })
        .onDisappear(perform: {
            dvcObj.continueRefresh = true
            dvcObj.loadData()
        })
    
    }
}

struct SensorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SensorDetailView(sd: .constant(nil), dvcObj: LoadJSONData(), device: Device(id: 0, device_name: "Test Name", device: nil, reseting: false, glyph: "lightbulb" , is_active: true, type: "Slider", value: Float(Int(1.0)), max_level: 3, room: 1, processing: 0))
    }
}
