//
//  ContentView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 03/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var showingDetail = false
    var decodedDevices : [Device]? = nil
    
    @ObservedObject var dvcObj = LoadJSONData()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
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
                        HStack{
                            SceneView()
                            SceneView()
                        }.padding(.leading, 20.0)
                        HStack{
                            SceneView()
                            SceneView()
                        }.padding(.leading, 20.0)
                        
                    }.padding(.leading, 0.0)
                    
                }.padding(.bottom, 10)
                
                VStack(alignment: .leading){
                    Text("Favorite Functions").padding(.leading, 20)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(dvcObj.devices ) { device in
                            Button(action: {
                                print(device)
                                self.showingDetail.toggle()
                                
                            })
                            {
                                DevicesView(device: device)
                            }.sheet(isPresented: $showingDetail){
                                DeviceDetailView(device: device)
                            }
                        }
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
