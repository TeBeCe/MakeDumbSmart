//
//  DeviceModel.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 03/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import Foundation
import SwiftUI

struct Home: Codable, Identifiable {
    var home_name: String
    let id: Int
    var scenes: [Scene]
    var devices: [Device]
    var rooms: [Room]
    var modules: [Module]
    var automatizations: [Automatization]
}

struct Device:  Codable, Identifiable {
    let id: Int
    var device_name: String
    var module_id : Int?
    let device: String?
    var reseting: Bool
    var glyph : String
    var is_active: Bool
    let type: String
    var value: Float
    let max_level: Int?
    var room: Int
    var processing:Int
}

struct Scene: Codable, Identifiable {
    var scene_name: String
    let id: Int
    var is_favorite: Bool
    var glyph: String
    var is_active: Bool
    var devices : [Device]
    var scene_devices: [SceneDevice]
}

struct Room: Codable, Identifiable {
    let id: Int
    var room_name: String
}

struct Module: Codable, Identifiable {
    let id: Int
    var module_name: String
}

struct SceneDevice: Codable, Identifiable{
    let id: Int
    var value: Float
    var is_active: Bool
}

struct Automatization: Codable, Identifiable {
    let id : Int
    var devices : [Device]
    var scenes : [Scene]
    var time : String?
    var days : [Bool]?
    var sensor_id : Int?
    var sensor_value : Float?
    var sensor_condition : Bool?//false = less, true = more
}

class LoadJSONData : ObservableObject {
    
    @Published var home = Home(home_name: "Loading..." ,id: 0 ,scenes: [] ,devices: [], rooms: [], modules: [], automatizations: [])
    @Published var devices = [Device]()
    @Published var scenes = [Scene]()
    @Published var rooms = [Room]()
    @Published var modules = [Module]()
    @Published var devices_in_room = [TestData]()
    @Published var automatizations = [Automatization]()
    
    @AppStorage("update_frequency") var updateFreq = 15.0
    @AppStorage("logged_user_id") var userId = 0
    var count = 0
    var continueRefresh = true
    
