//
//  SensorChartView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 22/01/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct LineGraph : Shape {
    
    var data = [CGFloat(24.5),
                CGFloat(24.7),
                CGFloat(25.2),
                CGFloat(24.6),
                CGFloat(24.3),
                CGFloat(23.5),
                CGFloat(24.5)].normalized
    
    func path(in rect: CGRect) -> Path {
        func point (at ix: Int) -> CGPoint{
            
            let point = data[ix]
            let x = rect.width * CGFloat(ix) / CGFloat(data.count - 1)
            let y = (1 - point) * rect.height
            
            return CGPoint(x:x, y:y)
        }
        
        return Path { p in
            guard data.count > 1 else {return}
            let start = data[0]
            p.move(to: CGPoint(x:0,y: (1 - start) * rect.height))
            
            var previousPoint = CGPoint(x: 0, y: (1 - start) * rect.height)
            
            for idx in data.indices {
//                p.addLine(to: point(at: idx))
                let deltaX = point(at: idx).x - previousPoint.x
                let curveXOffset = deltaX * 1

                p.addCurve(to: point(at: idx),
                           control1: CGPoint(x: previousPoint.x + curveXOffset, y: previousPoint.y),
                           control2: CGPoint(x:point(at: idx).x - curveXOffset, y:point(at: idx).y))
                previousPoint = point(at: idx)
            }
        }
    }
}

struct SensorChartView: View {
    @State var animateChart = false
    @ObservedObject var sensorObj = LoadJSONSensorData()
    @State var device : Device
    var body: some View {
        VStack(alignment: .leading){
        Text(device.device_name)
//        Text(device.value)
//        LineGraph(data: sensorObj.data.normalized)
//            .trim(to: animateChart ? 1 : 0)
//            .stroke(device.type == "sensor_temperature" ? Color.red : Color.blue, lineWidth: 2.0)
////            .stroke(lineWidth: 3)
//            .frame(width: 400, height: 300)
//            .border(Color.black)
//            .onAppear(perform: {
//                withAnimation(.easeInOut(duration: 2.0)){
//                    animateChart = true
//                }
//                sensorObj.loadData(param: "device_id=1" +
//                                   "&sensor_type=\(device.type == "sensor_temperature" ? "temp":"humid")")
//            })
        }
        
    }
}

struct SensorChartView_Previews: PreviewProvider {
    static var previews: some View {
        SensorChartView(device: Device(id: 0, device_name: "xxx", device_custom_name: nil, reseting: false, glyph: nil, is_active: false, type: "sensor_temp", value: 24.0, max_level: 100, room: 1))
    }
}
