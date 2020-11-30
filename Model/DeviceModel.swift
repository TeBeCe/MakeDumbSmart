//
//  DeviceModel.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 03/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import Foundation

struct Home: Codable, Identifiable {
    var home_name: String
    let id: Int
    var scenes: [Scene]
    var devices: [Device]
    var rooms: [Room]
}

struct Device:  Codable, Identifiable {
    let id: Int
    var device_name: String
    let device_custom_name: String?
    let glyph : String?
    var is_active: Bool
    let type: String
    var value: Float
    let max_level: Int?
    var room: Int?
    //    let functions: Functions?
}
struct Scene: Codable,Identifiable {
    var scene_name: String
    let id: Int
    var is_favorite: Bool
    let glyph: String?
    var is_active: Bool
    var devices : [Device]
}

struct Room: Codable, Identifiable {
    var room_name: String
    let id: Int
}
struct Functions: Codable {
    let state: xState?
    let level: Level?
    let mode: Mode?
    let special: Special?
}

struct xState : Codable {
    
    let name: String?
    let state: Bool?
}

struct Level: Codable {
    let name: Int?// String
    let level: Int?
}

struct Mode: Codable {
    let name: Int? // String
    let mode: Int?
}

struct Special: Codable {
    let func1: Int? // String
    let func2: Int?
}

enum FunctionEnum {
    case switchFunc
    case sliderFunc
    case levelsFunc
}

class LoadJSONData : ObservableObject {
    
    @Published var home = Home(home_name: "" ,id: 0 ,scenes: [] ,devices: [], rooms: [])
    @Published var devices = [Device]()
    @Published var scenes = [Scene]()
    @Published var rooms = [Room]()
    
    func loadData() {
        //        let jsonUrlString = "https://my.api.mockaroo.com/test_dp.json?key=96614480"
        //        let jsonUrlString = "https://my.api.mockaroo.com/test_dp_3.json?key=c7a70460"
        
        guard let urlx = URL(string: "https://my.api.mockaroo.com/test_dp_3.json?key=c7a70460") else { return }
        
        let request = URLRequest(url: urlx)
        
        URLSession.shared.dataTask(with: request){data, response,error in
            if let data = data {
                do {
                    DispatchQueue.main.async {
                        //                        print(data)
                        self.home = try! JSONDecoder().decode(Home.self, from: data)
                        self.devices = self.home.devices
                        self.scenes = self.home.scenes
                        self.rooms = self.home.rooms
                        //                        print(self.home)
                    }
                }
            }
            else{
                print(error!)
            }
        }.resume()
    }
    
    func updateDevice(device: Device)
    {
        if let indx = devices.firstIndex(where: {$0.id == device.id}){
            devices[indx] = device
        }
        else{
            print(devices)
        }
    }
    func getDevicesInRooms()->[TestData]{
        var returnData : [TestData] = []
        var devicesAssignedToRoom : [Device] = []
        for roomx in self.rooms
        {
            devicesAssignedToRoom = []
            for devicex in devices where devicex.room == roomx.id {
                devicesAssignedToRoom.append(devicex)
            }
            returnData.append(TestData(id: roomx.id,devices: devicesAssignedToRoom))
            
        }
        return returnData
    }
    func getDevicesInScene(scene: Scene)->[TestData]{
//        print(scene)
        var returnData : [TestData] = []
        var devicesAssignedToRoom : [Device] = []
        for roomx in self.rooms
        {
            devicesAssignedToRoom = []
            for devicex in devices where devicex.room == roomx.id {
                if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
                    if let _ =  scenes[indxSc].devices.firstIndex(where: {$0.id == devicex.id}){
                        devicesAssignedToRoom.append(devicex)
                    }}
            }
            if(devicesAssignedToRoom.count != 0){
                returnData.append(TestData(id: roomx.id,devices: devicesAssignedToRoom))
            }
        }
        return returnData
    }
    
    func isDeviceInScene(scene: Scene, device:Device)->Bool{
        //        var scene: Scene
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            if let _ =  scenes[indxSc].devices.firstIndex(where: {$0.id == device.id}){
                return true
            }
            else{return false}
        }
        else{
            print("something wrong")
            return false
        }
        //        return false
    }
    
    func addOrRemoveDeviceToScene(scene: Scene, device: Device){
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            if let indxDv =  scenes[indxSc].devices.firstIndex(where: {$0.id == device.id}){
                scenes[indxSc].devices.remove(at: indxDv)
                //                print("removing")
                //                print(scenes[indxSc].devices.count)
            }
            else{
                scenes[indxSc].devices.append(device)
                //                print("adding")
                //                print(scenes[indxSc].devices.count)
            }
        }
        else{
            
        }
    }
    func getSceneFromScenes(scene:Scene)->Scene{
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            return scenes[indxSc]
        }
        else {
            return Scene(scene_name: "DummyScene", id: 0, is_favorite: false, glyph: nil, is_active: true, devices: [])
        }
    }
    
    func createScene(scene: Scene){
        scenes.append(scene)
    }
    func validateScenes(){
//        if let indxSc = scenes.firstIndex(where: {$0.id == 0}){
//            print ("removing scene: \(scenes[indxSc].scene_name)")
//            scenes.remove(at: indxSc)
//        }
        scenes.removeAll(where: {$0.id == 0})
    }
    func deleteScene(scene:Scene){
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            print ("removing scene: \(scene.scene_name)")
            scenes.remove(at: indxSc)
        }
    }
    func getDevicesInSceneArray(scene: Scene)->[Device]{
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            return scenes[indxSc].devices
        }
        else{
            return []
        }
    }
}


