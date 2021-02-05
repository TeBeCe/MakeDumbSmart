//
//  SensorView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 07/12/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct SensorView: View {
    var device : Device
    var rooms : [Room]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:20, style: .continuous)
                .fill(device.is_active ? Color(UIColor.white) : Color(.systemGray6))
                .opacity(device.is_active ? 1.0 : 0.8)
                .frame(width: 120, height: 120)
            VStack(alignment: .leading){
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(device.type == "sensor_temperature" ? Color(.systemRed) : Color(.systemBlue))
                    Text(DetermineValue(device: device))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .font(.system(size: 13))
                }
                .frame(width: 35, height: 33)
//                ZStack{
//                    Circle()
//                    Text("55°")
//                        .foregroundColor(.white)
//                        .lineLimit(1)
//                        .font(.system(size: 15))
//                }
//                .frame(width: 35, height: 35)

                Text(device.device_name)
                    .fontWeight(.semibold)
                    .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                    .font(.system(size:17))
//                    .padding(.top,1)
//                    .multilineTextAlignment(.leading)
                
                Text(getRoomFrom(rooms: rooms, device: device))
                    .roomLabel()
                    .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))

                
//                Text(DetermineValue(device: device))
                Text("")

                    .valueLabel()
            }
            .frame(width: 100,height: 100,alignment: .leading).padding(.top, -10)
        }
    }
}

struct SensorView_Previews: PreviewProvider {
    static var previews: some View {
        SensorView(device: Device(id: 1, device_name: "Test name",device_custom_name: "Cust name",glyph: "glyph", is_active: false, type: "Switch", value: Float(1.0), max_level: 3), rooms: [])
    }
}
