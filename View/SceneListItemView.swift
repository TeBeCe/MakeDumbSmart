//
//  SceneListItemView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 07/12/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

func DetermineValueSceneList(device: Device)-> String {
    
    switch device.type{
    case "Switch" :
        return !device.is_active || device.value == 0.0 ? "Vypnut" : "Zapnut"
    case "Slider" :
        return !device.is_active || device.value == 0.0 ? "Vypnut" : "\(String(format: "%.1f%", device.value))%"
    case "Levels" :
        return !device.is_active || device.value == 0.0 ? "Vypnut" : "\(String(format: "%.0f%", device.value))"
        
    default:
        return "Unknown device type/state"
    }
}

struct SceneListItemView: View {
    var scene: Scene
    var device: Device
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:15, style: .continuous)
//                .fill(scene.is_active ? Color(UIColor.white) : Color(UIColor.init(named:"mainColor")!))
                .fill(Color(UIColor.white))
                //.frame(width: 250, height: 60)
                
            HStack(alignment: .center){
                Image(systemName: scene.glyph )
                    .foregroundColor(Color(.black))
                    //.padding(.bottom, 5.0)
                    .font(.system(size:30, weight: .semibold))
                
                VStack(alignment: . leading){
                    
                    Text(scene.scene_name)
                        .fontWeight(.medium)
                        .foregroundColor(Color(.black))
                        .font(.system(size:20))
                        .multilineTextAlignment(.leading)
                    Text(DetermineValueSceneList(device: device))
                        .foregroundColor(Color(.gray))
                }
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding(.horizontal, 0)
            .frame(height: 55)
        }
    }
}

struct SceneListItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SceneListItemView(scene: Scene(scene_name: "Test", id: 0, is_favorite: true, glyph: "house", is_active: false, devices: [], scene_devices: []),device: Device(id: 0, device_name: "test", device: nil, reseting: false, glyph: "lightbulb", is_active: false, type: "Switch", value: 0.0, max_level: 1, room: 1, processing: 0)).previewLayout(.fixed(width: 400, height: 80))
            SceneListItemView(scene: Scene(scene_name: "Test", id: 0, is_favorite: true, glyph: "house", is_active: false, devices: [], scene_devices: []),device: Device(id: 0, device_name: "test", device: nil, reseting: false, glyph: "lightbulb", is_active: false, type: "Switch", value: 0.0, max_level: 1, room: 1, processing: 0)).preferredColorScheme(.dark).previewLayout(.fixed(width: 400, height: 80))
        }
    }
}
