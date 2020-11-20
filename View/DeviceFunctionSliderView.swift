//
//  DeviceFunctionSliderView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 14/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct DeviceFunctionSliderView: View {
    @ObservedObject var dvcObj : LoadJSONData
    @Binding var device : Device
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .foregroundColor(Color(UIColor(.init(.systemGray3))))
                    .opacity(0.8)
                Rectangle()
                    .foregroundColor(Color(UIColor(.init(.systemGray))))
                    .frame(height: (geometry.size.height * CGFloat(self.device.value / 100)))
                    .animation(.linear(duration: 0.1))
            }
            .cornerRadius(30)
            .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            // TODO: - maybe use other logic here
                            self.device.value = 100 - min(max(0, Float(value.location.y / geometry.size.height * 100)), 100)
//                            print(CGFloat(self.percentage / 100))
                            self.device.is_active = self.device.value == 0.0 ? false : true
                            dvcObj.updateDevice(device: device)
                        }))
        }
    }
}

struct DeviceFunctionSliderView_Previews: PreviewProvider {
    
    static var previews: some View {
        DeviceFunctionSliderView(dvcObj: LoadJSONData(), device: .constant(Device(id: 0, device_name: "Device_name", device_custom_name: "", glyph: "", is_active: true, type: "Slider", value: 45, max_level: 3))).preferredColorScheme(.dark).frame(width: 140, height: 400, alignment: .center)
    }
}
