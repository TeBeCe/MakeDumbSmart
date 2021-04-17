//
//  LoginManagmenViewModel.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 24/03/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import Foundation
import SwiftUI

struct User: Decodable{
    var user_id : Int?
    var createdHome: Bool?
    var error: String?
}

class loadLoginJSONData: ObservableObject{
    @AppStorage("logged_status") var loggedIn = false
    @AppStorage("logged_user_id") var userId = 0
    @AppStorage("first_run_done") var firstRunDone = false
    @AppStorage("register") var register = false
    
    @Published var errorMsg: String = ""
    @Published var loggedUser: User = User(user_id: 0)
    
    func loadLoginData(mail: String, password: String){
        let url = URL(string: "https://divine-languages.000webhostapp.com/login.php")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "operation_type=login&user_name=\(mail)&user_pwd=\(password)"
        print(postString)
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        URLSession.shared.dataTask(with: request){data, response,error in
            if let data = data {
                do {
                    DispatchQueue.main.async {
                        self.loggedUser = try! JSONDecoder().decode(User.self, from: data)
                        
//                        let dataString = String(data: data, encoding: .utf8)
//                        print("Response data string:\n \(dataString ?? "error")")
                        print(self.loggedUser)
                        if(self.loggedUser.user_id != nil && self.loggedUser.error == nil){
                            self.loggedIn = true
                            self.userId = self.loggedUser.user_id ?? 0
                            self.firstRunDone = self.loggedUser.createdHome ?? false
                        }
                        else{
                            self.errorMsg = self.loggedUser.error ?? ""
                        }
                        
                        
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
    }
    
    func registerData(mail: String, password: String){
        let url = URL(string: "https://divine-languages.000webhostapp.com/login.php")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "operation_type=register&user_name=\(mail)&user_pwd=\(password)"
        print(postString)
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        URLSession.shared.dataTask(with: request){data, response,error in
            if let data = data {
                do {
                    DispatchQueue.main.async {
                        self.loggedUser = try! JSONDecoder().decode(User.self, from: data)
                        
//                        let dataString = String(data: data, encoding: .utf8)
//                        print("Response data string:\n \(dataString ?? "error")")
                        print("loggedIn")
                        print(self.loggedUser)
                        if(self.loggedUser.user_id != nil && self.loggedUser.error == nil){
                            self.loggedIn = true
                            self.userId = self.loggedUser.user_id ?? 0
                            self.firstRunDone = self.loggedUser.createdHome ?? false
                        }
                        else{
                            self.errorMsg = self.loggedUser.error ?? ""
                        }
                        
                        
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
    }
    
    func loadfirstRunData(newHome: NewHome){
        let encoder = JSONEncoder()
        let modules = try! encoder.encode(newHome.modules)
        let sensors = try! encoder.encode(newHome.sensors)
        let param = "user_id=\(userId)" +
                    "&operation_type=create" +
                    "&home_name=\(newHome.homeName)" +
                    "&def_room=\(newHome.roomName)" +
                    "&modules=\(String(data: modules, encoding: .utf8)!)" +
                    "&sensors=\(String(data: sensors, encoding: .utf8)!)"
        
        let url = URL(string: "https://divine-languages.000webhostapp.com/login.php")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = param
        print(postString)
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        URLSession.shared.dataTask(with: request){data, response,error in
            if let data = data {
                do {
                    DispatchQueue.main.async {
                        let dataString = String(data: data, encoding: .utf8)
                        print("Response data string:\n \(dataString ?? "error")")
                        self.loggedUser = try! JSONDecoder().decode(User.self, from: data)
                        
                        
//                        print("loggedIn")
//                        print(self.loggedUser)
                        if(self.loggedUser.user_id != nil && self.loggedUser.error == nil){
                            self.firstRunDone = self.loggedUser.createdHome ?? false
                            self.loggedIn = true
                            self.userId = self.loggedUser.user_id ?? 0
                        }
                        else{
                            self.errorMsg = self.loggedUser.error ?? ""
                        }
                        
                        
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
    }
}
