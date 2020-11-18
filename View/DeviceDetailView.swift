//
//  DeviceDetailView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 13/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct DeviceDetailView: View {
    @ObservedObject var dvcObj : LoadJSONData
    @State var device : Device
    @State var valueStr : String = "Vyp."
    var body: some View {
        VStack{
            HStack(){
                Image(systemName: "square.and.pencil").foregroundColor(Color(UIColor.systemGray2)).font(.system(size:40, weight: .bold))
                VStack(alignment: .leading){
                    Text(device.device_name)
                        .font(.system(size: 20, weight: .bold))
                    
                    Text("\(device.value)")
                        .font(.system(size: 20, weight: .semibold ))
                }
                Spacer()
                Text("x").padding(.trailing, 20)
                    .font(.system(size: 30, weight: .bold))
            }.padding(.leading, 20)
            .padding(.top, 10)
            Spacer()
            
            switch device.type{
            case "Switch":
                DeviceFunctionSwitchView(state: $device.is_active, valueStr: $valueStr, device: $device, dvcObj: dvcObj)
                    .frame(width: 140, height: 400, alignment: .center)
                    .accentColor(.white)

            case "Slider":
                DeviceFunctionSliderView(percentage:Float(device.value) ,valueStr: $valueStr)
                    .frame(width: 140, height: 400, alignment: .center)
                    .accentColor(.white)

            case "Levels":
                DeviceFunctionLevelView(percentage: Float(device.value) ,valueStr: $valueStr)
                    .frame(width: 140, height: 400, alignment: .center)
                    .accentColor(.white)

            default:
                Spacer()
            }
            Spacer()
            HStack(alignment: .top){
                Spacer()
                Text("X")
            }.padding([.trailing,.bottom], 20)
        }
    }
}

struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailView(dvcObj: LoadJSONData(), device: Device(id: 0, device_name: "Test Name", device_custom_name: "test_custom", glyph: "Lamp" , is_active: false, type: "Switch", value: Float(Int(1.0))))
            .preferredColorScheme(.dark)
    }
}
