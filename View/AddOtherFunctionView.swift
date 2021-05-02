//
//  AddOtherFunctionView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 02/05/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct AddOtherFunctionView: View {
    @Binding var activeSheet: ActiveSheet?
    @ObservedObject var newIRFunctions:LoadJSONNewFunctionData
    @ObservedObject var dvcObj:LoadJSONData
    var body: some View {
        
        List(newIRFunctions.otherIRDevices , children: \.otherIRDevices){row in
            
            if(row.otherIRDevices == nil){
                NavigationLink(destination: OtherFunctionDetailView(newFunction: row, nf: newIRFunctions, dvcObj: dvcObj, activeSheet: $activeSheet)){
                    HStack{
                        Text(row.functionName)
                        Spacer()
                        Text(row.vendor)
                    }
                }
            }
            else{
                Text(row.deviceRealName)
            }
        }
    }
}

struct AddOtherFunctionView_Previews: PreviewProvider {
    static var previews: some View {
        AddOtherFunctionView(activeSheet: .constant(nil),newIRFunctions: LoadJSONNewFunctionData(), dvcObj: LoadJSONData())
    }
}
