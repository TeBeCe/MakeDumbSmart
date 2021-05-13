//
//  AddMyFunctionsView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 11/03/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct AddMyFunctionsView: View {
    
    @Binding var activeSheet: ActiveSheet?
    @ObservedObject var newIRFunctions:LoadJSONNewFunctionData
    @ObservedObject var dvcObj:LoadJSONData
    
    var body: some View {
        VStack{
            if(newIRFunctions.loading){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(3.5)
            }
            else{
                if(newIRFunctions.myIRDevices.count > 0){
                    List(newIRFunctions.myIRDevices){newFunction in
                        NavigationLink(destination:NewFunctionDetailView(newFunction: newFunction, nf: newIRFunctions, dvcObj: dvcObj, activeSheet: $activeSheet)){
                            HStack{
                                Text(newFunction.functionName)
                                Spacer()
                                Image(systemName: newFunction.deviceRealName != nil ? "checkmark.circle.fill" : "circle").foregroundColor(.green)
                            }
                        }
                    }
                }
                else{
                    Text("No devices to add, scanned functions will appear here!")
                }
            }
        }
    }
}

struct AddMyFunctionsView_Previews: PreviewProvider {
    static var previews: some View {
        AddMyFunctionsView(activeSheet: .constant(nil),newIRFunctions: LoadJSONNewFunctionData(), dvcObj: LoadJSONData())
    }
}
