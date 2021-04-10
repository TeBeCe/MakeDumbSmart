//
//  SensorChartsView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 30/01/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI



let dataxx: [Point] = [
    //    .init(x: 0, y: 5),
    //    .init(x: 1, y: 4),
    //    .init(x: 2, y: 24),
    //    .init(x: 3, y: 6),
    //    .init(x: 4, y: 9),
    //    .init(x: 5, y: 12),
    //    .init(x: 6, y: 14),
    //    .init(x: 7, y: 11)
    .init(timestamp: "10", y: 5),
    .init(timestamp: "16", y: 4),
    .init(timestamp: "16", y: 24),
    .init(timestamp: "16", y: 6)
    
]

struct SensorChartsView: View {
    var data: [Point] = dataxx
    var lineRadius = 0.5
    @ObservedObject var sensorObj = LoadJSONSensorData()
    
    @State var device : Device
    @State var isPresentedLine: Bool = false
    @State var isPresentedClosedPath: Bool = false
    @State private var dragLocation:CGPoint = .zero
    @State private var indicatorLocation:CGPoint = .zero
    @State private var closestPoint: CGPoint = .zero
    @State private var currentDataNumber: CGFloat = 0
    @State private var showIndicator = false
    
    private var maxYValue: CGFloat {
        data.max { $0.y < $1.y }?.y ?? 0
    }
    
    //private var maxXValue: CGFloat {
    //    data.max { $0.x < $1.x }?.x ?? 0
    //}
    
    private var minYValue: CGFloat {
        data.min { $0.y < $1.y }?.y ?? 0
    }
    
    //private var minXValue: CGFloat {
    //    data.min { $0.x < $1.x }?.x ?? 0
    //}
    
    //private var xStepsCount: Int {
    //    return Int(self.maxXValue / self.xStepValue)
    //}
    
    private var yStepsCount: Int {
        let delta = self.maxYValue - self.minYValue
        if(delta < 1){
            return Int(delta / 0.1)
        }
        else if(delta < 2){
            return Int(delta / 0.2)
        }
        else if(delta < 5){
            return Int(delta / 0.5)
        }
        else if(delta < 10){
            return Int(delta / 1.0)
        }
        else if(delta < 20){
            return Int(delta / 2)
        }
        else if(delta < 50) {
            return Int(delta / 5)
        }
        else{
            return Int(delta / 10)
        }
    }
    
    var body: some View {
//        GeometryReader { geo in
        ZStack {
            if(data.count > 1){
                gridBody
                chartBody
                chartXLabel
                chartYLabel}
            if(showIndicator){
                Circle().position(self.closestPoint).frame(width: 10, height: 10)
                Text("\(String(format: "%.1f%", currentDataNumber))")
                    .position(CGPoint(x: 195 + self.closestPoint.x,
                                      y: (130 + self.closestPoint.y) > 125
                                        ? (130 + self.closestPoint.y - 25)
                                        : (130 + self.closestPoint.y + 5))
                    )
            }
            
        }
//        .frame(width: geo.size.width * 0.95,height: 250)
        .frame(width:400, height:250)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            
//        }
    }
    
    private var gridBody: some View {
        GeometryReader { geometry in
            Path { path in
                let xStepWidth = geometry.size.width / CGFloat(6)
                let yStepWidth = geometry.size.height / CGFloat(self.yStepsCount)
                print("xStepWidth: \(xStepWidth)")
                
                // Y axis lines
                (1...self.yStepsCount).forEach { index in
                    let y = CGFloat(index) * yStepWidth
                    path.move(to: .init(x: 0, y: y))
                    path.addLine(to: .init(x: geometry.size.width, y: y))
                }
                
                // X axis lines
                (1...6).forEach { index in
                    let x = CGFloat(index) * xStepWidth
                    path.move(to: .init(x: x, y: 0))
                    path.addLine(to: .init(x: x, y: geometry.size.height))
                }
            }
            .stroke(Color.gray)
        }
    }
    
    private var chartBody: some View {
        let pathProvider = LineChartProvider(data: data, lineRadius: CGFloat(lineRadius))
        return GeometryReader { geometry in
            ZStack {
                pathProvider.closedPath(for: geometry)
                    .fill(
                        LinearGradient(gradient: Gradient(colors: device.type == "sensor_temperature" ?[Color.red.opacity(0.2), Color.red.opacity(0.7)]
                                                            :[Color.blue.opacity(0.2), Color.blue.opacity(0.7)]),
                                       startPoint: .bottom,
                                       endPoint: .top)
                    )
                    .opacity(self.isPresentedClosedPath ? 1 : 0)
                
                pathProvider.path(for: geometry)
                    .trim(from: 0, to: self.isPresentedLine ? 1 : 0)
                    
                    
                    .stroke(
                        device.type == "sensor_temperature" ? Color.red : Color.blue,
                        //                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue]),
                        //                                       startPoint: .leading,
                        //                                       endPoint: .trailing),
                        style: StrokeStyle(lineWidth: 3)
                    )
            }
            .onAppear(){
                DispatchQueue.main.async {// toto fixuje divny behavior, mozno spomenut v praci
                    withAnimation(Animation.easeInOut(duration: 1.5)
                                    .delay(0.2)){
                        isPresentedLine = true
                    }
                    withAnimation(Animation.easeInOut(duration: 1)
                                    .delay(0.9)){
                        isPresentedClosedPath = true
                    }
                }
            }
            .gesture(DragGesture().onChanged({value in
                self.showIndicator = true
                self.closestPoint = getClosestDataPoint(toPoint: value.location, width: geometry.size.width, height: geometry.size.height)
            }).onEnded({value in
                        self.showIndicator = false}))
        }
    }
    
