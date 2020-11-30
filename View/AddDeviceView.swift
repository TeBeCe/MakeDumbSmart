//
//  AddDeviceView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 28/11/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct AddDeviceView: View {
    @Binding var activeSheet: ActiveSheet?
    var body: some View {
        Button(action: {activeSheet = nil}, label: {
            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
        })
    }
}

struct AddDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        AddDeviceView(activeSheet: .constant(nil))
    }
}
