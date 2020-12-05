//
//  DeviceFunctionLevelView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 15/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

func CalculateLevels(levels: Int) -> [Float]{
    var result: [Float] = []
    for i in 0..<levels {
        let left = 100.0 / Float(levels)
        let right = levels-i-1
        result.append(left * Float(right))
    }
    return result
}

struct DeviceFunctionLevelView: View {
    @State var percentage : Float = 50
    @State var selectedLevel: Int = 0
    @ObservedObject var dvcObj : LoadJSONData
    @Binding var device : Device
    @State var scene : Scene?
    @State var levelArr : [Float] = []
    
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
            }
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
                            //TODO: - no need to update every onChange
                            self.device.is_active = self.selectedLevel == 0 ? false : true
                            self.device.value = Float(self.selectedLevel)
                            if (scene == nil){
                                dvcObj.updateDevice(device: device)
                            }
                            else{
                                dvcObj.updateDeviceInScene(scene: scene!, device: device)
                            }
                            
                        }))
        }
    }
}

struct DeviceFunctionLevelView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceFunctionLevelView(dvcObj: LoadJSONData(), device: .constant(Device(id: 0, device_name: "Device Name", device_custom_name: nil, glyph: nil, is_active: true, type: "Levels", value: 0, max_level: 3)), levelArr: [0,33.3,66.66]).preferredColorScheme(.dark).frame(width: 140, height: 400, alignment: .center)
    }
}
