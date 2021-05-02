//
//  LoginView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 23/03/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginMng = loadLoginJSONData()
    @AppStorage("logged_status") var validated = false
    @AppStorage("register") var register = false
    @State var userMail = ""
    @State var password = ""
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 15){
                Image("Icon").resizable()
                    .frame(width: 200, height: 200)
                Text("MakeDumbSmart")
                    .font(.system(size:30))
                    .fontWeight(.semibold)
                HStack{
                    Image(systemName: "person")
                    TextField("Email", text: $userMail)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                }
                .padding(.all,10)
                .border(Color(UIColor.init(named:"textColor")!))
                
                HStack{
                    Image(systemName: "key")
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                }
                .padding(.all,10)
                .border(Color(UIColor.init(named:"textColor")!))
                if(loginMng.errorMsg != ""){
                    Text(loginMng.errorMsg)
                }
                Button(action: {
                    loginMng.loadLoginData(mail: userMail, password: password)
                }){
                    HStack{
                        Spacer()
                        Image(systemName: "arrow.forward")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                        Text("LogIn")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Spacer()
                        
                    }
                }.padding(.all, 10)
                .border(Color.blue)
                .background(Color.blue)
                .cornerRadius(15)
                .disabled(userMail.count < 4 || password.count < 4)
                .opacity(userMail.count < 4 || password.count < 4 ? 0.6 : 1)
                Button(action: {
                    register = true
                }){
                    HStack{
                        Image(systemName: "person.badge.plus")
                        Text("Register")
                    }
                }
            }.padding(.horizontal, 40)
            .alert(isPresented: $loginMng.presentAlert) {
                Alert(title: Text("Login Error"), message: Text(LocalizedStringKey(loginMng.errorMsg)))
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
