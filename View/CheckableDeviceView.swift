//
//  CheckableDeviceView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 24/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct CheckableDeviceView: View {
    var device : Device
    var checked: Bool
//    var rooms : [Room]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:20, style: .continuous)
//                .fill(device.is_active ? Color(UIColor.white) : Color(UIColor.init(named:"mainColor")!))
                .fill(Color(UIColor.white))
//                .opacity(device.is_active ? 1.0 : 0.8)
                .frame(width: 120, height: 120)
            
            VStack(alignment: .leading,spacing: 1){
                HStack(alignment: .top){
                    Image(systemName: getGlyph(device: device))
//                        .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                        .foregroundColor(Color(.black))
                        .font(.system(size:30, weight: .semibold)).scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.bottom,0.5)
                    Spacer()
                    Image(systemName: self.checked ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(self.checked ? .orange : .gray)
                        
                }
                
                Text(device.device_name)
                    .fontWeight(.semibold)
//                    .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                    .foregroundColor(Color(.black))
                    .font(.system(size:17))
//                Text(getRoomFrom(rooms: rooms, device: device))
                    Text(" ")
                    .fontWeight(.semibold)
//                    .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                    .foregroundColor(Color(.black))
                    .font(.system(size:16))
                
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

struct CheckableDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        CheckableDeviceView(device: Device(id: 1, device_name: "Test name",device_custom_name: "Cust name",glyph: "glyph", is_active: false, type: "Switch", value: Float(1.0), max_level: 3), checked: false/*, rooms: []*/)
    }
}
