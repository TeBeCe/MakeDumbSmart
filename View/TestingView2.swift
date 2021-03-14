//
//  TestingView2.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 30/01/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct TestingView2: View {
    
//         @GestureState var isDetectingLongPress = false
//
//         var longPress: some Gesture {
//             LongPressGesture(minimumDuration: 2)
//                 .updating($isDetectingLongPress) { currentstate, gestureState, transaction in
//                     gestureState = currentstate
//                    print("curr state:")
//                    print(currentstate)
//                    print("gest state:")
//                    print(gestureState)
//                    print("trans:")
//                    print(transaction)
//                 }
//         }
//
         var body: some View {
             NavigationView{
//                VStack{
//                    Text("blbl")
                ScrollView{
                    VStack{
                    ForEach(0..<50){_ in
//                        HStack{
                            Text("bla")
//                            Spacer()
                    }
                    }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .background(Color.red)
                    .navigationBarTitle(Text("Title"))
                    
                    
                }
//                }
                
                    
//                }
//                .background(Color.red)
                .edgesIgnoringSafeArea(.top)
//                .navigationBarTitle(Text("Test"))
                
                
                
            
//                Circle()
//                 .fill(self.isDetectingLongPress ? Color.red : Color.green)
//                 .frame(width: 100, height: 100, alignment: .center)
//                 .gesture(longPress)
             }
         }
     }

struct TestingView2_Previews: PreviewProvider {
    static var previews: some View {
        TestingView2()
    }
}
