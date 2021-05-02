//
//  HelperVarsAndFuncs.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 05/04/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case first, second, third, fourth
    
    var id: Int {
        hashValue
    }
}

enum footerDayType: Identifiable{
    case long, short
    
    var id: Int{
        hashValue
    }
}

enum automatizationType: Identifiable {
    case time, sensor
    
    var id: Int {
        hashValue
    }
}

var selectionFeedbackGenerator = UISelectionFeedbackGenerator()

var exampleBareTimeAutomatization : Automatization = Automatization(id:0, devices: [],scenes: [])
var exampleBareSenzorAutomatization : Automatization = Automatization(id:0, devices: [],scenes: [])

var exampleDeviceSwitch: Device = Device(id: 1, device_name: "Test Switch", device: "Cooler", reseting: false, glyph: "lightbulb", is_active: false, type: "Switch", value: Float(0.0), max_level: 3, room: 1, processing: 0)

var exampleDeviceLevels: Device = Device(id: 1, device_name: "Test Levels", module_id: 1, device: "Cooler", reseting: false, glyph: "lightbulb", is_active: true, type: "Levels", value: Float(1.0), max_level: 3, room: 1, processing: 1)

var exampleDeviceSlider: Device = Device(id: 1, device_name: "Test Slider", module_id: 1 , device: "Cooler", reseting: false, glyph: "lightbulb", is_active: true, type: "Slider", value: Float(1.0), max_level: 3, room: 1, processing: 1)

var exampleDeviceInvalidRoomAndModule: Device = Device(id: 1, device_name: "Test Slider", module_id: 0,device: "Cooler", reseting: false, glyph: "lightbulb", is_active: true, type: "Slider", value: Float(1.0), max_level: 3, room: 0, processing: 1)

var exampleDeviceArray: [Device] = [exampleDeviceSwitch,exampleDeviceLevels]

var exampleBareScene: Scene = Scene(scene_name: "Test Scene", id: 0, is_favorite: false, glyph: "lightbulb", is_active: false, devices: [], scene_devices: [])

var exampleRoomArray: [Room] = [Room(id: 1, room_name: "Test Room 1"), Room(id: 2, room_name: "Test Room 2")]

var exampleModuleArray: [Module] = [Module(id: 1, module_name: "Test Module 1"), Module(id: 2, module_name: "Test Module 2")]

var exampleHumiditySensor: Device = Device(id: 1, device_name: "Hum_sens", module_id: 1, device: nil, reseting: false, glyph: "lightbulb", is_active: false, type: "sensor_humidity",value: 24.5, max_level: 1, room: 1, processing: 0)
var exampleTempSensor: Device = Device(id: 1, device_name: "Hum_sens", module_id: 1, device: nil, reseting: false, glyph: "lightbulb", is_active: false, type: "sensor_temperature",value: 24.5, max_level: 1, room: 1, processing: 0)

func DetermineValue(device: Device) -> String {
    
    switch device.type{
    case "Switch" :
        return !device.is_active || device.value == 0.0 ? "Vyp." : "Zap."
    case "Slider" :
        return !device.is_active || device.value == 0.0 ? "Vyp." : "\(String(format: "%.1f%", device.value))%"
    case "Levels" :
        return !device.is_active || device.value == 0.0 ? "Vyp." : "\(String(format: "%.0f%", device.value))"
    case "sensor_temperature":
        return "\(String(device.value))°"
    case "sensor_humidity":
        return "\(String(format: "%.0f%", device.value))%"
    default:
        return "Unknown type/state"
    }
}

func footerDaysRepeat(selectedDays:[Bool], footerDayType: footerDayType) -> String {
    var dayNames: [String]
    var returnDays : String
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale.autoupdatingCurrent

    if(footerDayType == .long){
        dayNames = calendar.weekdaySymbols
        dayNames = Array(dayNames[2-1..<dayNames.count]) + dayNames[0..<2-1]
        returnDays = "Every "
    }
    else{
        dayNames = calendar.shortWeekdaySymbols
        dayNames = Array(dayNames[2-1..<dayNames.count]) + dayNames[0..<2-1]
        returnDays = ""
    }
    if(selectedDays.allSatisfy({$0 == selectedDays.first})){
        if(selectedDays.first!){
            return footerDayType == .long ? "Everyday" : "daily"
        }
        else{
            return footerDayType == .long ? "Never" : "never"
        }
    }
    for (index,day) in selectedDays.enumerated() {
        if(day){
            returnDays.append(dayNames[index] + ", ")
        }
    }
    let count = returnDays.lastIndex(of: ",")!
    returnDays = String(returnDays[..<count])
    return returnDays
}

func getStringFromDate(date: Date) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let dateString = formatter.string(from: date)
    return dateString
}

func getHourFromDate(date: Date) -> String {
    
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    let timeString = formatter.string(from: date)
    return timeString
}

func getDateFromTimeString(dateString: String)-> Date?{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    let date = formatter.date(from: dateString)
    return date
}

func getSceneAndDeviceLabel(automatization: Automatization) -> String{
    if(automatization.devices.count == 0 && automatization.scenes.count == 0){
        return "No devices or scenes"
    }
    else{
        if(automatization.devices.count == 1 && automatization.scenes.count == 0){
            return (automatization.devices.first!.device_name)
        }
        else if(automatization.scenes.count == 1 && automatization.devices.count == 0){
            return (automatization.scenes.first!.scene_name)
        }
        else {
            return "\(String(automatization.scenes.count)) scenes and \(String( automatization.devices.count)) devices"
        }
    }
}

func CalculateLevels(levels: Int) -> [Float]{
    var result: [Float] = []
    for i in 0..<levels {
        let left = 100.0 / Float(levels)
        let right = levels-i-1
        result.append(left * Float(right))
    }
    return result
}

func getRoomFrom(rooms: [Room], device: Device) -> String{
    if let indx = rooms.firstIndex(where: {$0.id == device.room}){
        return rooms[indx].room_name
    }
    else{
        return ""
    }
}

func getModuleNameFrom(modules: [Module], device: Device) -> String{
    if let indx = modules.firstIndex(where: {$0.id == device.module_id}){
        return modules[indx].module_name
    }
    else{
        return ""
    }
}

