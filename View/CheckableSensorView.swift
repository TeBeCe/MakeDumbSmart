//
//  CheckableSensorView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 08/04/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct CheckableSensorView: View {
    var device : Device
    var rooms : [Room]
    var checked: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:20, style: .continuous)
                .fill(device.is_active ? Color(UIColor.white) : Color(.systemGray6))
                .opacity(device.is_active ? 1.0 : 0.8)
                .frame(width: 120, height: 120)
            VStack(alignment:.leading){
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(device.type == "sensor_temperature" ? Color(.systemRed) : Color(.systemBlue))
                        Text(DetermineValue(device: device))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .font(.system(size: 13))
                    }
                    .frame(width: 35, height: 33)
                    Spacer()
                    Image(systemName: self.checked ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(self.checked ? .orange : .gray)
                }
                
                VStack(alignment: .leading){  Text(device.device_name)
                    .fontWeight(.regular)
                    .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                    .font(.system(size:16))
                    .lineLimit(2)
                    //                    .padding(.top,1)
                    //                    .multilineTextAlignment(.leading)
                    
                    Text(getRoomFrom(rooms: rooms, device: device))
                        .roomLabel()
                        .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                    Text(" ")
                        .roomLabel()
                    
                    //                Text(DetermineValue(device: device))
                    Text(" ")
                        .valueLabel()
                }.offset(x: 0, y: -7.0)
            }.padding(.top, 2)
            .frame(width: 100,height: 100,alignment: .leading)
            //            .padding(.top, -10)
        }
    }
}

struct CheckableSensorView_Previews: PreviewProvider {
    static var previews: some View {
        CheckableSensorView(device: Device(id: 1, device_name: "Test name sensor",device: "Cust name", reseting: false,glyph: "lightbulb", is_active: false, type: "sensor_temperature", value: Float(19.0), max_level: 3, room: 1, processing: 0), rooms: [Room(id: 1, room_name: "Bedroom")], checked: true)
            .previewLayout(.fixed(width: 125, height: 125))
    }
}
