//
//  DeviceDetailView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 13/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct DeviceDetailView: View {
    var device : Device
    var body: some View {
        ScrollView(){
            HStack(){
                Image(systemName: "square.and.pencil").foregroundColor(Color(UIColor.systemGray2)).font(.system(size:40, weight: .bold))
                VStack(alignment: .leading){
                    Text(device.device_name)
                        .font(.system(size: 20, weight: .bold))
                    
                    Text(device.device_custom_name ?? device.device_name)
                        .font(.system(size: 20, weight: .semibold ))
                    
                }
                Spacer()
            }.padding([.top, .leading], 20)
            DeviceFunctionsView()
        }
    }
}

struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailView(device: Device(id: 0, device_name: "Test", device_custom_name: "test_custom", glyph: "Lamp"))
    }
}
