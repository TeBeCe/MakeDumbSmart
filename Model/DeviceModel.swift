//
//  DeviceModel.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 03/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import Foundation

struct Home: Codable {
    let home_name: String
    let id: Int
    let devices: [Device]?
}
struct Device:  Codable, Identifiable {
    let id: Int
    let device_name: String
    let device_custom_name: String?
    let glyph : String?
//    let functions: Functions?
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
struct Scene: Codable,Identifiable {
    let scene_name: String
    let id: Int
    let favorite: Bool
    let glyph: String
}

class LoadJSONData : ObservableObject {
    
    @Published var home = Home(home_name: "", id: 0, devices: nil)
    @Published var devices = [Device]()
    
    func loadData() {
        //        let jsonUrlString = "https://my.api.mockaroo.com/test_dp.json?key=96614480"
        //        let jsonUrlString = "https://my.api.mockaroo.com/test_dp_3.json?key=c7a70460"
        
        guard let urlx = URL(string: "https://my.api.mockaroo.com/test_dp_3.json?key=c7a70460") else { return }
        
        let request = URLRequest(url: urlx)
        
        URLSession.shared.dataTask(with: request){data, response,error in
            //                if let data = data {
            //                print(response)
            
            //                {
            DispatchQueue.main.async {
                print(data!)
                self.home = try! JSONDecoder().decode(Home.self, from: data!)
                self.devices = self.home.devices ?? [Device(id: 0, device_name: "def",device_custom_name: "def_cust",glyph: "def_glyph")]
                print(self.home)
            }
            //                    }
            //                    else{
            //                        print(error)
            //                    }
            //                }
        }.resume()
    }
    //    func CalculateRows(){
    //    //    var array : [Int] = [1,2,3,4,5,6,7,8,9,10]
    //        var row: [Device] = []
    ////        var rows: [[Device]] = [[]]
    //        for item in self.dvc {
    //            row.append(item)
    //            if(row.count == 3){
    //                self.arrayDvc.append(row)
    //                row.removeAll()
    //            }
    //        }
    //    }
    
}


