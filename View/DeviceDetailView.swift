//
//  DeviceDetailView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 13/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct DeviceDetailView: View {
    @Binding var sd : Device?
    @ObservedObject var dvcObj : LoadJSONData
    @State var device : Device
    @State var syncMode = false
    var body: some View {
        NavigationView(){
            VStack{
                Spacer()
                
                switch device.type{
                case "Switch":
                    DeviceFunctionSwitchView(dvcObj: dvcObj, device: $device, syncMode: $syncMode)
                        .frame(width: 140, height: 400, alignment: .center)
                        .accentColor(.white)
                    
                case "Slider":
                    DeviceFunctionSliderView(dvcObj: dvcObj, device: $device, syncMode: $syncMode)
                        .frame(width: 140, height: 400, alignment: .center)
                        .accentColor(.white)
                    
                case "Levels":
                    DeviceFunctionLevelView(dvcObj: dvcObj, device: $device, syncMode: $syncMode, levelArr: CalculateLevels(levels: device.max_level!))
                        .frame(width: 140, height: 400, alignment: .center)
                        .accentColor(.white)
                    
                default:
                    Spacer()
                }
                Spacer()
                HStack(alignment: .top){
                    Button(action: {self.syncMode.toggle()}, label: {
                        Image(systemName: "wrench")
                            .font(.system(size:30, weight: .bold))
                    }).accentColor(syncMode ? .red :.gray)
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: DeviceSettingsView(dvcObj: dvcObj,device: $device,roomIndex: device.room ,sd: $sd),
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
            }.navigationBarItems(leading:
                                    HStack(){
                                        Image(systemName:device.glyph).foregroundColor(Color(UIColor.systemGray2))
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
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailView(sd: .constant(nil), dvcObj: LoadJSONData(), device: Device(id: 0, device_name: "Test Name", device: nil, reseting: false, glyph: "lightbulb" , is_active: true, type: "Slider", value: Float(Int(1.0)), max_level: 3, room: 1, processing: 0))
            .preferredColorScheme(.dark)
    }
}
