//
//  AssignDevicesToAutomationView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 05/04/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct AssignDevicesToAutomationView: View {
    @ObservedObject var dvcObj : LoadJSONData
    @Binding var automatization : Automatization
    @State var devicesInRoom : [TestData]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
//        GridItem(.adaptive(minimum: 120, maximum: 120))
    ]
    
    var body: some View {
        NavigationView{
            List{
                ForEach(devicesInRoom){ roomDev in
                    Section(header: Text(roomDev.roomName)){
                        LazyVGrid(columns: columns,spacing: 10){
                            ForEach(roomDev.devices){device in
                                CheckableDeviceView(device:device,checked:dvcObj.isDeviceInAutomatization(automatization: automatization, device: device))
//                                CheckableDeviceView(device:device,checked:true)
                                    .onTapGesture {
                                        automatization = dvcObj.addOrRemoveDeviceToAutomatization(automatization: automatization, device: device)
                                    }
                            }
                        }.padding(.leading,-20)
                        .padding(.trailing,-20)
                    }.listRowBackground(Color(UIColor.init(named:"bgColor")!))
                }
            }
            .navigationBarTitle(Text("Add / Remove Accesory"), displayMode: .inline)
            
        }
    }
}

struct AssignDevicesToAutomationView_Previews: PreviewProvider {
    static var previews: some View {
        AssignDevicesToAutomationView(dvcObj: LoadJSONData(), automatization: .constant(Automatization(id:0,devices: [],scenes: [])), devicesInRoom: [])
    }
}
