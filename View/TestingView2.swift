//
//  TestingView2.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 30/01/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct TestingView2: View {
    var days : [String] = ["mon","tue","wen","thu","fri","sat","sun"]
    @State var selectedDays : [Bool] = [true,false,true,true,true,true,true]
    @State private var birthdate = Date()
    @GestureState var isLong = false
         var body: some View {
            let lpG = LongPressGesture().updating($isLong) { (newVal, state, trans) in
                state = newVal
            }
            VStack{
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: 200, height: 200)
                    .scaleEffect(isLong ? 2 : 1.0)
                    .gesture(lpG)
                    .animation(.easeIn(duration:isLong ? 2 : 0.35))
                    
//                DatePicker("Date of Birth", selection: $birthdate, displayedComponents: .hourAndMinute)
//                            .datePickerStyle(CompactDatePickerStyle())
//                HStack(){
//                    ForEach(0..<7){ind in
//                        ZStack{
//                            Circle()
//                                .foregroundColor(selectedDays[ind] ? .orange : .black )
//    //                            .size(CGSize(width: 50, height: 50))
//                                .onTapGesture {
//                                    selectedDays[ind].toggle()
//                                }
//                            Text(days[ind]).foregroundColor(.white)
//                        }
//                        .frame(height: 50)
//                    }
//                }.padding(.horizontal,10)
            }
         }
     }

struct TestingView2_Previews: PreviewProvider {
    static var previews: some View {
        TestingView2()
    }
}
