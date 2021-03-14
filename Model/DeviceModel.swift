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
    let device: String?
    var reseting: Bool
    let glyph : String
    var is_active: Bool
    let type: String
    var value: Float
    let max_level: Int?
    var room: Int
    var processing:Int
    
}
struct Scene: Codable,Identifiable {
    var scene_name: String
    let id: Int
    var is_favorite: Bool
    var glyph: String
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
//    @Published var isWaitingForResponse = false
    var continueRefresh = true
    
    func loadData() {
        //        guard let urlx = URL(string: "https://my.api.mockaroo.com/test_dp_3.json?key=c7a70460") else { return }
        guard let urlx = URL(string: "https://divine-languages.000webhostapp.com/to_mobile.php") else { return }
        
        let request = URLRequest(url: urlx)
        
        URLSession.shared.dataTask(with: request){data, response,error in
            if let data = data {
                do {
                    DispatchQueue.main.async {
                        //print(data)
                        self.home = try! JSONDecoder().decode(Home.self, from: data)
                        self.devices = self.home.devices
                        self.scenes = self.home.scenes
                        self.rooms = self.home.rooms
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
                print(error!)
            }
        }.resume()
        DispatchQueue.main.asyncAfter(deadline: .now()+15.0){[self] in
            if(continueRefresh){
                self.loadData()
            }
//            print("fetching")
        }
    }
    
    func updateDevice(device: Device){
        if let indx = devices.firstIndex(where: {$0.id == device.id}){
            devices[indx] = device
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
    
    func getRoomName(index: Int)->String {
        if let idx = self.rooms.firstIndex(where: {$0.id == index}){
            return self.rooms[idx].room_name
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
        case "sensor_temperature":
            return "\(String(device.value))°"
        case "sensor_humidity":
            return "\(String(format: "%.0f%", device.value))%"
            
        default:
            return "Unknown device type/state"
        }
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
                            multiplier = Int(xDevice.max_level ?? 1) - actual + Int(xDevice.value)
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
    
    func activateBackendDevice(device: Device,multiplier: Int){
        let param = "device_idk=activate"
            + "&device_id=\(device.id)"
            + "&device_name=\(device.device_name)"
            + "&device_value=\(device.value)"
            + "&device_type=\(device.type)"
            + "&device_glyph=\(device.glyph)"
            + "&device_is_active=\(device.is_active)"
            + "&device_room=\(device.room)"
            + "&device_repeat=\(multiplier)"
        print(param)
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
    
    func backendUpdateHome(param : String){
        // Prepare URL
        let url = URL(string: "https://divine-languages.000webhostapp.com/to_mobile.php")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = param
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
        }
        task.resume()
    }
    
    func genericBackendUpdate(param : String){
        // Prepare URL
        let url = URL(string: "https://divine-languages.000webhostapp.com/to_mobile.php")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        //        let postString = "home_id=1&home_name=" + self.home.home_name;
        let postString = param
                print(param)
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
        URLSession.shared.dataTask(with: request){data, response,error in
            if let data = data {
                do {
                    DispatchQueue.main.async {
                        self.home = try! JSONDecoder().decode(Home.self, from: data)
                        self.devices = self.home.devices
                        self.scenes = self.home.scenes
                        self.rooms = self.home.rooms
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
        let postString = params[0]
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
}
