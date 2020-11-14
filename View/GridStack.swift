//
//  GridStack.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 04/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

func CalculateRows(array: [Device])->[[Device]]{
//    var array : [Int] = [1,2,3,4,5,6,7,8,9,10]
    var row: [Device] = []
    var rows: [[Device]] = [[]]
    for item in array {
        row.append(item)
        if(row.count == 3){
            rows.append(row)
            row.removeAll()
        }
    }
    return rows
}

struct GridStack: View {
    var rows : [[Device]]
//    let rows: [[Int]] = [[1,2,3],[1,2,3],[1]] //CalculateRows()
//    var rows =  CalculateRows(array: [1,2,3,4,5,6,7,8,9,10])
    

    //    var rows: Int = 0
    
    var body: some View {
        VStack(alignment: .leading){
            ForEach(0..<self.rows.count){i in
                HStack(){
                    ForEach(0..<self.rows[i].count){x in
                        //            print(x)
                        DevicesView(device: Device(id: 1, device_name: "test",device_custom_name: "",glyph: ""))
                    }
                }
            }
        }
    }
}

struct GridStack_Previews: PreviewProvider {
    static var previews: some View {
        GridStack(rows: [[Device(id: 1, device_name: "test",device_custom_name: "cust_name",glyph: "")]])
    }
}
