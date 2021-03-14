//
//  SimilarFunctionDetailView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 12/03/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct SimilarFunctionDetailView: View {
    @State var newFunction: SimilarNewFunction
    //    @State var newDevice: Device = Device(id: 0, device_name: "", device_custom_name: nil, reseting: true, glyph: "Lamp", is_active: false, type: "Switch", value: 0.0, max_level: 1, room: 1)
    
    @ObservedObject var nf : LoadJSONNewFunctionData
    @ObservedObject var dvcObj:LoadJSONData
    @Binding var activeSheet : ActiveSheet?
    @State var selectedGlyph : String = "lightbulb"
    @State var functionName: String = ""
    @State var isResetable: Bool = false
    @State var showRoomPicker: Bool = false
    @State var showTypePicker: Bool = false
    @State var deviceType : String = "Switch"
    @State var roomIndex : Int = 1
    @State var maxValue : Double = 1
    @State var maxPossibleValue : Double = 10
    
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Function Name"), footer: Text("Entitled function name will appear in main screen")) {
                    HStack{
                        NavigationLink(destination: GlyphSelectionView(selectedGlyph: $selectedGlyph, glyphArray: glyphArray) ){EmptyView()}.hidden().frame(width:0)
                        Image(systemName: selectedGlyph )
                            .font(.system(size:17, weight: .semibold))
                            .padding(4)
                            .frame(width:30,height:30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color(.systemOrange), lineWidth: 2)
                            )
                        
                        //                        }
                        TextField("e.g. Switch off", text: $functionName)
                            .disableAutocorrection(true)
                    }.padding(.leading,-20)
                }
                Section(header: Text("Device Vendor"), footer: Text("Correct vendor will help other people setting similar devices")) {
                    TextField("e.g. Apple", text: $newFunction.vendor)
                        .disableAutocorrection(true)
                    
                }
                Section(header: Text("Device Name"), footer: Text("Please set correct device name: \n • toggle \"Resetable\" applies to same Device Name\n • help other people setup similar functions")) {
                    TextField("e.g. AppleTV 4K ", text: $newFunction.deviceRealName)
                        .disableAutocorrection(true)
                }
                
                roomSectionView
                
                typeSectionView
                if (self.deviceType != "Switch"){
                    sliderSectionView
                }
                Section(footer: Text("If function is resetable, all same device functions will reset when changing state")){
                    Toggle(isOn: $isResetable) {
                        Text("Resetable")
                    }
                }
                Button(action:{
                    self.activeSheet = nil
//                    let createdFunction = NewFunction(id: newFunction.id, vendor: vendor, deviceRealName: deviceRealName, functionName: functionName, rawData: newFunction.rawData!, rawDataLen: newFunction.rawDataLen!)
                    
                    let createdDevice = Device(id: 0, device_name: functionName, device: newFunction.deviceRealName, reseting: isResetable, glyph: selectedGlyph, is_active: false, type: deviceType, value: 0.0, max_level: 1, room: roomIndex, processing: 0)
                    nf.nameAndCreateSimilarFunction(similarNewFunction: newFunction, device: createdDevice)
//                    dvcObj.createBackendDevice(function: createdFunction,device: createdDevice, restParam: "")
                }){
                    Text("Add to devices")
                    
                }.disabled(!(self.functionName != "" && newFunction.deviceRealName != "" && newFunction.vendor != ""))
            }
        }
    }
    
    var roomSectionView : some View {
        Section(header: Text("Room")){
            HStack{
                Text("Room")
                Spacer()
                Text(dvcObj.getRoomName(index: roomIndex))
                    .foregroundColor(.orange)
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: {
                // withAnimation(.linear(duration:0.2)){
                self.showRoomPicker.toggle()
                //}
            })
            if self.showRoomPicker {
                Picker(selection: $roomIndex, label: Text("Room")) {
                    ForEach(dvcObj.rooms,id: \.id){
                        Text($0.room_name).tag($0.id)
                    }
                }
                .pickerStyle(InlinePickerStyle())
            }
        }
    }
    
    var typeSectionView : some View {
        Section(header: Text("Function Type"), footer: Text("Setting correct device type will help other people setting similar devices")) {
            HStack{
                Text("Type")
                Spacer()
                Text(deviceType)
                    .foregroundColor(.orange)
            }
            
            .contentShape(Rectangle())
            .onTapGesture(perform: {
                //                withAnimation(.linear(duration:0.2)){
                self.showTypePicker.toggle()
                //                }
            })
            if self.showTypePicker {
                Picker(selection: $deviceType, label: Text("Type")) {
                    ForEach(["Switch","Levels","Slider"],id: \.self){
                        Text($0).tag($0)
                    }
                }
                .onChange(of: deviceType){ _ in
                    if(deviceType == "Slider"){
                        maxPossibleValue = 100.0
                        if(maxValue > 10){
                            maxValue = 10
                        }
                    }
                    else if(deviceType == "Levels"){
                        maxPossibleValue = 10.0
                    }
                }
                .pickerStyle(InlinePickerStyle())
            }
            
            
        }
        
    }
    
    var sliderSectionView : some View {
        Section(header: Text("Functions maximum value"), footer: Text("Some functions may have many levels, please select correct amount")) {
            HStack{
                Text("Maximum Value")
                Spacer()
                Text("\(String(format: "%.0f%", maxValue))")
            }
            Slider(value: $maxValue,
                   in: 1...maxPossibleValue,
                   step:1.0,
                   minimumValueLabel: Text("1"),
                   maximumValueLabel: Text("\(String(format: "%.0f%",maxPossibleValue))"),label:{Text("\(String(format: "%.0f%", maxValue))")})
        }
    }
}

struct SimilarFunctionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SimilarFunctionDetailView(newFunction: SimilarNewFunction(id: 0, vendor: "Apple", deviceRealName: "AppleTV", functionName: "SwitchON/Off", rawData: "", rawDataLen: ""), nf: LoadJSONNewFunctionData(), dvcObj: LoadJSONData(), activeSheet: .constant(.first) )
    }
}
