//
//  RegisterView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 27/03/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var loginMng = loadLoginJSONData()

    @AppStorage("register") var register = false
    
    @State var userName:String = ""
    @State var userPwd:String = ""
    @State var userPwdRep:String = ""

    var body: some View {
        VStack(alignment: .center, spacing: 15.0){
            Image("Icon").resizable()
                .frame(width: 200, height: 200)
            Text("MakeDumbSmart")
                .font(.system(size:30))
                .fontWeight(.semibold)
            HStack{
                Image(systemName: "person")
                TextField("Name", text: $userName)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(.all,10)
            .border(Color(UIColor.init(named:"textColor")!))
            
            HStack{
                Image(systemName: "key")
                SecureField("Password", text: $userPwd)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.username)
            }
            .padding(.all,10)
            .border(Color(UIColor.init(named:"textColor")!))
            
            HStack{
                Image(systemName: "key.fill").foregroundColor(userPwdRep != userPwd || userPwdRep.count < 4 || userName.count < 4 ? .red : .green)
                SecureField("Repeat password", text: $userPwdRep)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.username)

            }
            .padding(.all,10)
            .border(Color(UIColor.init(named:"textColor")!))
            if(loginMng.errorMsg != ""){
                Text(loginMng.errorMsg)
            }
            Button(action: {
                loginMng.registerData(mail: userName, password: userPwd)
            }) {
                HStack{
                    Spacer()
                    Image(systemName: "arrow.forward")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold))
                    Text("Register")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Spacer()
                }
            }
            .padding(.all, 10)
            .border(Color.blue)
            .background(Color.blue)
            .cornerRadius(15)
            .disabled(userPwd != userPwdRep || userPwd.count < 4)
            .opacity(userPwd != userPwdRep || userPwd.count < 4 ? 0.6 : 1)
            
            Button(action: {
                register = false
            }) {
                HStack{
                    Image(systemName: "arrow.uturn.backward")
                    Text("Back to login")
                }
            }
        }.padding(.horizontal,40)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
