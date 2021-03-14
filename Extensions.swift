//
//  Extensions.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 27/01/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

extension Text {
    func valueLabel()  -> some View {
        self
            .fontWeight(.semibold)
            .foregroundColor(Color(.systemGray))
            .font(.system(size:15))
            .multilineTextAlignment(.leading)
    }
    func roomLabel() -> some View {
        self
            .fontWeight(.regular)
            .font(.system(size:16))
            .multilineTextAlignment(.leading)
        
    }
}

extension Array where Element == CGFloat{
    var normalized: [CGFloat] {
        if let min = self.min(), let max = self.max(){
            return self.map{ ($0 - min) / (max-min) }
            
        }
        return []
    }
}

//extension Device: Equatable {
//    static func == (lhs: Device, rhs: Device) -> Bool {
//        return lhs.id == rhs.id && lhs.subRank == rhs.subRank && lhs.name == rhs.name
//    }
//}
