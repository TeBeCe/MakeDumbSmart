//
//  HomeSettingsView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 30/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct HomeSettingsView: View {
    @Binding var activeSheet: ActiveSheet?
    @ObservedObject var dvcObj: LoadJSONData
    @Binding var home: Home
    var test : Bool = false
    var images : [String] = ["Image","Image2"]
    var body: some View {
        NavigationView {
            VStack {
                List {
                    VStack(alignment: .leading) {
                        TextField("Home Name", text: $home.home_name, onEditingChanged: { _ in
                            print("changed")
                            dvcObj.backendUpdateHome(param: "home_id=1&home_name=" + home.home_name);
                        }).onChange(of: home.home_name){ _ in
                            
                        }
                    }
                    
                    ScrollView(.horizontal){
                        HStack(spacing: 10){
                            ForEach(images , id: \.self){ i in
                                Image(i)
                                    .resizable()
//                                    .frame(width:50, height: 200)
                                    .scaledToFit()
                            }
                        }
                    }.frame(height: 200)
                    
                }.listStyle(InsetGroupedListStyle())
            }.navigationBarTitle(Text("Home Settings"), displayMode: .inline)
        }
    }
}

struct HomeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSettingsView(activeSheet: .constant(nil), dvcObj: LoadJSONData(), home: .constant(Home(home_name: "tst", id: 1, scenes: [], devices: [], rooms: [])))
    }
}
