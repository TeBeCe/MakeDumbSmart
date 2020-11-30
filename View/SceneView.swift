//
//  SceneView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 04/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct SceneView: View {
    var scene: Scene
    var color = UIColor(.gray)
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:15, style: .continuous)
                .fill(scene.is_active ? Color(UIColor.white) : Color(UIColor.init(named:"mainColor")!))
                .opacity(scene.is_active ? 1 : 0.8)
                .frame(width: 250, height: 60)
                
            HStack(alignment: .center){
                Image(systemName: "house")
                    .foregroundColor(scene.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                    .padding(.bottom, 5.0)
                    .padding(.leading, 10)
                    .font(.system(size:30, weight: .semibold))
                
                Text(scene.scene_name)
                    .fontWeight(.medium)
                    .foregroundColor(scene.is_active ? Color(.black) : Color(UIColor.init(named:"textColor")!))
                    .font(.system(size:20))
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .frame(width: 250,height: 60)
        }
    }
}

struct SceneView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SceneView(scene: Scene(scene_name: "Test", id: 0, is_favorite: true, glyph: "house", is_active: false, devices: []))
                .preferredColorScheme(.dark)
        }
    }
}