    func loadData() {
        count += 1
        guard let url = URL(string: "https://divine-languages.000webhostapp.com/to_mobile.php") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        //        let postString = "home_id=1&home_name=" + self.home.home_name;
        let postString = "user_id=\(userId)"
                print(postString)
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        URLSession.shared.dataTask(with: request){data, response,error in
            if let data = data {
                do {
                    DispatchQueue.main.async {
//                        let dcd = JSONDecoder()
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.timeStyle = .medium
//                        dcd.dateDecodingStrategy = .formatted(dateFormatter)
                        //print(data)
                        self.home = try! JSONDecoder().decode(Home.self, from: data)
                        self.devices = self.home.devices
                        self.scenes = self.home.scenes
                        self.rooms = self.home.rooms
                        self.modules = self.home.modules
                        self.automatizations = self.home.automatizations
                        self.findAndActivateScene()
                        print("loadedData")
                        //print(self.home)
                    }
                }
//                catch {
//                    print("xxx")
//                }
            }
            else{
                print(error!.localizedDescription)
            }
        }.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + updateFreq){[self] in
            count -= 1
            if(continueRefresh){
                print(updateFreq)
                print("count: \(count)")
                if(count == 0){
                    self.loadData()
                    print("fetching")
                }
            }
            
        }
//        Timer.scheduledTimer(withTimeInterval: updateFreq, repeats: false){[weak self] timer in
//            if((self?.continueRefresh) != nil){
//                            print(updateFreq)
//               self?.loadData()
//                        }
//          print("fetching")
//        }
    }
    
    func updateDevice(device: Device){
        if let indx = devices.firstIndex(where: {$0.id == device.id}){
            devices[indx] = device
        }
    }
    
    func updateSceneGlyph(scene: Scene){
        if let ind = scenes.firstIndex(where: {$0.id == scene.id}){
            scenes[ind].glyph = scene.glyph
        }
    }
    
    func getDevicesInRooms()->[TestData]{
        var returnData : [TestData] = []
        var devicesAssignedToRoom : [Device] = []
        for roomx in self.rooms
        {
            devicesAssignedToRoom = []
            for devicex in devices where devicex.room == roomx.id && !devicex.type.contains("sensor") {
                devicesAssignedToRoom.append(devicex)
            }
            if(devicesAssignedToRoom.count > 0){
                returnData.append(TestData(id: roomx.id,roomName: roomx.room_name ,devices: devicesAssignedToRoom))
            }
        }
        return returnData
    }
    
    func getSensorsInRooms()->[TestData]{
        var returnData : [TestData] = []
        var devicesAssignedToRoom : [Device] = []
        for roomx in self.rooms
        {
            devicesAssignedToRoom = []
            for devicex in devices where devicex.room == roomx.id && devicex.type.contains("sensor") {
                devicesAssignedToRoom.append(devicex)
            }
            if(devicesAssignedToRoom.count > 0){
                returnData.append(TestData(id: roomx.id,roomName: roomx.room_name ,devices: devicesAssignedToRoom))
            }
        }
        return returnData
    }
    
    func getRoomName(index: Int)->String {
        if let idx = self.rooms.firstIndex(where: {$0.id == index}){
            return self.rooms[idx].room_name
        }
        return ""
    }
    
    func getModuleName(index: Int)->String {
        if let idx = self.modules.firstIndex(where: {$0.id == index}){
            return self.modules[idx].module_name
        }
        return ""
    }
    
    func createRoom(room: Room){
        self.rooms.append(room)
        print(rooms)
    }
    
    func createBackendRoom(room: Room){
        let param = "room_idk=create"
            + "&room_name=\(room.room_name)"
        genericBackendUpdate(param: param)
    }
    
    func deleteRoom(room: Room){
        var params:[String] = []
        if let indx = self.rooms.firstIndex(where: {$0.id == room.id}) {
            self.rooms.remove(at: indx)
            //check all devices and devices in scene
            for device in self.devices {
                if(device.room == room.id){
                    if let dvc = self.devices.firstIndex(where: {$0.id == device.id}) {
                        print("removing old room if from device \(self.devices[dvc].device_name)")
                        self.devices[dvc].room = rooms[0].id
                        let deviceToUpdate = self.devices[dvc]
                        params.append("device_idk=update"
                                        + "&device_id=\(deviceToUpdate.id)"
                                        + "&device_module=\(device.module_id ?? 1)"
                                        + "&device_name=\(deviceToUpdate.device_name)"
                                        + "&device_value=\(deviceToUpdate.value)"
                                        + "&device_type=\(deviceToUpdate.type)"
                                        + "&device_glyph=\(deviceToUpdate.glyph)"
                                        + "&device_is_active=\(deviceToUpdate.is_active)"
                                        + "&device_room=\(deviceToUpdate.room)")
                    }
                }
            }
            for i in 0..<self.scenes.count {
                for j in 0..<self.scenes[i].devices.count{
                    if(self.scenes[i].devices[j].room == room.id){
                        print("removing old room id from scene device \(self.scenes[i].devices[j].device_name)")
                        self.scenes[i].devices[j].room = rooms[0].id
                        let sceneToUpdate = self.scenes[i]
                        let encoder = JSONEncoder()

                        let scene_devices = try! encoder.encode(sceneToUpdate.devices)

                        params.append("scene_idk=update"
                                        + "&scene_id=\(sceneToUpdate.id)"
                                        + "&scene_name=\(sceneToUpdate.scene_name)"
                                        + "&scene_is_favorite=\(sceneToUpdate.is_favorite)"
                                        + "&scene_glyph=\(sceneToUpdate.glyph)"
                                        + "&scene_devices=\(String(data: scene_devices, encoding: .utf8)!)")
                    }
                }
            }
        }
        genericRecBackendUpdate(params: params)
    }
    
    func deleteBackendRoom(room: Room){
        let param = "room_idk=delete" +
            "&room_id=\(room.id)" +
            "&room_name=\(room.room_name)"
        genericBackendUpdate(param: param)
    }
    
    func changeRoomInSceneDevices(device: Device, toId: Int){
        var params:[String] = []
        for i in 0..<self.scenes.count {
            for j in 0..<self.scenes[i].devices.count{
                if(self.scenes[i].devices[j].id == device.id){
                    print("changin old room id from scene device \(self.scenes[i].devices[j].device_name)")
                    self.scenes[i].devices[j].room = toId
                    let sceneToUpdate = self.scenes[i]
                    let encoder = JSONEncoder()

                    let scene_devices = try! encoder.encode(sceneToUpdate.devices)

                    params.append("scene_idk=update"
                                    + "&scene_id=\(sceneToUpdate.id)"
                                    + "&scene_name=\(sceneToUpdate.scene_name)"
                                    + "&scene_is_favorite=\(sceneToUpdate.is_favorite)"
                                    + "&scene_glyph=\(sceneToUpdate.glyph)"
                                    + "&scene_devices=\(String(data: scene_devices, encoding: .utf8)!)")
                }
            }
        }
        
        genericRecBackendUpdate(params: params)

    }
    
    func createModule(module: Module){
        self.modules.append(module)
        print(module)
    }
    
    func createBackendModule(module: Module){
        let param = "module_idk=create"
            + "&module_name=\(module.module_name)"
        genericBackendUpdate(param: param)
    }
    
    func deleteModule(module: Module){
        var params:[String] = []
        if let indx = self.modules.firstIndex(where: {$0.id == module.id}) {
            self.modules.remove(at: indx)
            //check all devices and devices in scene
            for device in self.devices {
                if(device.module_id == module.id){
                    if let dvc = self.devices.firstIndex(where: {$0.id == device.id}) {
                        print("removing old module if from device \(self.devices[dvc].device_name)")
                        self.devices[dvc].module_id = modules[0].id
                        let deviceToUpdate = self.devices[dvc]
                        params.append("device_idk=update"
                                        + "&device_id=\(deviceToUpdate.id)"
                                        + "&device_module=\(device.module_id ?? 1)"
                                        + "&device_name=\(deviceToUpdate.device_name)"
                                        + "&device_value=\(deviceToUpdate.value)"
                                        + "&device_type=\(deviceToUpdate.type)"
                                        + "&device_glyph=\(deviceToUpdate.glyph)"
                                        + "&device_is_active=\(deviceToUpdate.is_active)"
                                        + "&device_room=\(deviceToUpdate.room)")
                    }
                }
            }
            for i in 0..<self.scenes.count {
                for j in 0..<self.scenes[i].devices.count{
                    if(self.scenes[i].devices[j].module_id == module.id){
                        print("removing old module id from scene device \(self.scenes[i].devices[j].device_name)")
                        self.scenes[i].devices[j].module_id = modules[0].id
                        let sceneToUpdate = self.scenes[i]
                        let encoder = JSONEncoder()

                        let scene_devices = try! encoder.encode(sceneToUpdate.devices)

                        params.append("scene_idk=update"
                                        + "&scene_id=\(sceneToUpdate.id)"
                                        + "&scene_name=\(sceneToUpdate.scene_name)"
                                        + "&scene_is_favorite=\(sceneToUpdate.is_favorite)"
                                        + "&scene_glyph=\(sceneToUpdate.glyph)"
                                        + "&scene_devices=\(String(data: scene_devices, encoding: .utf8)!)")
                    }
                }
            }
        }
        genericRecBackendUpdate(params: params)
    }
    
    func deleteBackendModule(module: Module){
        let param = "module_idk=delete" +
            "&module_id=\(module.id)" +
            "&module_name=\(module.module_name)"
        genericBackendUpdate(param: param)
    }
    
    func changeModuleInSceneDevices(device: Device, toId: Int){
        var params:[String] = []
        for i in 0..<self.scenes.count {
            for j in 0..<self.scenes[i].devices.count{
                if(self.scenes[i].devices[j].id == device.id){
                    print("changin old module id from scene device \(self.scenes[i].devices[j].device_name)")
                    self.scenes[i].devices[j].module_id = toId
                    let sceneToUpdate = self.scenes[i]
                    let encoder = JSONEncoder()

                    let scene_devices = try! encoder.encode(sceneToUpdate.devices)

                    params.append("scene_idk=update"
                                    + "&scene_id=\(sceneToUpdate.id)"
                                    + "&scene_name=\(sceneToUpdate.scene_name)"
                                    + "&scene_is_favorite=\(sceneToUpdate.is_favorite)"
                                    + "&scene_glyph=\(sceneToUpdate.glyph)"
                                    + "&scene_devices=\(String(data: scene_devices, encoding: .utf8)!)")
                }
            }
        }
        
        genericRecBackendUpdate(params: params)

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
                returnData.append(TestData(id: roomx.id, roomName: roomx.room_name,devices: devicesAssignedToRoom))
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
//            print(self.scenes)
            for scenex in self.scenes {
                print("\(scenex.scene_name) x")
            }
            print("something wrong")
            return false
        }
    }
    
    func addOrRemoveDeviceToScene(scene: Scene, device: Device) -> Scene{
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            if let indxDv =  scenes[indxSc].devices.firstIndex(where: {$0.id == device.id}){
                scenes[indxSc].devices.remove(at: indxDv)
            }
            else{
                scenes[indxSc].devices.append(device)
                scenes[indxSc].devices.sort(by: {$0.reseting && !$1.reseting})
                scenes[indxSc].devices.sort(by: {$0.device ?? "" > $1.device ?? "" })
                print(scenes[indxSc].devices)
            }
            if(scene.id != 0){
                print(scenes[indxSc])
                updateBackendScene(scenex: scenes[indxSc])
            }
            return scenes[indxSc]
        }
        else{
            return scene
        }
    }
    
    func addOrRemoveSceneDeviceToScene(scene: Scene, device: Device){
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            if let indxDv = scenes[indxSc].scene_devices.firstIndex(where: {$0.id == device.id}){
                scenes[indxSc].scene_devices.remove(at: indxDv)
            }
            else{
                scenes[indxSc].scene_devices.append(SceneDevice(id: device.id,value: device.value ,
                                                                is_active: device.is_active))
            }
        }
    }
    
    func getSceneFromScenes(scene:Scene)->Scene{
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            return scenes[indxSc]
        }
        else {
            return Scene(scene_name: "DummyScene", id: 0, is_favorite: false, glyph: "lighbulb",
                         is_active: true, devices: [], scene_devices: [])
        }
    }
    
    func createScene(scene: Scene){
        self.scenes.append(scene)
        print("createdScene: \(scene.scene_name)")
        for scenex in self.scenes {
            print("\(scenex.scene_name) x")
        }
//        print(self.scenes)
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
            deleteBackendScene(scene: scene)
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
    
    func activateScene(scene: Scene){
        if let indSc = scenes.firstIndex(where:{ $0.id == scene.id}){
            var params:[String] = []
            var deviceName = ""
            var index = 0
            var xDevice : Device
            print("Running scene, updating devices:")
            for device in scenes[indSc].devices {
                if let indDv = devices.firstIndex(where: {$0.id == device.id}){
                    var multiplier = 1
                    xDevice = device
                    if(device.reseting){//set to reset next devices
                        deviceName = device.device ?? ""
                    }
                    if(device.device == deviceName){//these will reset, so we make them value 0
                        xDevice.value = 0
                        xDevice.is_active = false
                        multiplier = Int(device.value) + (device.reseting && Int(devices[indDv].value) != 0 ? 1 : 0)
                        print("value: \(devices[indDv].value)")
                        print("deactivating: \(xDevice.device_name)")
                        print("times to activate after reset: \(multiplier)")
                    }
                    else{
                        let actual = Int(devices[indDv].value)
                        if(actual < Int(xDevice.value)  ){
                            multiplier = Int(xDevice.value) - actual
                        }
                        else if(actual > Int(xDevice.value)){
                            multiplier = Int(xDevice.max_level ?? 1) - actual + Int(xDevice.value) + 1
                        }
                        else if(actual == Int(xDevice.value)){
                            multiplier = 0
                        }
                        
                        print("non resetable: \(xDevice.device_name)")
                        print("times to activate without resetting: \(multiplier)")
                    }
                    
                    print("\(device.device_name) value: \(device.value)")
                    print("")
                    updateDevice(device: device)
                    //activateBackendDevice(device: device, multiplier: multiplier)
                    //updateBackendDevice(device: device)
                    //                }
                    params.append("device_idk=activate"
                                    + "&device_id=\(device.id)"
                                    + "&device_module=\(device.module_id ?? 1)"
                                    + "&device_name=\(device.device_name)"
                                    + "&device_value=\(device.value)"
                                    + "&device_type=\(device.type)"
                                    + "&device_glyph=\(device.glyph)"
                                    + "&device_is_active=\(device.is_active)"
                                    + "&device_room=\(device.room)"
                                    + "&device_repeat=\(multiplier)")
                    index += 1
                }
            }
            genericRecBackendUpdate(params: params)
        }
    }
    
    func activateDevice(device: Device){
        var params: [String] = []
        if(device.reseting){
//            let test = self.devices.filter($0.device == device.device)
            for var dvc in self.devices {
                if(dvc.device == device.device && dvc.id != device.id && device.value == 0.0){
                    if let indDv = devices.firstIndex(where: {$0.id == dvc.id}){
                        print("updating device to value 0 : \(dvc.device_name)")
                        self.devices[indDv].value = 0.0
                        self.devices[indDv].is_active = false
                        dvc.value = 0.0
                        dvc.is_active = false
                        params.append("device_idk=update"
                                        + "&device_id=\(dvc.id)"
                                        + "&device_module=\(dvc.module_id ?? 1)"
                                        + "&device_name=\(dvc.device_name)"
                                        + "&device_value=\(dvc.value)"
                                        + "&device_type=\(dvc.type)"
                                        + "&device_glyph=\(dvc.glyph)"
                                        + "&device_is_active=\(dvc.is_active)"
                                        + "&device_room=\(dvc.room)")
                    }
                }
            }
        }
        if let indDv = devices.firstIndex(where: {$0.id == device.id}){
            var multiplier = 0
            print(devices[indDv])
            let actual = Int(devices[indDv].value)
            if(actual < Int(device.value)  ){
                multiplier = Int(device.value) - actual
            }
            else if(actual > Int(device.value)){
                multiplier = Int(device.max_level ?? 1) - actual + Int(device.value) + 1
            }
            else if(actual == Int(device.value)){
                multiplier = 0
            }
            
            print("actual val: \(actual) new:\(device.value) multip:\(multiplier)")
            devices[indDv] = device
            print("\(devices[indDv].value)")
            activateBackendDevice(device: device, multiplier: multiplier)
            genericRecBackendUpdate(params: params)

        }
    }
    
    func activateBackendDevice(device: Device,multiplier: Int){
        let param = "device_idk=activate"
            + "&device_id=\(device.id)"
            + "&device_module=\(device.module_id ?? 1)"
            + "&device_name=\(device.device_name)"
            + "&device_value=\(device.value)"
            + "&device_type=\(device.type)"
            + "&device_glyph=\(device.glyph)"
            + "&device_is_active=\(device.is_active)"
            + "&device_room=\(device.room)"
            + "&device_repeat=\(multiplier)"
//        print(param)
        genericBackendUpdate(param: param)
    }
    
    func updateScene(scene: Scene){
        if let indx = scenes.firstIndex(where: {$0.id == scene.id}){
            scenes[indx] = scene
        }
    }
    
    func updateDeviceInScene(scene:Scene, device:Device){
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            if let indxDv = scenes[indxSc].devices.firstIndex(where: {$0.id == device.id}){
                scenes[indxSc].devices[indxDv] = device
            }
//            updateBackendScene(scenex: scenes[indxSc])
        }
    }
    
    func updateBackendDeviceInScene(scene:Scene){
        if let indxSc = scenes.firstIndex(where: {$0.id == scene.id}){
            updateBackendScene(scenex: scenes[indxSc])
        }
    }
    
    func getDeviceInScenes(device: Device) -> [Scene]{
        var toReturnScenes : [Scene] = []
        for scene in scenes {
            if let _ = scene.devices.firstIndex(where: {$0.id == device.id}){
                toReturnScenes.append(scene)
            }
        }
        return toReturnScenes
    }
    
