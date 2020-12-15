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

func getRoomFrom(rooms: [Room], device: Device) -> String{
    
    if let indx = rooms.firstIndex(where: {$0.id == device.room}){
        return rooms[indx].room_name
    }
    else{
        return ""
    }
}

struct DevicesView: View {
    var device : Device
    var rooms : [Room]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:20, style: .continuous)
//                .fill(device.is_active ? Color(UIColor.white) : Color(UIColor.init(named:"mainColor")!))
                .fill(device.is_active ? Color(UIColor.white) : Color(.systemGray5))
                .opacity(device.is_active ? 1.0 : 0.7)
                .frame(width: 120, height: 120)
            
            VStack(alignment: .leading){
                
                Image(systemName: getGlyph(device: device))
                    .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                    .font(.system(size:30, weight: .semibold)).scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(.bottom,0.5)
                
                Text(device.device_name)
                    .fontWeight(.semibold)
                    .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                    .font(.system(size:17))
//                    .padding(.top,1)
//                    .multilineTextAlignment(.leading)
                
                Text(getRoomFrom(rooms: rooms, device: device))
                    .fontWeight(.semibold)
                    .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                    .font(.system(size:16))
                    .multilineTextAlignment(.leading)
                
                Text(DetermineValue(device: device))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(.systemGray))
                    .font(.system(size:15))
                    .multilineTextAlignment(.leading)
            }
            .frame(width: 100,height: 100,alignment: .leading)
        }
    }
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {

            DevicesView(device: Device(id: 1, device_name: "Test name",device_custom_name: "Cust name",glyph: "glyph", is_active: false, type: "Switch", value: Float(1.0), max_level: 3), rooms: [])
                .preferredColorScheme(.dark)
            
    }
}
