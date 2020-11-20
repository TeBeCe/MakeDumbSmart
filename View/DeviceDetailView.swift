//
//  DeviceDetailView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 13/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

func DetermineValue(device: Device)-> String {
    
    switch device.type{
    case "Switch" :
        return device.value == 0.0 ? "Vyp." : "Zap."
    case "Slider" :
        return device.value == 0.0 ? "Vyp." : "\(String(format: "%.1f%", device.value))%"
    case "Levels" :
        return device.value == 0.0 ? "Vyp." : "\(String(format: "%.0f%", device.value))"
        
    default:
        return "Unknown device type/state"
    }
}

struct DeviceDetailView: View {
    @ObservedObject var dvcObj : LoadJSONData
    @State var device : Device
    var body: some View {
        NavigationView(){
            VStack{
                Capsule()
                    .fill(Color.secondary)
                    .frame(width: 40, height: 8)
                                .padding(.top,10)
                                .padding(.bottom,5)
                
                HStack(){
                    Image(systemName:getGlyph(device: device)).foregroundColor(Color(UIColor.systemGray2))
                        .font(.system(size:40, weight: .bold))
                    
                    VStack(alignment: .leading){
                        Text(device.device_name)
                            .font(.system(size: 20, weight: .bold))
                        
                        Text(DetermineValue(device: device))
                            .font(.system(size: 20, weight: .semibold ))
                    }
                    Spacer()
                }.padding(.leading, 20)
                
                Spacer()
                
                switch device.type{
                case "Switch":
                    DeviceFunctionSwitchView(dvcObj: dvcObj, device: $device)
                        .frame(width: 140, height: 400, alignment: .center)
                        .accentColor(.white)
                    
                case "Slider":
                    DeviceFunctionSliderView(dvcObj: dvcObj, device: $device)
                        .frame(width: 140, height: 400, alignment: .center)
                        .accentColor(.white)
                    
                case "Levels":
                    DeviceFunctionLevelView(dvcObj: dvcObj, device: $device, levelArr: CalculateLevels(levels: device.max_level!))
                        .frame(width: 140, height: 400, alignment: .center)
                        .accentColor(.white)
                    
                default:
                    Spacer()
                }
                Spacer()
                HStack(alignment: .top){
                    Spacer()
                    
                    NavigationLink(
                        destination: DeviceSettingsView(dvcObj: dvcObj,device: $device),
                        label: {
                            Image(systemName: "gear")
                                .font(.system(size:30, weight: .bold))
                        }).navigationBarHidden(true).accentColor(.gray)
                }.padding([.trailing,.bottom], 20)
            }
        }
    }
}

struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailView(dvcObj: LoadJSONData(), device: Device(id: 0, device_name: "Test Name", device_custom_name: nil, glyph: nil , is_active: false, type: "Slider", value: Float(Int(1.0)), max_level: 3))
            .preferredColorScheme(.dark)
    }
}
