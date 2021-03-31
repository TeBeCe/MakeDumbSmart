//
//  CrossroadView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 23/03/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct CrossroadView: View {
//    @ObservedObject var loginMng = loadLoginJSONData()
    @State private var isUnlocked = false
    @AppStorage("register") var register = false

    @AppStorage("logged_status") var validated = false
    @AppStorage("use_biometrics") var useBiometrics = false
    @AppStorage("first_run_done") var firstRunDone = false

    var body: some View {
        if(validated){
            if(firstRunDone){
                if(isUnlocked){
                    ContentView()
                }
                else{
                    Text("unlock").onAppear(perform: {
                        authenticate()
                    })
                }
                
                //                if(!isUnlocked){
                //                    Image(systemName: "touchid")
                //
                //                }
                //                    ContentView().blur(radius: isUnlocked ? 0 : 10)
            }else{
                FirstRunView()
            }
        }
        else{
            if(!register){
                LoginView()
            }
            else{
                RegisterView()
            }
        }
    }
    
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "We need to unlock your data"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ success, authenticatuibError in
                DispatchQueue.main.async {
                    if success{
                        //authenticated succesfully
                        self.isUnlocked = true
                    }
                    else {
                        //there was a problem
                    }
                }
            }
        }else{
            //no biometrics
        }
    }
}

struct CrossroadView_Previews: PreviewProvider {
    static var previews: some View {
        CrossroadView()
//            .previewDevice("iPad Pro (12.9-inch) (4th generation)")

    }
}
