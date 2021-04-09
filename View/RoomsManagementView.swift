//
//  RoomsManagementView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 13/03/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct RoomsManagementView: View {
    @Binding var activeSheet: ActiveSheet?
    @ObservedObject var dvcObj: LoadJSONData
    @Binding var home: Home
    @State var roomName : String = ""
    var body: some View {
//        NavigationView{
            VStack{
                List{
                    ForEach(home.rooms){ room in
                        
                        Text(room.room_name).deleteDisabled(home.rooms[0].id == room.id ? true : false)
                            
                        
                    }.onDelete(perform: { indexSet in
                        
                        let deletedRoomIndex = Array(indexSet)[0]
                        print(deletedRoomIndex)
                        dvcObj.deleteRoom(room: home.rooms[deletedRoomIndex])
                        dvcObj.deleteBackendRoom(room: home.rooms[deletedRoomIndex])
//                        home.rooms.remove(atOffsets: indexSet)
                    })
                    HStack{
                        TextField("Room Name",text: $roomName)
                            .disableAutocorrection(true)
                        Button(action:{
//                            home.rooms.append(Room(room_name: roomName, id: 0))
                            dvcObj.createRoom(room: Room(id: 0, room_name: roomName))
                            dvcObj.createBackendRoom(room: Room(id: 0, room_name: roomName))
                            roomName = ""
                        } ){
                            Text("Create Room")
                        }.disabled(roomName == "" ? true : false)
                        .help(Text("Help Content"))
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                
            }
            .navigationTitle(Text("Rooms Management")).navigationBarTitleDisplayMode(.large)
//        }
    }
}

struct RoomsManagementView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsManagementView(activeSheet: .constant(nil), dvcObj: LoadJSONData(), home: .constant(Home(home_name: "Test Name", id: 1, scenes: [], devices: [], rooms: [Room(id: 1, room_name: "nice room")], modules: [], automatizations: [])))
    }
}
