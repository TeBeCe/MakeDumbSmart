//
//  DevicesView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 03/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

func getGlyph(device:Device)->String{
    switch(device.type){
        case "Levels":
            return "lineweight"
        case "Slider":
            return "lightbulb"
        case "Switch":
            return "switch.2"
        default:
            return "exclamationmark.octagon"
    }
}

struct DevicesView: View {
    var device : Device
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:20, style: .continuous)
                .fill(Color(UIColor.init(named:"mainColor") ?? UIColor.gray))
                .opacity(device.is_active ? 1.0 : 0.7)
                .frame(width: 120, height: 120)
            
            VStack(alignment: .leading){
                
                Image(systemName: getGlyph(device: device))
                    .foregroundColor(Color(.label))
                    .font(.system(size:30, weight: .bold)).scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(.bottom,0.5)
                
                Text(device.device_name)
                    .fontWeight(.medium)
                    .foregroundColor(Color(.label))
                    .font(.system(size:17))
//                    .padding(.top,1)
//                    .multilineTextAlignment(.leading)
                
                Text(device.type)
                    .fontWeight(.medium)
                    .foregroundColor(Color(.label))
                    .font(.system(size:16))
                    .multilineTextAlignment(.leading)
                
                Text(DetermineValue(device: device))
                    .fontWeight(.regular)
                    .foregroundColor(Color(.secondaryLabel))
                    .font(.system(size:15))
                    .multilineTextAlignment(.leading)
            }
            .frame(width: 100,height: 100,alignment: .leading)
        }
    }
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView(device: Device(id: 1, device_name: "Test name",device_custom_name: "Cust name",glyph: "glyph", is_active: false, type: "Switch", value: Float(1.0), max_level: 3))
            
    }
}
