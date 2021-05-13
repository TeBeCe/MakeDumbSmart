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
    @Binding var syncMode: Bool
    @State var scene : Scene?
    @State var automatization : Automatization?
    
    @State var levelArr : [Float] = []
    @State var percentage : Float = 0
    @State var selectedLevel: Int = 0
    
    var tempValue : Float = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .foregroundColor(Color(UIColor(.init(.systemGray3))))
                    .opacity(0.8)
                Rectangle()
                    .foregroundColor(Color(UIColor(.init(.systemGray))))
                    .frame(height: (geometry.size.height / CGFloat(device.max_level!)) * CGFloat(device.value))
                            .animation(.linear(duration: 0.1))
            }
            .cornerRadius(30)
            .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            self.percentage = 100 - min(max(0, Float(value.location.y / geometry.size.height * 100)), 100)
                            for i in (0..<levelArr.count).reversed(){
                                if(percentage > levelArr[i]){
                                    self.selectedLevel = levelArr.count - i
                                }
                                else if(percentage == 0.0){
                                    self.selectedLevel = 0
                                }
                            }
                            if(self.device.value != Float(self.selectedLevel)){
                                self.device.is_active = self.selectedLevel == 0 ? false : true
                                self.device.value = Float(self.selectedLevel)
                                
                                if(scene != nil && automatization == nil){
                                    dvcObj.updateDeviceInScene(scene: scene!, device: device)
                                }
                                else if(automatization != nil && scene == nil){
                                    dvcObj.updateDeviceInAutomatization(automatization: automatization!, device: device)
                                }
                                else{
                                    //dvcObj.updateDevice(device: device)
                                }
                            }
                        }).onEnded({_ in
                            if(scene != nil && automatization == nil){
                                if(scene?.id != 0){
                                    dvcObj.updateBackendDeviceInScene(scene: scene!)
                                }
                            }
                            else if(automatization != nil && scene == nil){
                                if(automatization?.id != 0){
                                    dvcObj.updateBackendAutomatization(automatizationx: automatization!)
                                }
                            }
                            else{
                                if(syncMode ){
                                    dvcObj.updateDevice(device: device)
                                    dvcObj.updateBackendDevice(device: device)
                                }
                                else{
                                    dvcObj.activateDevice(device: device)//WIP
                                    dvcObj.updateBackendDevice(device: device)
                                    dvcObj.findAndActivateScene()
                                }
                            }
                        }
                    )
            )
        }
    }
}

struct DeviceFunctionSliderView_Previews: PreviewProvider {
    
    static var previews: some View {
        DeviceFunctionSliderView(dvcObj: LoadJSONData(), device: .constant(Device(id: 0, device_name: "Device_name", device: "", reseting: false, glyph: "lightbulb", is_active: true, type: "Slider", value: 1, max_level: 30, room: 1, processing: 0)), syncMode: .constant(false)).preferredColorScheme(.dark).frame(width: 140, height: 400, alignment: .center)
    }
}
