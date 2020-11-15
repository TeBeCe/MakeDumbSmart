//
//  DeviceFunctionSwitchView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 13/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct DeviceFunctionSwitchView: View {
    @State var offsetY:CGFloat = -100.0
    @State var state:Bool = false
    var body: some View {
       
            ZStack {
              
              RoundedRectangle(cornerRadius:20, style: .continuous)
//                .fill(Color(UIColor.init(named:"mainColor") ?? UIColor.systemGray))
                    .fill(Color(UIColor.gray ))
                  .opacity(0.7)
                  .frame(width: 140, height: 400)
                Button(action:{self.offsetY = self.offsetY == -100.0 ? 100.0 : -100.0}){
//                Button(action:{self.offsetY = self.state == false ? 100.0 : -100.0 }){
                RoundedRectangle(cornerRadius:20, style: .continuous)
                    .fill(Color(UIColor.init(named:"mainColor") ?? UIColor.systemGray))
                    .opacity(1)
                    .frame(width:130, height: 190)
                }.padding(.vertical, 100.0).offset(x: 0, y: offsetY)
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
            }.frame(width: 140, height: 400, alignment: .center)
    }
}

struct DeviceFunctionsView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceFunctionSwitchView()
            .preferredColorScheme(.dark)
    }
}
