//
//  SceneView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 04/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct SceneView: View {
//    var scene: Scene
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:20, style: .continuous)
                .fill(Color(UIColor.init(named:"mainColor") ?? UIColor.gray))
                .opacity(0.7)
                .frame(width: 250, height: 60)
            
            HStack(alignment: .center){
                Image(systemName: "house")
                    .foregroundColor(Color(UIColor.systemGray2))
                    .padding(.bottom, 5.0)
                    .padding(.leading, 10)
                    .font(.system(size:30, weight: .semibold))
                
                Text("Scene name")
                    .fontWeight(.medium)
                    .foregroundColor(Color(UIColor.systemGray6))
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
        SceneView()
    }
}
