//
//  HomeSettingsView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 30/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI
var images : [String] = ["Image","Image1","Image2","Image3","Image4","Image5","Image6"]
struct HomeSettingsView: View {
    @AppStorage("logged_status") var validated = true
    @AppStorage("use_biometrics") var useBiometrics = true
    @AppStorage("update_frequency") var updateFreq = 15.0
    @AppStorage("wallpaper") var wallpaper = images[0]
    
    @AppStorage("ask_biometrics") var askBiomOnLogIn = false

    @Binding var activeSheet: ActiveSheet?
    @ObservedObject var dvcObj: LoadJSONData
    @Binding var home: Home
//    @State var wallpaper : String = UserDefaults.standard.string(forKey: "Wallpaper") ?? images[0]
    var test : Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    //                    VStack(alignment: .leading) {
                    Section(header: Text("Home Name")) {
                        TextField("Home Name", text: $home.home_name, onEditingChanged: { editing in
                                    if !editing{
                                        dvcObj.genericBackendUpdate(param: "home_id=1&home_name=" + home.home_name);
                                    }
                        }).disableAutocorrection(true)
                    }
                    //                    }
                    Section(header: Text("Wallpaper")) {
                        ScrollView(.horizontal){
                            HStack(spacing: 10){
                                ForEach(images , id: \.self){ i in
                                    Image(decorative: i)
                                        .resizable()
                                        .scaledToFit()
                                        .onTapGesture {
                                            wallpaper = i
                                        }.border(Color.orange, width: wallpaper == i ? 2 : 0)
                                }
                            }
                        }.frame(height: 200)
                    }.listStyle(InsetGroupedListStyle())
                    Section(header: Text("Rooms Management")){
                        NavigationLink(destination: RoomsManagementView(activeSheet: $activeSheet, dvcObj: dvcObj, home: $home)){
                            HStack{
                                Text("Rooms")
                                Spacer()
                                Text("\(home.rooms.count)")
                            }
                        }
                        
                    }
                    Section(header: Text("Modules Management")){
                        NavigationLink(destination: ModuleManagementView(activeSheet: $activeSheet, dvcObj: dvcObj, home: $home)){
                            HStack{
                                Text("Modules")
                                Spacer()
                                Text("\(home.modules.count)")
                            }
                        }
                        
                    }
                    Section(header: Text("Update frequency")) {
                        HStack{
                            Text("Frequency")
                            Spacer()
                            Text("\(String(format: "%.0f%", updateFreq)) sec.")
                        }
                        Slider(value: $updateFreq,
                               in: 6...60,
                               step:1.0,
                               onEditingChanged: { data in
                                print(data)
                               }, minimumValueLabel: Text("6"),
                               maximumValueLabel: Text("60"),
                               label:{
                                //                            Text("\(String(format: "%.0f%", updateFreq))")
                                Text("bla bla")
                               })
                    }
                    Section(header: Text("Use biometrics"),footer: Text("Lock app after closing app without logging out")){
                        Toggle(isOn: $useBiometrics) {
                            Text("Use Biometrics")
                        }
                    }
                    Button(action: {
                        validated = false
                        askBiomOnLogIn = false
                    }){
                        Text("Log Out")
                            .foregroundColor(.red)
                    }
                }
                
            }.navigationBarTitle(Text("Home Settings"), displayMode: .inline)
        }
    }
}

struct HomeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSettingsView(activeSheet: .constant(nil), dvcObj: LoadJSONData(), home: .constant(Home(home_name: "Test Name", id: 1, scenes: [], devices: [], rooms: [], modules: [])))
    }
}
