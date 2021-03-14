//
//  AddSimilarFunctionView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 11/03/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI


struct AddSimilarFunctionView: View {
    
    @Binding var activeSheet: ActiveSheet?
    @ObservedObject var newIRFunctions:LoadJSONNewFunctionData
    @ObservedObject var dvcObj:LoadJSONData
    var body: some View {
        
        List(newIRFunctions.similarIRDevices, children: \.similarIRDevices){row in
            
            if(row.similarIRDevices == nil){
                NavigationLink(destination: SimilarFunctionDetailView(newFunction: row, nf: newIRFunctions, dvcObj: dvcObj, activeSheet: $activeSheet)){
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

struct AddSimilarFunctionView_Previews: PreviewProvider {
    static var previews: some View {
        AddSimilarFunctionView(activeSheet: .constant(nil),newIRFunctions: LoadJSONNewFunctionData(), dvcObj: LoadJSONData())
    }
}
