//
//  DeviceFunctionSwitchView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 13/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct DeviceFunctionSwitchView: View {
    @State var offsetY:CGFloat = -100.0
    @Binding var state:Bool
    @Binding var valueStr : String
    @Binding var device : Device
    @ObservedObject var dvcObj : LoadJSONData
//    @ObservedObject var dvcObj = LoadJSONData()
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius:20, style: .continuous)
            //  .fill(Color(UIColor.init(named:"mainColor") ?? UIColor.systemGray))
                .fill(Color(UIColor.gray ))
                .opacity(0.7)
            
            Button(action:
                    {self.state.toggle()
                    self.offsetY = self.state == true ? -100.0 : 100.0
                    valueStr = state == true ? "Zap.": "Vyp."
                    device.value = self.state == true ? 1.0 : 0.0
                    dvcObj.updateDevice(device: device)
            }){
                RoundedRectangle(cornerRadius:20, style: .continuous)
                    .fill(Color(UIColor.init(named:"mainColor") ?? UIColor.systemGray))
                    .opacity(1)
                    .frame(width:130, height: 190)
            }.padding(.vertical, 100.0)
            .offset(x: 0, y: self.state == true ? -100.0 : 100.0)
            .animation(.linear(duration: 0.1))
            
            VStack{
                Text("I")
                    .foregroundColor(Color(.label))
                    .font(.system(size: 40, weight: .semibold))
                    .padding(.top,65)
                Spacer()
                Text("O")
                    .foregroundColor(Color(.label))
                    .font(.system(size: 40, weight: .semibold))
                    .padding(.bottom,65)
            }
        }
    }
}

struct DeviceFunctionsView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceFunctionSwitchView(state: .constant(false), valueStr: .constant("xxx"), device: .constant(Device(id: 0, device_name: "name", device_custom_name: nil, glyph: nil, is_active: true, type: "Switch", value: 1)), dvcObj: LoadJSONData() )
            .frame(width: 140, height: 400, alignment: .center)
            .preferredColorScheme(.dark)
    }
}
