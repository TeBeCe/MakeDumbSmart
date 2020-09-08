//
//  GridStack.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 04/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

func CalculateRows()->[[Int]]{
    let array = [1,2,3,4,5,6,7,8,9,10]
    var row: [Int] = []
    //    var index = 1
    var rows: [[Int]] = [[]]
    for item in array {
        row.append(item)
        if(rows.count == 3){
            rows.append(row)
            row.removeAll()
        }
    }
    return rows
}

//struct RowsStack: View {
//
//    let arrays: [[Int]]
//    var rows: Int = 0
//
//    var body: some View {
//        ForEach(0..<3){x in
//            Text("\(x)")
//        }
//
//    }
//}

struct GridStack: View {
    let rows: [[Int]] = [[1,2,3],[1,2,3],[1]] //CalculateRows()
//    let rows: [[Int]] = [[1,2,3],] //CalculateRows()

    //    var rows: Int = 0
    
    var body: some View {
        VStack(alignment: .leading){
            ForEach(0..<self.rows.count){i in
                HStack(){
                    ForEach(0..<self.rows[i].count){x in
                        //            print(x)
                        DevicesView()
                    }
                }
            }
        }
    }
}

struct GridStack_Previews: PreviewProvider {
    static var previews: some View {
        GridStack()
    }
}
