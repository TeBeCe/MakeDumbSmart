//
//  MakeDumbSmartTests.swift
//  MakeDumbSmartTests
//
//  Created by Martin Bachraty on 17/04/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import XCTest

@testable import MakeDumbSmart

class MakeDumbSmartTests: XCTestCase {
    
    func testGetFooterForEveryMondayFridayLongType(){
        //Prepare
        var footerContent:String?
        let selectedDays: [Bool] =  [true,false,false,false,true,false,false] //Monday and Friday selected
        XCTAssertNil(footerContent)
        //Act
        footerContent = footerDaysRepeat(selectedDays: selectedDays, footerDayType: .long)
        //Asert
        XCTAssertEqual(footerContent, "Every Monday, Friday")
    }

    func testGeFooterForEveryDaySelectedLongType(){
        //Prepare
        var footerContent:String?
        XCTAssertNil(footerContent)
        //Act
        footerContent = footerDaysRepeat(selectedDays: Array.init(repeating: true, count: 7), footerDayType: .long)
        //Asert
        XCTAssertEqual(footerContent, "Everyday")
    }
    
    func testGetAutLabelFooterDailyShortType(){
        var footerContent:String?
        XCTAssertNil(footerContent)
        
        footerContent = footerDaysRepeat(selectedDays: Array.init(repeating: true, count: 7), footerDayType: .short)
        
        XCTAssertEqual(footerContent, "daily")
    }
    
    func testGetFooterNeverLongType(){
        var footerContent:String?
        XCTAssertNil(footerContent)
        
        footerContent = footerDaysRepeat(selectedDays: Array.init(repeating: false, count: 7), footerDayType: .long)
        
        XCTAssertEqual(footerContent, "Never")
    }
    
    func testGetAutLabelEveryTueSatSunShortType(){
        var footerContent:String?
        XCTAssertNil(footerContent)
        
        footerContent = footerDaysRepeat(selectedDays: [false,true,false,false,false,true,true], footerDayType: .short)
        
        XCTAssertEqual(footerContent, "Tue, Sat, Sun")
    }
    
    func testGetAutLabelNeverShort(){
        var footerContent:String?
        
        XCTAssertNil(footerContent)
        
        footerContent = footerDaysRepeat(selectedDays: Array.init(repeating: false, count: 7), footerDayType: .short)
        
        XCTAssertEqual(footerContent, "never")
    }
    
    func testGetAutomatizationLabelOneDeviceName(){
        var automatizationLabel:String?
        var automatization: Automatization?
        XCTAssertNil(automatizationLabel)
        XCTAssertNil(automatization)
        
        automatization = exampleBareTimeAutomatization
        automatization?.devices = [exampleDeviceSwitch]
        automatizationLabel = getSceneAndDeviceLabel(automatization: automatization!)
        XCTAssertEqual(automatizationLabel, exampleDeviceSwitch.device_name)
    }
    
    func testGetAutomatizationLabelNoDevices(){
        var automatizationLabel:String?
        var automatization: Automatization?
        XCTAssertNil(automatizationLabel)
        XCTAssertNil(automatization)
        
        automatization = exampleBareTimeAutomatization
        automatizationLabel = getSceneAndDeviceLabel(automatization: automatization!)
        XCTAssertEqual(automatizationLabel, "No devices or scenes")
    }
    
    func testGetAutomatizationLabelMultipleDevives(){
        var automatizationLabel:String?
        var automatization: Automatization
        
        XCTAssertNil(automatizationLabel)
        
        automatization = exampleBareTimeAutomatization
        automatization.devices = exampleDeviceArray

        automatizationLabel = getSceneAndDeviceLabel(automatization: automatization)
        XCTAssertEqual(automatizationLabel, "\(String(automatization.scenes.count )) scenes and \(String( automatization.devices.count )) devices")
    }
    
    func testGetAutomatizationLabelOneSceneName(){
        var automatizationLabel:String?
        var automatization: Automatization?
        XCTAssertNil(automatizationLabel)
        XCTAssertNil(automatization)
        
        automatization = exampleBareTimeAutomatization
        automatization?.scenes = [exampleBareScene]

        automatizationLabel = getSceneAndDeviceLabel(automatization: automatization!)
        XCTAssertEqual(automatizationLabel, exampleBareScene.scene_name)
    }
    
