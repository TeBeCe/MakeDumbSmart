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
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    TextField("Home Name", text: $dvcObj.home.home_name)
                }.listStyle(InsetGroupedListStyle())
            }.navigationBarTitle(Text("Home"), displayMode: .inline)
        }
    }
}

struct HomeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSettingsView(activeSheet: .constant(nil), dvcObj: LoadJSONData())
    }
}
