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
    @ObservedObject var newIRFunctions = LoadJSONNewFunctionData()
    @ObservedObject var dvcObj:LoadJSONData
    
    var body: some View {
        NavigationView {
            TabView {
                AddMyFunctionsView(activeSheet: $activeSheet, newIRFunctions: newIRFunctions, dvcObj: dvcObj)
                    .tabItem {
                        Label("My Functions", systemImage: "list.dash")
                    }
                
                AddSimilarFunctionView(activeSheet: $activeSheet, newIRFunctions: newIRFunctions, dvcObj: dvcObj)
                    .tabItem {
                        Label("Similar Functions", systemImage: "square.and.pencil")
                    }
                AddOtherFunctionView(activeSheet: $activeSheet, newIRFunctions: newIRFunctions, dvcObj: dvcObj)
                    .tabItem {
                        Label("Other Functions", systemImage: "square.and.pencil")
                    }
            }

            .navigationBarTitle(Text("Add New Device"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action:{self.activeSheet = nil}){
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size:25, weight: .bold)).accentColor(.gray)})
        }.navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            newIRFunctions.loadData(param: "");
            print(newIRFunctions.similarIRDevices)
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
