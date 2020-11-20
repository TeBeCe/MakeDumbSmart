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
}


