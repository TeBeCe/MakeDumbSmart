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
    var scene_devices: [SceneDevice]
}

struct Room: Codable, Identifiable {
    var room_name: String
    let id: Int
}

struct SceneDevice: Codable, Identifiable{
    let id: Int
    var value: Float
    var is_active: Bool
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
    @Published var devices_in_room = [TestData]()
    
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
    
    func addOrRemoveSceneDeviceToScene(scene: Scene, device: Device){
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            if let indxDv = scenes[indxSc].scene_devices.firstIndex(where: {$0.id == device.id}){
                scenes[indxSc].scene_devices.remove(at: indxDv)
            }
            else{
                scenes[indxSc].scene_devices.append(SceneDevice(id: device.id,value: device.value , is_active: device.is_active))
            }
        }
    }
    
    func getSceneFromScenes(scene:Scene)->Scene{
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            return scenes[indxSc]
        }
        else {
            return Scene(scene_name: "DummyScene", id: 0, is_favorite: false, glyph: nil, is_active: true, devices: [], scene_devices: [])
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
    
    func modifyDeviceInScene(scene:Scene, device:Device)->[Int]{
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            if let indxDv = scenes[indxSc].devices.firstIndex(where: {$0.id == device.id}){
                return [indxSc,indxDv]
            }
        }
        return [0,0]
    }
//
// Probably could be deleted
//
    func internalDetermineValue(device: Device)-> String {
        
        switch device.type{
        case "Switch" :
            return !device.is_active || device.value == 0.0 ? "Vyp." : "Zap."
        case "Slider" :
            return !device.is_active || device.value == 0.0 ? "Vyp." : "\(String(format: "%.1f%", device.value))%"
        case "Levels" :
            return !device.is_active || device.value == 0.0 ? "Vyp." : "\(String(format: "%.0f%", device.value))"
            
        default:
            return "Unknown device type/state"
        }
    }
    
    func activateScene(scene: Scene){
        if let indSc = scenes.firstIndex(where:{ $0.id == scene.id}){
            for device in scenes[indSc].devices {
//                if let indDvc = devices.firstIndex(where: {$0.id == device.id}){
//                    make copy of device for now, we will need to copy new value and store old
                    updateDevice(device: device)
//                }
            }
        }
        
    }
    
    func updateScene(scene: Scene){
        if let indx = scenes.firstIndex(where: {$0.id == scene.id}){
            scenes[indx] = scene
        }
        else{
            print(scenes)
        }
    }
    
    func updateDeviceInScene(scene:Scene, device:Device){
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            if let indxDv = scenes[indxSc].devices.firstIndex(where: {$0.id == device.id}){
                scenes[indxSc].devices[indxDv] = device
            }
        }
    }
}


