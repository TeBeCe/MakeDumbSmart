//
//  DeviceModel.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 03/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import Foundation


struct Device: Identifiable, Decodable{
    let id = UUID()
    let uid: Int
    let name: String
    let avatar: String
    let functions: [String]
}
