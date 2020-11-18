//
//  ContentView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 03/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State  private var selectedDevice : Device? = nil
    
    @ObservedObject var dvcObj = LoadJSONData()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let rows = [
        GridItem(.fixed(60)),
        GridItem(.fixed(60))
    ]
    
    var body: some View {
        VStack(alignment: .leading){
            Text(dvcObj.home.home_name).font(.system(size: 50, weight: .bold))
                .fontWeight(.bold)
                .padding(.leading, 20)
                .padding(.top, 20)
            
            ScrollView(){
                VStack(alignment: .leading){
                    Text("Favorite scenes").padding(.leading, 20)
                    
                    ScrollView(.horizontal,showsIndicators: false){
                        LazyHGrid(rows: rows,alignment: .center, spacing: 10)
                        {
                            ForEach(dvcObj.scenes.indices,id: \.self){ indx in
                                Button(action: {
                                    dvcObj.scenes[indx].is_active.toggle()
                                }){
                                    SceneView(scene: self.dvcObj.scenes[indx])
                                }
                            }
                        }.padding(.leading,20)
                    }.padding(.leading, 0.0)
                    
                }.padding(.bottom, 10)
                
                VStack(alignment: .leading){
                    Text("Favorite Functions").padding(.leading, 20)
                    
                    LazyVGrid(columns: columns, spacing: 10){
                        ForEach(dvcObj.devices.indices,id: \.self ) { indx in
                            Button(action: {
                                self.selectedDevice = self.dvcObj.devices[indx]
                                print(self.dvcObj.devices[indx])
//                                self.dvcObj.devices[indx].is_active.toggle()
                            })
                            {
                                DevicesView(device: self.dvcObj.devices[indx])
                            }
                        }
                    }.sheet(item: $selectedDevice){ device in
                        DeviceDetailView(dvcObj: dvcObj, device: device)
                                                }
                    .padding(.horizontal)
                }
            }
                    
        }.onAppear(perform: {self.dvcObj.loadData()
        })
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)), Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))]), startPoint: .top, endPoint: .trailing))
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
