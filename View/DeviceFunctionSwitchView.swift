//
//  DeviceFunctionSwitchView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 13/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct DeviceFunctionSwitchView: View {
    //    @State var offsetY:CGFloat = -100.0
    @ObservedObject var dvcObj : LoadJSONData
    @Binding var device : Device
    @State var scene: Scene?
    @State var automatization: Automatization?
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius:20, style: .continuous)
                .fill(Color(UIColor.gray ))
                .opacity(0.8)
            
            Button(action:
                    {
                        self.device.is_active.toggle()
                        device.value = self.device.is_active == true ? 1.0 : 0.0
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        if(scene != nil && automatization == nil){
                            dvcObj.updateDeviceInScene(scene: scene!, device: device)
                            if(scene?.id != 0){
                                dvcObj.updateBackendDeviceInScene(scene: scene!)
                            }
                        }
                        else if(automatization != nil && scene == nil ){
                            dvcObj.updateDeviceInAutomatization(automatization: automatization!, device: device)
                            if(automatization?.id != 0){
                                dvcObj.updateBackendAutomatization(automatizationx: automatization!)
                            }
                        }
                        else{
                            //dvcObj.updateDevice(device: device)
                            //dvcObj.updateBackendDevice(device: device)
                            dvcObj.activateDevice(device: device)//WIP
                            //dvcObj.activateBackendDevice(device: device, multiplier: 1)
                            dvcObj.findAndActivateScene()
                        }
                    }){
                RoundedRectangle(cornerRadius:20, style: .continuous)
                    .fill(Color(UIColor.init(named:"mainColor") ?? UIColor.systemGray))
                    .opacity(1)
                    .frame(width:130, height: 190)
            }.padding(.vertical, 100.0)
            .offset(x: 0, y: self.device.is_active == true ? -100.0 : 100.0)
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
        DeviceFunctionSwitchView(dvcObj: LoadJSONData(), device: .constant(Device(id: 0, device_name: "name", device: nil, reseting: false, glyph: "lightbulb", is_active: true, type: "Switch", value: 1, max_level: nil, room: 1, processing: 0)) )
            .frame(width: 140, height: 400, alignment: .center)
            .preferredColorScheme(.dark)
    }
}
