//
//  DevicesView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 03/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct DevicesView: View {
    var body: some View {
          ZStack {
            RoundedRectangle(cornerRadius:20, style: .continuous)
                .fill(Color(UIColor.init(named:"mainColor") ?? UIColor.gray))
                .opacity(0.7)
                .frame(width: 120, height: 120)
            
            VStack(alignment: .leading){
                
                Image(systemName: "square.and.pencil").foregroundColor(Color(UIColor.systemGray2)).padding(.leading, -8.0).font(.system(size:30, weight: .bold))

                Text("Accessory_name")
                    .fontWeight(.medium)
                    .foregroundColor(Color(UIColor.systemGray6))
                    .font(.system(size:17))
                    .multilineTextAlignment(.leading)
                    .padding(.leading, -10.0)
                
                Text("Accessory_name")
                    .fontWeight(.medium)
                    .foregroundColor(Color(UIColor.systemGray6))
                    .font(.system(size:17))
                    .multilineTextAlignment(.leading)
                    .padding(.leading, -10.0)
                
                Text("Vyp.")
                    .fontWeight(.regular)
                    .foregroundColor(Color(UIColor.systemGray6))
                    .font(.system(size:16))
                    .multilineTextAlignment(.leading)
                    .padding(.leading, -10.0)
                
            }
            .padding()
            .frame(width: 120,height: 120)
        }
    }
}

struct DeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