    func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = data
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        // let stepHeight: CGFloat = height / CGFloat(self.maxYValue)
        let index:Int = Int(floor((toPoint.x)/stepWidth))
        if (index >= 0 && index < points.count){
            print("index: \(index)")
            self.currentDataNumber = points[index].y
            return CGPoint(x:-195 + CGFloat(index) * stepWidth , y: 130 - ( (CGFloat(points[index].y)-self.minYValue) / (self.maxYValue - self.minYValue)) * height)
        }
        self.showIndicator = false
        return CGPoint(x:-195,y:130 - ( (CGFloat(points[0].y)-self.minYValue) / (self.maxYValue - self.minYValue)) * height)
    }
    
    private var chartXLabel: some View {
        VStack{
            Spacer()
            HStack {
                ForEach((11...16), id: \.self){index in
                    Text("\(index)").foregroundColor(.gray)
                    Spacer()
                }
            }
        }
    }
    
    private var chartYLabel: some View {
        HStack{
            Spacer()
            VStack(alignment: .trailing){
                Text("\(String(format: "%.1f%", self.maxYValue))").foregroundColor(.gray)
                Spacer()
                Text("\(String(format: "%.1f%", self.minYValue))").foregroundColor(.gray)
            }
        }
    }
}

struct LineChartProvider {
    let data: [Point]
    var lineRadius: CGFloat = 0.5
    
    private var maxYValue: CGFloat {
        data.max { $0.y < $1.y }?.y ?? 0
    }
    
    //    private var maxXValue: CGFloat {
    //        data.max { $0.x < $1.x }?.x ?? 0
    //    }
    //
    private var minYValue: CGFloat {
        data.min { $0.y < $1.y }?.y ?? 0
    }
    
    //    private var minXValue: CGFloat {
    //        data.min { $0.x < $1.x }?.x ?? 0
    //    }
    
    private var yStepsCount: Int {
        let delta = self.maxYValue - self.minYValue
        print(delta)
        if(delta < 1){
            return Int(delta / 0.1)
        }
        else if(delta < 2){
            return Int(delta / 0.2)
        }
        else if(delta < 5){
            return Int(delta / 0.5)
        }
        else if(delta < 10){
            return Int(delta / 1.0)
        }
        else if(delta < 20){
            return Int(delta / 2)
        }
        else if(delta < 50) {
            return Int(delta / 5)
        }
        else{
            return Int(delta / 10)
        }
    }
    
    func normalize(value : CGFloat) -> CGFloat {
        return (value - self.minYValue) / (self.maxYValue - self.minYValue)
    }
    
    func path(for geometry: GeometryProxy) -> Path {
        Path { path in
            // path.move(to: .init(x: 0, y: geometry.size.height - (data[0].y / self.maxYValue) * geometry.size.height))
            path.move(to: .init(x: 0, y: (1 - normalize(value: data[0].y)) * geometry.size.height))
            drawData(data, path: &path, size: geometry.size)
        }
    }
    
    func closedPath(for geometry: GeometryProxy) -> Path {
        Path { path in
            
            //  path.move(to: .init(x: 0, y: geometry.size.height - (data[0].y / self.maxYValue) * geometry.size.height))
            path.move(to: .init(x: 0, y: (1 - normalize(value: data[0].y)) * geometry.size.height))
            
            drawData(data, path: &path, size: geometry.size)
            
            path.addLine(to: .init(x: geometry.size.width, y: geometry.size.height))
            path.addLine(to: .init(x: 0, y: geometry.size.height))
            path.closeSubpath()
            
        }
    }
    
    private func drawData(_ data: [Point], path: inout Path, size: CGSize) {
        // var previousPoint = Point(x: 0, y: size.height - (data[0].y / self.maxYValue) * size.height)
        var idx = 0
        var previousPoint = CGPoint(x: CGFloat(idx), y: (1 - normalize(value: data[0].y)) * size.height)
        
        self.data.forEach { point in
            //  let x = (point.x / self.maxXValue) * size.width
            //            let x = CGFloat(idx) / self.maxXValue * size.width
            let x = CGFloat(idx) / CGFloat(self.data.count - 1)  * size.width
            let y = (1 - normalize(value: point.y)) * size.height
            
            let deltaX = x - previousPoint.x
            let curveXOffset = deltaX * self.lineRadius
            
            path.addCurve(to: .init(x: x, y: y),
                          control1: .init(x: previousPoint.x + curveXOffset, y: previousPoint.y),
                          control2: .init(x: x - curveXOffset, y: y ))
            
            previousPoint = .init(x: x, y: y)
            idx+=1
        }
    }
    //    func getClosestPointOnPath(touchLocation: CGPoint, path:Path) -> CGPoint {
    //            let closest = path.point(to: touchLocation.x)
    //            return closest
    //    }
    
}

struct SensorChartsView_Previews: PreviewProvider {
    static var previews: some View {
        SensorChartsView(device: Device(id: 0, device_name: "xxx", device: nil, reseting: false, glyph: "lightbulb", is_active: false, type: "sensor_temp", value: 24.0, max_level: 100, room: 1, processing: 0))
            .previewDevice("iPad Pro (12.9-inch) (4th generation)")
    }
}
