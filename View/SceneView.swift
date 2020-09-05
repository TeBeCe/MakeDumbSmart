//
//  SceneView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 04/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct SceneView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:20, style: .continuous)
                .fill(Color.black)
                .opacity(0.7)
                .frame(width: 250, height: 60)
            
            HStack(alignment: .center){
                Image(systemName: "house")
                    .foregroundColor(.gray)
                    .padding(.bottom, 5.0)
                    .padding(.leading, 10)
                    .font(.system(size:30, weight: .semibold))
                
                Text("Scene name")
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
                    .font(.system(size:20))
                    .multilineTextAlignment(.leading)
                    .padding(0.0)
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