    func testGetAutomatizationLabelMultipleScenes(){
        var automatizationLabel:String?
        var automatization: Automatization
        XCTAssertNil(automatizationLabel)
        
        automatization = exampleBareTimeAutomatization
        automatization.scenes = [exampleBareScene,exampleBareScene]
        
        automatizationLabel = getSceneAndDeviceLabel(automatization: automatization)
        XCTAssertEqual(automatizationLabel, "\(String(automatization.scenes.count)) scenes and \(String( automatization.devices.count )) devices")
    }
    
    func testDetermineValueForSwitchLabelOFF(){
        var value:String?
        
        XCTAssertNil(value)
        value = DetermineValue(device: exampleDeviceSwitch)
        XCTAssertEqual(value, "Vyp.")
    }
    
    func testDetermineValueForSwitchLabelON(){
        var value:String?
        
        XCTAssertNil(value)
        exampleDeviceSwitch.is_active = true
        exampleDeviceSwitch.value = 1
        value = DetermineValue(device: exampleDeviceSwitch)
        XCTAssertEqual(value, "Zap.")
    }
    
    func testDetermineValueForLevelsLabelIsActive(){
        var value:String?
        
        XCTAssertNil(value)
        value = DetermineValue(device: exampleDeviceLevels)
        XCTAssertEqual(value, "1")
    }
    
    func testDetermineValueForLevelsLabelIsOFF(){
        var value:String?
        
        XCTAssertNil(value)
        exampleDeviceLevels.is_active = false
        exampleDeviceLevels.value = 0.0
        value = DetermineValue(device: exampleDeviceLevels)
        XCTAssertEqual(value, "Vyp.")
    }
    
    func testDetermineValueForHumidityValue(){
        var value:String?
        
        XCTAssertNil(value)
        value = DetermineValue(device: exampleHumiditySensor)
        XCTAssertEqual(value, "24%")
    }
    
    func testDetermineValueForTempValue(){
        var value:String?
        
        XCTAssertNil(value)
        value = DetermineValue(device: exampleTempSensor)
        XCTAssertEqual(value, "24.5°")
    }
//    func testDetermineValueForSlider(){
//        var value:String?
//
//        XCTAssertNil(value)
//        value = DetermineValue(device: exampleDeviceSlider)
//        XCTAssertEqual(value, "1%")
//    }
    
    func testCalculate2Levels(){
        var levelIntervals: [Float]?
        let numOfLevels:Int = 2
        
        XCTAssertNil(levelIntervals)
        
        levelIntervals = CalculateLevels(levels: numOfLevels)
        
        XCTAssertEqual(levelIntervals, [50.0,0.0])
    }
    
    func testCalculate4Levels(){
        var levelIntervals: [Float]?
        let numOfLevels:Int = 4
        
        XCTAssertNil(levelIntervals)
        
        levelIntervals = CalculateLevels(levels: numOfLevels)
        
        XCTAssertEqual(levelIntervals, [75.0,50.0,25.0,0.0])
    }
    
    func testGetRoomNameValid(){
        var roomName: String
        
        roomName = getRoomFrom(rooms: exampleRoomArray, device: exampleDeviceLevels)
        
        XCTAssertEqual(roomName,exampleRoomArray[0].room_name)
    }
    
    func testGetRoomNameInvalid(){
        var roomName: String
        var exampleInvalidDeviceRoom = exampleDeviceLevels
        exampleInvalidDeviceRoom.room = 0
        roomName = getRoomFrom(rooms: exampleRoomArray, device: exampleInvalidDeviceRoom)
        
        XCTAssertEqual(roomName,"")
    }
    
    func testGetModuleNameValid(){
        var moduleName: String
        
        moduleName = getModuleNameFrom(modules: exampleModuleArray, device: exampleDeviceLevels)
        
        XCTAssertEqual(moduleName,exampleModuleArray[0].module_name)
    }
    
    func testGetModuleNameInvalid(){
        var moduleName: String
        var exampleInvalidAssignedModule = exampleDeviceLevels
        exampleInvalidAssignedModule.module_id = 0
        moduleName = getModuleNameFrom(modules: exampleModuleArray, device: exampleInvalidAssignedModule)
        
        XCTAssertEqual(moduleName,"")
    }
    
    func testGetDateFromString(){
        let inputStr = "2021-04-12T12:00:00"
        var returnedDate: Date?
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = formatter.date(from: inputStr)
        
        XCTAssertNil(returnedDate)
        
        returnedDate = getDateFromTimeString(dateString: inputStr)
        
        XCTAssertEqual(date, returnedDate)
    }
    
    
}
