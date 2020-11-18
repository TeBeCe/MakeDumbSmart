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
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:20, style: .continuous)
                .fill(Color(UIColor.init(named:"mainColor") ?? UIColor.gray))
                .opacity(device.is_active ? 1.0 : 0.7)
                .frame(width: 120, height: 120)
            
            VStack(alignment: .leading){
                
                Image(systemName: "square.and.pencil")
                    .foregroundColor(Color(.label))
                    .font(.system(size:30, weight: .bold))

                Text(device.device_name)
                    .fontWeight(.medium)
                    .foregroundColor(Color(.label))
                    .font(.system(size:17))
                    .multilineTextAlignment(.leading)
                    
                Text(device.type)
                    .fontWeight(.medium)
                    .foregroundColor(Color(.label))
                    .font(.system(size:15))
                    .multilineTextAlignment(.leading)
                
//                let formattedFloat = String(format: "%.1f", myfloat)
//                return Text("My Float: \(formattedFloat)")
                Text(device.is_active == true ? "\(Int(device.value))" :"Vyp.")
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
        DevicesView(device: Device(id: 1, device_name: "Test name",device_custom_name: "Cust name",glyph: "glyph", is_active: false, type: "Switch", value: Float(1.0)))
            
    }
}
