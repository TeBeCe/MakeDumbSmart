//
//  DevicesView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 03/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI


struct DevicesView: View {
    var device : Device
    var rooms : [Room]
    var showSpinner : Bool = true
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:20, style: .continuous)
                //.fill(device.is_active ? Color(UIColor.white) : Color(UIColor.init(named:"mainColor")!))
                .fill(device.is_active ? Color(UIColor.white) : Color(.systemGray5))
                .opacity(device.is_active ? 1.0 : 0.7)
                .frame(width: 120, height: 120)
            
            VStack(alignment: .leading){
                HStack(alignment: .top){
                    Image(systemName: device.glyph)
                        .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                        .font(.system(size:30, weight: .semibold))
                        .scaledToFit()
                        .frame(width: 30, height: 30)
//                        .padding(.bottom,0.5)
                    Spacer()
                    if(device.processing != 0 && showSpinner){
                        let spinnerCollor = device.is_active ? Color.black : Color(UIColor.init(named:"textColor")!)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: spinnerCollor)).padding(.vertical,2)
                    
                  }
                }
                
                Text(device.device_name)
                    .fontWeight(.regular)
                    .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                    .font(.system(size:16))
                    .allowsTightening(true).lineLimit(1)
                //.padding(.top,1)
                //.multilineTextAlignment(.leading)
                Text(device.device ?? "nil")
                    .roomLabel()
                    .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))

                Text(getRoomFrom(rooms: rooms, device: device))
                    .roomLabel()
                    .foregroundColor(device.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                
                Text(DetermineValue(device: device))
                    .valueLabel()
            }
            .frame(width: 100,height: 100,alignment: .leading)
        }
    }
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DevicesView(device: Device(id: 1, device_name: "Test name",device: "Cooler", reseting: false,glyph: "lightbulb", is_active: false, type: "Switch", value: Float(1.0), max_level: 3, room: 1, processing: 0), rooms: [Room(id: 1, room_name: "Bedroom")])
                .preferredColorScheme(.dark)
            
            DevicesView(device: Device(id: 1, device_name: "Test name",device: "Cooler", reseting: false,glyph: "lightbulb", is_active: false, type: "Levels", value: Float(1.0), max_level: 3, room: 1, processing: 1), rooms: [Room(id: 1, room_name: "Bedroom")])
            
        }.previewLayout(.fixed(width: 125, height: 125))
    }
}
