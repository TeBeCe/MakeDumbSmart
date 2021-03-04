//
//  AddDeviceView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 28/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct AddDeviceView: View {
    @Binding var activeSheet: ActiveSheet?
    @ObservedObject var newFunctions = LoadJSONNewFunctionData()
    @ObservedObject var dvcObj:LoadJSONData
    
    var body: some View {
        NavigationView {
            VStack{
                if(newFunctions.loading){
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(3.5)
                }
                else{
                    List(newFunctions.data){newFunction in
                        NavigationLink(destination:NewFunctionDetailView(newFunction: newFunction, nf: newFunctions, dvcObj: dvcObj, activeSheet: $activeSheet)){
                            HStack{
                                Text(newFunction.functionName)
                            }
                        }
                    }
                }
            }.navigationBarTitle(Text("Add New Device"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action:{self.activeSheet = nil}){Image(systemName: "xmark.circle.fill")
                                    .font(.system(size:25, weight: .bold)).accentColor(.gray)})
            //        Button(action: {activeSheet = nil}, label: {
            //            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            //        })
            //        TestingView2()
        }.onAppear(perform: {
            newFunctions.loadData(param: "");
            dvcObj.continueRefresh = false
            print("appearing, disabling fetching")
        }).onDisappear(perform: {
            dvcObj.continueRefresh = true
            dvcObj.loadData()
            print("disappearing, enabling fetching")
        })
    }
}

struct AddDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        AddDeviceView(activeSheet: .constant(nil),dvcObj: LoadJSONData())
    }
}
