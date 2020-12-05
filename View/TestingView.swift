//
//  TestingView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 21/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct TestingView: View {
    var body: some View {
//        this is handle
        //        HStack{Spacer()
        //            Capsule()
        //            .fill(Color.secondary)
        //            .frame(width: 40, height: 8)
        //                        .padding(.top,5)
        //            .padding(.bottom,0)
        //            Spacer()
        //        }.background(Color.red)
            RoundedRectangle(cornerRadius: 30)
              .foregroundColor(Color.gray)
              .mask(
                ZStack {
                  Rectangle()
                    .fill(Color.white)
                    .frame(width: 150, height: 100)
                    Text("Ahoj AHOJ AHOJ")
                    .font(.system(size: 24))
                    .foregroundColor(Color.black)
                }
                  .compositingGroup()
                  .luminanceToAlpha()
              ).frame(width: 150, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
    }
}

struct TestingView_Previews: PreviewProvider {
    static var previews: some View {
        TestingView()
    }
}
