//
//  ModuleManagementView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 20/03/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct ModuleManagementView: View {
    @AppStorage("logged_user_id") var userId = 0
    
    @Binding var activeSheet: ActiveSheet?
    @ObservedObject var dvcObj: LoadJSONData
    @Binding var home: Home
    @State var moduleName : String = ""
    var link: String = "https://divine-languages.000webhostapp.com/download_source_code.php?module_id="
    var body: some View {
        VStack{
            List{
                ForEach(home.modules){ module in
                    
                    HStack{
                        Text(module.module_name).deleteDisabled(home.modules[0].id == module.id ? true : false)
                        Spacer()
                        Link(destination: URL(string: link + String(module.id) + "&user_id=\(userId)" + "&module_name=\(module.module_name)")!){
                            HStack{
                                Image(systemName: "link")
                                Text("Source code")
                            }
                        }
                    }
                        
                    
                }.onDelete(perform: { indexSet in
                    
                    let deletedModuleIndex = Array(indexSet)[0]
                    print(deletedModuleIndex)
                    dvcObj.deleteModule(module: Module(id:0, module_name: moduleName))
                    dvcObj.deleteBackendModule(module: home.modules[deletedModuleIndex])
//                        home.rooms.remove(atOffsets: indexSet)
                })
                HStack{
                    TextField("Module Name",text: $moduleName)
                        .disableAutocorrection(true)
                    Button(action:{
//                        home.modules.append(Module(id: 0, module_name: moduleName))
                        dvcObj.createModule(module: Module(id:0, module_name: moduleName))
                        dvcObj.createBackendModule(module: Module(id:0, module_name: moduleName))
                        moduleName = ""
                    } ){
                        Text("Create Module")
                    }.disabled(moduleName == "" ? true : false)
                    .help(Text("Help Content"))
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle(Text("Module Management")).navigationBarTitleDisplayMode(.large)
    }
}

struct ModuleManagementView_Previews: PreviewProvider {
    static var previews: some View {
        ModuleManagementView(activeSheet: .constant(nil), dvcObj: LoadJSONData(), home: .constant(Home(home_name: "Test Name", id: 1, scenes: [], devices: [], rooms: [Room(id: 1, room_name: "nice room")], modules: [], automatizations: [])))
    }
}
