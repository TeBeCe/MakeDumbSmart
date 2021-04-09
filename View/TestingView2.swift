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
         var body: some View {
            VStack{
                DatePicker("Date of Birth", selection: $birthdate, displayedComponents: .hourAndMinute)
                            .datePickerStyle(CompactDatePickerStyle())
                HStack(){
                    ForEach(0..<7){ind in
                        ZStack{
                            Circle()
                                .foregroundColor(selectedDays[ind] ? .orange : .black )
    //                            .size(CGSize(width: 50, height: 50))
                                .onTapGesture {
                                    selectedDays[ind].toggle()
                                }
                            Text(days[ind]).foregroundColor(.white)
                        }
                        .frame(height: 50)
                    }
                }.padding(.horizontal,10)
            }
//             NavigationView{
//                VStack{
//                    Text("blbl")
//                ScrollView{
//                    VStack{
//                    ForEach(0..<50){_ in
//                        HStack{
//                            Text("bla")
//                            Spacer()
//                    }
//                    }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                    .background(Color.red)
//                    .navigationBarTitle(Text("Title"))
                    
                    
//                }
//                }
                
                    
//                }
//                .background(Color.red)
//                .edgesIgnoringSafeArea(.top)
//                .navigationBarTitle(Text("Test"))

//             }
         }
     }

struct TestingView2_Previews: PreviewProvider {
    static var previews: some View {
        TestingView2()
    }
}
