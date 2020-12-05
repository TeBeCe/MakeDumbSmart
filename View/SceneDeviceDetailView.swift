//
//  SceneDeviceDetailView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 05/12/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct SceneDeviceDetailView: View {
    @Binding var sd : Device?
    @ObservedObject var dvcObj : LoadJSONData
    @State var device : Device
    @State var scene : Scene?
    var body: some View {
        NavigationView(){
            VStack{
                Spacer()
                
                switch device.type{
                case "Switch":
                    DeviceFunctionSwitchView(dvcObj: dvcObj, device: $device, scene: scene)
                        .frame(width: 140, height: 400, alignment: .center)
                        .accentColor(.white)
                    
                case "Slider":
                    DeviceFunctionSliderView(dvcObj: dvcObj, device: $device, scene: scene)
                        .frame(width: 140, height: 400, alignment: .center)
                        .accentColor(.white)
                    
                case "Levels":
                    DeviceFunctionLevelView(dvcObj: dvcObj, device: $device,scene: scene, levelArr: CalculateLevels(levels: device.max_level!))
                        .frame(width: 140, height: 400, alignment: .center)
                        .accentColor(.white)
                    
                default:
                    Spacer()
                }
                Spacer()
                HStack(alignment: .top){
                    Spacer()
                }.padding([.trailing,.bottom], 20)
            }.navigationBarItems(leading:
                                    HStack(){
                                        Image(systemName:getGlyph(device: device)).foregroundColor(Color(UIColor.systemGray2))
                                            .font(.system(size:35, weight: .semibold))
                                        
                                        VStack(alignment: .leading){
                                            Text(device.device_name)
                                                .font(.system(size: 18, weight: .bold))
                                            
                                            Text(DetermineValue(device: device))
                                                .font(.system(size: 18, weight: .semibold ))
                                        }
                                        Spacer()
                                    }, trailing: Button(action:{self.sd = nil}){Image(systemName: "xmark.circle.fill")
                                        .font(.system(size:25, weight: .bold)).accentColor(.gray)})
        }
    }
}

struct SceneDeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SceneDeviceDetailView(sd: .constant(nil), dvcObj: LoadJSONData(), device: Device(id: 0, device_name: "Test Name", device_custom_name: nil, glyph: nil , is_active: false, type: "Slider", value: Float(Int(1.0)), max_level: 3))
    }
}
