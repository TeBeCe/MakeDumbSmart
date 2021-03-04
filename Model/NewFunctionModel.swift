//
//  NewDeviceFunction.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 26/02/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import Foundation

struct NewFunction : Decodable,Identifiable {
    let id : Int
    var vendor : String?
    var deviceRealName : String?
    var functionName : String
    var rawData : String
    var rawDataLen : String
    
}

class LoadJSONNewFunctionData : ObservableObject {
    var loading = true
    var param : String = ""
    @Published var data = [NewFunction]()
    
    func loadData(param: String) {
        guard let urlx = URL(string: "https://divine-languages.000webhostapp.com/get_new_devices.php") else { return }
        
        var request = URLRequest(url: urlx)
        request.httpMethod = "POST"
        print(param)
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = param
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        URLSession.shared.dataTask(with: request){data, response,error in
            if let data = data {
                do {
                    DispatchQueue.main.async {
                        self.data = try! JSONDecoder().decode([NewFunction].self, from: data)
                        self.loading = false
                    }
                }
            }
            else{
                print(error!)
            }
        }.resume()
    }
    func genericBackendUpdate(param : String){
        // Prepare URL
        let url = URL(string: "https://divine-languages.000webhostapp.com/get_new_devices.php")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
//        let postString = "home_id=1&home_name=" + self.home.home_name;
        let postString = param
//        print(param)
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
    func nameAndCreateFunction(newFunction: NewFunction){
        let param = "id=\(newFunction.id)" +
            "&vendor=\(newFunction.vendor ?? "")" +
            "&device_real_name=\(newFunction.deviceRealName ?? "")" +
            "&function_name=\(newFunction.functionName)"
        
        self.genericBackendUpdate(param: param)
    }
}

