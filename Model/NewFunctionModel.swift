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

//struct SimilarNewFunction : Identifiable, Decodable {
//    let id: Int
//    var vendor : String
//    var deviceRealName : String
//    var groupedSimilarFunctions: [NewFunction]?
//}

struct SimilarNewFunction: Identifiable, Decodable {
    let id : Int
    var vendor : String
    var deviceRealName : String
    var functionName : String
    var rawData : String?
    var rawDataLen : String?
    var similarIRDevices: [SimilarNewFunction]?
}

struct OtherNewFunction: Identifiable, Decodable {
    let id : Int
    var vendor : String
    var deviceRealName : String
    var functionName : String
    var rawData : String?
    var rawDataLen : String?
    var otherIRDevices: [OtherNewFunction]?
}

struct NewIRFunctions : Decodable{
    var myIRDevices : [NewFunction]
    var similarIRDevices : [SimilarNewFunction]
    var otherIRDevices : [OtherNewFunction]
}

class LoadJSONNewFunctionData : ObservableObject {
    var loading = true
    var param : String = ""
    @Published var newFunctions = NewIRFunctions(myIRDevices:[],similarIRDevices:[], otherIRDevices: [])
    @Published var myIRDevices = [NewFunction]()
    @Published var similarIRDevices = [SimilarNewFunction]()
    @Published var otherIRDevices = [OtherNewFunction]()
    
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
                        self.newFunctions = try! JSONDecoder().decode(NewIRFunctions.self, from: data)
                        self.myIRDevices = self.newFunctions.myIRDevices
                        self.similarIRDevices = self.newFunctions.similarIRDevices
                        self.otherIRDevices = self.newFunctions.otherIRDevices
                        self.loading = false
//                        print(self.similarIRDevices)
                    }
                }
            }
            else{
                print(error!)
            }
        }.resume()
    }
    func genericBackendUpdate(method: String = "POST",link: String = "" ,param : String){
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
    func nameAndCreateMyFunction(newFunction: NewFunction){
        let param = "creation_type=own" +
            "&id=\(newFunction.id)" +
            "&vendor=\(newFunction.vendor ?? "")" +
            "&device_real_name=\(newFunction.deviceRealName ?? "")" +
            "&function_name=\(newFunction.functionName)"
        
        self.genericBackendUpdate(param: param)
    }
    func nameAndCreateSimilarFunction(similarNewFunction: SimilarNewFunction, device: Device){
        let param = "creation_type=similar" +
            "&vendor=\(similarNewFunction.vendor )" +
            "&device_real_name=\(similarNewFunction.deviceRealName )" +
            "&function_name=\(device.device_name)" +
            "&function_data_len=\(similarNewFunction.rawDataLen ?? "")" +
            "&function_raw_data=\(similarNewFunction.rawData ?? "")"
            + "&function_value=0.0"
            + "&function_module=\(device.module_id ?? 1)"
            + "&function_type=\(device.type)"
            + "&function_device=\(similarNewFunction.deviceRealName)"
            + "&function_glyph=\(device.glyph )"
            + "&function_is_active=\(device.is_active)"
            + "&function_max_value=\(device.max_level ?? 1)" //TODO: set max value.
            + "&function_room=\(device.room )"
            + "&function_resetable=\(device.reseting)"
        print(param)
        self.genericBackendUpdate(param: param)
    }
    func nameAndCreateOtherFunction(otherNewFunction: OtherNewFunction, device: Device){
        let param = "creation_type=similar" +
            "&vendor=\(otherNewFunction.vendor )" +
            "&device_real_name=\(otherNewFunction.deviceRealName )" +
            "&function_name=\(device.device_name)" +
            "&function_data_len=\(otherNewFunction.rawDataLen ?? "")" +
            "&function_raw_data=\(otherNewFunction.rawData ?? "")"
            + "&function_value=0.0"
            + "&function_module=\(device.module_id ?? 1)"
            + "&function_type=\(device.type)"
            + "&function_device=\(otherNewFunction.deviceRealName)"
            + "&function_glyph=\(device.glyph )"
            + "&function_is_active=\(device.is_active)"
            + "&function_max_value=\(device.max_level ?? 1)" //TODO: set max value.
            + "&function_room=\(device.room )"
            + "&function_resetable=\(device.reseting)"
        print(param)
        self.genericBackendUpdate(param: param)
    }
}

