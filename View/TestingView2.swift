//
//  TestingView2.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 30/01/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct TestingView2: View {
         @GestureState var isDetectingLongPress = false

         var longPress: some Gesture {
             LongPressGesture(minimumDuration: 2)
                 .updating($isDetectingLongPress) { currentstate, gestureState, transaction in
                     gestureState = currentstate
                    print("curr state:")
                    print(currentstate)
                 }
         }

         var body: some View {
             Circle()
                 .fill(self.isDetectingLongPress ? Color.red : Color.green)
                 .frame(width: 100, height: 100, alignment: .center)
                 .gesture(longPress)
         }
     }

struct TestingView2_Previews: PreviewProvider {
    static var previews: some View {
        TestingView2()
    }
}