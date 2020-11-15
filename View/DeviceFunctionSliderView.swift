//
//  DeviceFunctionSliderView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 14/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct DeviceFunctionSliderView: View {
    @State var percentage: Float = 50 // or some value binded
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .foregroundColor(Color(UIColor(.init(.systemGray3))))
                    .opacity(0.8)
                Rectangle()
                    .foregroundColor(Color(UIColor(.init(.systemGray))))
                    .frame(height: (geometry.size.height * CGFloat(self.percentage / 100)))
            }
            .cornerRadius(30)
            .gesture(DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            // TODO: - maybe use other logic here
                            self.percentage = 100 - min(max(0, Float(value.location.y / geometry.size.height * 100)), 100)
                            print(CGFloat(self.percentage / 100))
                        }))
        }
    }
}

struct DeviceFunctionSliderView_Previews: PreviewProvider {
    
    static var previews: some View {
        DeviceFunctionSliderView().frame(width: 140, height: 400, alignment: .center)
    }
}