//    func backendUpdateHome(param : String){
//        // Prepare URL
//        let url = URL(string: "https://divine-languages.000webhostapp.com/to_mobile.php")
//        guard let requestUrl = url else { fatalError() }
//        // Prepare URL Request Object
//        var request = URLRequest(url: requestUrl)
//        request.httpMethod = "POST"
//
//        // HTTP Request Parameters which will be sent in HTTP Request Body
//        let postString = param
//        // Set HTTP Request Body
//        request.httpBody = postString.data(using: String.Encoding.utf8);
//        // Perform HTTP Request
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            // Check for Error
//            if let error = error {
//                print("Error took place \(error)")
//                return
//            }
//
//            // Convert HTTP Response Data to a String
//            if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                print("Response data string:\n \(dataString)")
//            }
//        }
//        task.resume()
//    }
    
    func genericBackendUpdate(param : String){
        // Prepare URL
        let url = URL(string: "https://divine-languages.000webhostapp.com/to_mobile.php")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        //        let postString = "home_id=1&home_name=" + self.home.home_name;
        let postString = "user_id=\(userId)&" + param
                print(postString)
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        //        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        //
        //                // Check for Error
        //                if let error = error {
        //                    print("Error took place \(error)")
        //                    return
        //                }
        //
        //                // Convert HTTP Response Data to a String
        //                if let data = data, let dataString = String(data: data, encoding: .utf8) {
        //                    print("Response data string:\n \(dataString)")
        //                }
        //
        //        }
        //        task.resume()
        URLSession.shared.dataTask(with: request){data, response, error in
            if let data = data {
                do {
                    DispatchQueue.main.async {
                        self.home = try! JSONDecoder().decode(Home.self, from: data)
                        self.devices = self.home.devices
                        self.scenes = self.home.scenes
                        self.rooms = self.home.rooms
                        self.automatizations = self.home.automatizations

                        self.findAndActivateScene()
//                        print(self.home)
                    }
                }
            }
            else{
                print(error!)
            }
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
        }.resume()
    }
    
    //special recursive func as queue was out of order in IRQueue db
    func genericRecBackendUpdate(params: [String]){
        // Prepare URL
        let url = URL(string: "https://divine-languages.000webhostapp.com/to_mobile.php")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        if(params.count == 0){
            return
        }
        let postString = "user_id=\(userId)&" + params[0]
        //        print(param)
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        URLSession.shared.dataTask(with: request){data, response,error in
            if let data = data {
                do {
                    DispatchQueue.main.async {
                        if(params.count == 1){
                            print("updating")
                            self.home = try! JSONDecoder().decode(Home.self, from: data)
                            self.devices = self.home.devices
                            self.scenes = self.home.scenes
                            self.rooms = self.home.rooms
                            self.automatizations = self.home.automatizations

                            self.findAndActivateScene()
                        }
                        if(params.count>0){
                            print(params.count)
                            var params2 = params
                            params2.removeFirst()
                            
                            self.genericRecBackendUpdate(params: params2)
                        }
//                        print(self.home)
                    }
                }
            }
            else{
                print(error!)
            }
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
        }.resume()
    }
    
    func updateBackendDevice(device : Device){
        let param = "device_idk=update"
            + "&device_id=\(device.id)"
            + "&device_module=\(device.module_id ?? 1)"
            + "&device_name=\(device.device_name)"
            + "&device_value=\(device.value)"
            + "&device_type=\(device.type)"
            + "&device_glyph=\(device.glyph)"
            + "&device_is_active=\(device.is_active)"
            + "&device_room=\(device.room)"
        
        genericBackendUpdate(param: param)
    }
    
    func createBackendDevice(function : NewFunction,device: Device,restParam: String){
        let param = "device_idk=create"
            + "&ir_device_id=\(function.id)"
            + "&device_name=\(function.functionName)"
            + "&device_module=\(device.module_id ?? 1)"
            + "&device_value=0.0"
            + "&device_type=\(device.type)"
            + "&device_device=\(device.device ?? "")"
            + "&device_glyph=\(device.glyph)"
            + "&device_is_active=\(device.is_active)"
            + "&device_max_value=\(device.max_level ?? 1)" //TODO: set max value.
            + "&device_room=\(device.room)"
            + "&device_resetable=\(device.reseting)"
            + restParam
        print(param)
        genericBackendUpdate(param: param)
    }
    
    func deleteBackendDevice(device: Device){
        let param = "device_idk=delete"
            + "&device_id=\(device.id)"
        
        genericBackendUpdate(param: param)
    }
    
    func deleteDevice(device: Device){
        if let indx = devices.firstIndex(where: {$0.id == device.id}){
            devices.remove(at: indx)
        }
    }
    
    func removeDevicesFromScene(device: Device){
        for scene in scenes {
            if let indsx = scenes.firstIndex(where: {$0.id == scene.id}){
                //                            for sceneDevice in scene.devices{
                if let indx = scene.devices.firstIndex(where: {$0.id == device.id}){
                    //                scene.devices.remove(at: indx)
                    print("removing device: \(self.scenes[indsx].devices[indx].device_name)")
                    self.scenes[indsx].devices.remove(at:indx)
                    updateBackendScene(scenex: scenes[indsx])
                }
                //                            }
            }
        }
    }
    
    func removeDevicesFromAutomatization(device: Device){
        for automatization in automatizations {
            if let indsx = automatizations.firstIndex(where: {$0.id == automatization.id}){
                if let indx = automatization.devices.firstIndex(where: {$0.id == device.id}){
                    print("removing device: \(self.automatizations[indsx].devices[indx].device_name)")
                    self.automatizations[indsx].devices.remove(at:indx)
                    updateBackendAutomatization(automatizationx: automatizations[indsx])
                }
            }
        }
    }
    
    func updateBackendScene(scenex : Scene){
        if let indsx = scenes.firstIndex(where: {$0.id == scenex.id}){
            let scene = self.scenes[indsx]
            let encoder = JSONEncoder()
            let scene_devices = try! encoder.encode(scene.devices)
            let param = "scene_idk=update"
                + "&scene_id=\(scene.id)"
                + "&scene_name=\(scene.scene_name)"
                + "&scene_is_favorite=\(scene.is_favorite)"
                + "&scene_glyph=\(scene.glyph)"
                + "&scene_devices=\(String(data: scene_devices, encoding: .utf8)!)"
            genericBackendUpdate(param: param)
        }
        
    }
    
    func deleteBackendScene(scene : Scene){
        let param = "scene_idk=delete"
            + "&scene_id=\(scene.id)"
        
        genericBackendUpdate(param: param)
    }
    
    func createBackendScene(scene : Scene){
        let encoder = JSONEncoder()
        let scene_devices = try! encoder.encode(scene.devices)
        let param = "scene_idk=create"
            + "&scene_id=\(scene.id)"
            + "&scene_name=\(scene.scene_name)"
            + "&scene_is_favorite=\(scene.is_favorite)"
            + "&scene_glyph=\(scene.glyph)"
            + "&scene_is_active=\(scene.is_active)"
            + "&scene_devices=\(String(data: scene_devices, encoding: .utf8)!)"
        
        self.genericBackendUpdate(param: param)
    }
    
    func findAndActivateScene(){
        for scene in scenes {
            var toActivate = false
            for device in scene.devices{
                if let indx = devices.firstIndex(where: {$0.id == device.id}){
                    if(device.is_active == false
                        && devices[indx].is_active == device.is_active){
                        toActivate = true
                    }
                    else if(devices[indx].is_active == device.is_active
                                && devices[indx].value == device.value){
                        toActivate = true
                    }
                    else{
                        toActivate = false
                        break
                    }
                }
            }
            if let indx = scenes.firstIndex(where: {$0.id == scene.id}){
                scenes[indx].is_active = toActivate
            }
        }
    }
    
    func createAutomatization(automatization: Automatization){
        self.automatizations.append(automatization)
        print("createdScene: \(automatization.id)")
        for automatizationx in self.automatizations {
            print("\(automatizationx.id) x")
        }
    }
    
    func updateAutomatization(automatization: Automatization){
        if let indx = automatizations.firstIndex(where: {$0.id == automatization.id}){
            automatizations[indx] = automatization
        }
    }
    
    func getDevicesInAutomatization(automatization: Automatization)->[TestData]{
        //        print(scene)
        var returnData : [TestData] = []
        var devicesAssignedToRoom : [Device] = []
        for roomx in self.rooms
        {
            devicesAssignedToRoom = []
            for devicex in devices where devicex.room == roomx.id {
                if let indxAu = automatizations.firstIndex(where: {$0.id == automatization.id}){
                    if let _ =  automatizations[indxAu].devices.firstIndex(where: {$0.id == devicex.id}){
                        devicesAssignedToRoom.append(devicex)
                    }}
            }
            if(devicesAssignedToRoom.count != 0){
                returnData.append(TestData(id: roomx.id, roomName: roomx.room_name,devices: devicesAssignedToRoom))
            }
        }
        return returnData
    }
    
    func getDevicesInAutomatizationArray(automatization: Automatization)->[Device]{
        if let indxSc = automatizations.firstIndex(where: {$0.id == automatization.id}){
            return automatizations[indxSc].devices
        }
        else{
            return []
        }
    }
    func addOrRemoveDeviceToAutomatization(automatization: Automatization, device: Device) -> Automatization{
        if let indxAu = automatizations.firstIndex(where: {$0.id == automatization.id}){
            if let indxDv =  automatizations[indxAu].devices.firstIndex(where: {$0.id == device.id}){
                automatizations[indxAu].devices.remove(at: indxDv)
            }
            else{
                automatizations[indxAu].devices.append(device)
                automatizations[indxAu].devices.sort(by: {$0.reseting && !$1.reseting})
                automatizations[indxAu].devices.sort(by: {$0.device ?? "" > $1.device ?? "" })
                print(automatizations[indxAu].devices)
            }
            if(automatization.id != 0){
                print(automatizations[indxAu])
                updateBackendAutomatization(automatizationx: automatizations[indxAu])
            }
            return automatizations[indxAu]
        }
        else{
            return automatization
        }
    }
    
    func isDeviceInAutomatization(automatization: Automatization, device:Device)->Bool{
        if let indxAu = automatizations.firstIndex(where: {$0.id == automatization.id}){
            if let _ =  automatizations[indxAu].devices.firstIndex(where: {$0.id == device.id}){
                return true
            }
            else{
                return false
            }
        }
        else{
//            for automatizationx in self.automatizations {
//                print("\(automatizationx.id) x")
//            }
            print("something wrong")
            return false
        }
    }
    func modifyDeviceInAutomatization(automatization:Automatization, device:Device)->[Int]{
        if let indxAu = automatizations.firstIndex(where: {$0.id == automatization.id}){
            if let indxDv = automatizations[indxAu].devices.firstIndex(where: {$0.id == device.id}){
                return [indxAu,indxDv]
            }
        }
        return [0,0]
    }
    
    func updateDeviceInAutomatization(automatization:Automatization, device: Device){
        if let indxAu = automatizations.firstIndex(where: {$0.id == automatization.id}){
            if let indxDv = automatizations[indxAu].devices.firstIndex(where: {$0.id == device.id}){
                automatizations[indxAu].devices[indxDv] = device
            }
        }
    }
    
    func updateBackendDeviceInAutomatization(automatization: Automatization){
        if let indxAu = automatizations.firstIndex(where: {$0.id == automatization.id}){
            updateBackendAutomatization(automatizationx: automatizations[indxAu])
        }
    }
    
    func createBackendAutomatization(automatization : Automatization){
        let encoder = JSONEncoder()
        let aut_devices = try! encoder.encode(automatization.devices)
        let aut_scenes = try! encoder.encode(automatization.scenes)
        let aut_days = try! encoder.encode(automatization.days)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        
        var param = "automatization_idk=create"
            + "&automatization_id=\(automatization.id)"
            + "&automatization_devices=\(String(data: aut_devices, encoding: .utf8)!)"
            + "&automatization_scenes=\(String(data: aut_scenes, encoding: .utf8)!)"
        if(automatization.time != nil){
            param += "&automatization_time=\(automatization.time ?? "null")"
            + "&automatization_days=\(String(data: aut_days, encoding: .utf8)!)"
        }
        else{
            param += "&automatization_value=\(automatization.sensor_value!)"
                + "&automatization_condition=\(automatization.sensor_condition!)"
                + "&automatization_sensor=\((automatization.sensor_id)!)"
        }
        self.genericBackendUpdate(param: param)
    }
    
    func deleteBackendAutomatization(automatization : Automatization){
        let param = "automatization_idk=delete"
            + "&automatization_id=\(automatization.id)"
        self.genericBackendUpdate(param: param)
    }
    
    func updateBackendAutomatization(automatizationx : Automatization){
        if let indaux = automatizations.firstIndex(where: {$0.id == automatizationx.id}){
            let automatization = self.automatizations[indaux]
            let encoder = JSONEncoder()
            let aut_devices = try! encoder.encode(automatization.devices)
            let aut_scenes = try! encoder.encode(automatization.scenes)
            let aut_days = try! encoder.encode(automatization.days)
            
            var param = "automatization_idk=update"
                + "&automatization_id=\(automatization.id)"
                + "&automatization_devices=\(String(data: aut_devices, encoding: .utf8)!)"
                + "&automatization_scenes=\(String(data: aut_scenes, encoding: .utf8)!)"
            if(automatization.time != nil){
                param += "&automatization_time=\(automatization.time ?? "null")"
                + "&automatization_days=\(String(data: aut_days, encoding: .utf8)!)"
            }
            else{
                param += "&automatization_value=\(automatization.sensor_value!)"
                    + "&automatization_condition=\(automatization.sensor_condition!)"
                    + "&automatization_sensor=\((automatization.sensor_id)!)"
            }
            
            genericBackendUpdate(param: param)
        }
        
    }
    
    func getSensor(id: Int) -> Device?{
        if let indDv = devices.firstIndex(where: {$0.id == id}){
            return devices[indDv]
        }
        else{
            return nil
        }
    }
    
    func validateAutomatizations(){
        automatizations.removeAll(where: {$0.id == 0})
    }

}
