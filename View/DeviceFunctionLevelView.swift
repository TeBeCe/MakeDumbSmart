//
//  DeviceFunctionLevelView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 15/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct DeviceFunctionLevelView: View {
    @ObservedObject var dvcObj : LoadJSONData
    @Binding var device : Device
    @Binding var syncMode : Bool
    @State var scene : Scene?
    @State var automatization : Automatization?
    
    @State var levelArr : [Float] = []
    @State var percentage : Float = 0
    @State var selectedLevel: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .foregroundColor(Color(UIColor(.init(.systemGray3))))
                    .opacity(0.8)
                VStack(spacing:0){
                    ForEach(0..<device.max_level!) { i in
                        Rectangle()
                            .frame(height: (geometry.size.height/CGFloat(device.max_level!)), alignment: .center)
                            .foregroundColor(.gray)
                            .opacity(Float(100 / device.max_level!) * device.value > levelArr[i] ? 1.0 : 0.0)
                        
                        Color.white.frame(height:CGFloat(3) / UIScreen.main.scale)
                            .opacity(i+1 == device.max_level ? 0.0 : 1.0)
                    }
                }
                Rectangle()
                    .foregroundColor(Color(UIColor(.init(.systemGray))))
                    .frame(height:geometry.size.height * CGFloat(self.percentage / 100))
                    .opacity(0.0)
//                Text("level: \(selectedLevel)")
            }.onAppear(perform: {
//                self.percentage = Float(100 / device.max_level!) * device.value
            })
            .cornerRadius(30)
            .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            // TODO: - maybe use other logic here
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
                                
                                if (scene != nil && automatization == nil){
                                    dvcObj.updateDeviceInScene(scene: scene!, device: device)
                                    print("changed in scene")
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
                        })
            )
        }
    }
}

struct DeviceFunctionLevelView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceFunctionLevelView(dvcObj: LoadJSONData(), device: .constant(Device(id: 0, device_name: "Device Name", device: nil, reseting: false, glyph: "lightbulb", is_active: true, type: "Levels", value: 1, max_level: 3, room: 1, processing: 0)), syncMode: .constant(false), levelArr: [0,33.4,66.7]).preferredColorScheme(.light).frame(width: 140, height: 400, alignment: .center)
    }
}
