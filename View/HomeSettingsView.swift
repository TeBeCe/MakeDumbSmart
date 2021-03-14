//
//  HomeSettingsView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 30/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI
var images : [String] = ["Image","Image2","image3"]
struct HomeSettingsView: View {
    @Binding var activeSheet: ActiveSheet?
    @ObservedObject var dvcObj: LoadJSONData
    @Binding var home: Home
    @State var updateFreq: Double = 15.0
    @State var wallpaper : String = UserDefaults.standard.string(forKey: "Wallpaper") ?? images[0]
    var test : Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    //                    VStack(alignment: .leading) {
                    Section(header: Text("Home Name")) {
                        TextField("Home Name", text: $home.home_name, onEditingChanged: { _ in
                            print("changed")
                            dvcObj.backendUpdateHome(param: "home_id=1&home_name=" + home.home_name);
                        }).onChange(of: home.home_name){ _ in
                            
                        }}
                    //                    }
                    Section(header: Text("Wallpaper")) {
                        ScrollView(.horizontal){
                            HStack(spacing: 10){
                                ForEach(images , id: \.self){ i in
                                    Image(i)
                                        .resizable()
                                        .scaledToFit()
                                        .onTapGesture {
                                            UserDefaults.standard.set(i, forKey: "Wallpaper")
                                            wallpaper = i
                                        }.border(Color.orange, width: wallpaper == i ? 2 : 0)
                                    //                                    .border(Color.orange,width: (UserDefaults.standard.string(forKey: "Wallpaper") ?? images[0] == i) ? ( 1 ): (0))
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
                    Section(header: Text("Update frequency")) {
                        HStack{
                            Text("Frequency")
                            Spacer()
                            Text("\(String(format: "%.0f%", updateFreq))s")
                        }
                        Slider(value: $updateFreq,
                               in: 6...60,
                               step:1.0,
                               minimumValueLabel: Text("6"),
                               maximumValueLabel: Text("60"),label:{
                                //                            Text("\(String(format: "%.0f%", updateFreq))")
                                Text("bla bla")
                               })
                    }//TODO: do
                    
                }
                
            }.navigationBarTitle(Text("Home Settings"), displayMode: .inline)
        }
    }
}

struct HomeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSettingsView(activeSheet: .constant(nil), dvcObj: LoadJSONData(), home: .constant(Home(home_name: "Test Name", id: 1, scenes: [], devices: [], rooms: [])))
    }
}
