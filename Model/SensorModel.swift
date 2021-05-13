//
//  SensorModel.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 25/01/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct Point : Decodable {
    let timestamp: String
    let y: CGFloat
}

class LoadJSONSensorData : ObservableObject {
    var param : String = ""
    @Published var data = [Point]()
    @AppStorage("logged_user_id") var userId = 0
    
    func loadData(param: String) {
//        guard let urlx = URL(string: "https://divine-languages.000webhostapp.com/get_sensors.php") else { return }
        guard let urlx = URL(string: "https://divine-languages.000webhostapp.com/public/index.php/sensors/" + String(userId) + param) else { return }

        var request = URLRequest(url: urlx)
        request.httpMethod = "GET"
        print(param)
        // HTTP Request Parameters which will be sent in HTTP Request Body
//        let postString = param
        // Set HTTP Request Body
//        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        URLSession.shared.dataTask(with: request){data, response,error in
            if let data = data {
                do {
                    DispatchQueue.main.async {
                        self.data = try! JSONDecoder().decode([Point].self, from: data)

                    }
                }
            }
//            if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                print("Response data string:\n \(dataString)")
//            }
//            else{
//                print(error!)
//            }
        }.resume()
    }
}

