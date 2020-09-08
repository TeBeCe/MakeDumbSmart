//
//  ContentView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachratý on 03/09/2020.
//  Copyright © 2020 Martin Bachratý. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var array = [1,2,3,4,5,6,7,8,9,10]
    @State var showingDetail = false
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Home").font(.system(size: 50, weight: .bold))
                .fontWeight(.bold)
                .padding(.leading, 20)
            
            ScrollView(){
                VStack(alignment: .leading){
                    Text("Favourite scenes").padding(.leading, 20)
                    
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
                    Text("Favourite functions")
                        .multilineTextAlignment(.leading)
                    
                    GridStack()
                    //                    HStack{
                    //                        DevicesView()
                    //                            .onTapGesture {
                    //                                print("tap")
                    //                        }
                    //                        .onLongPressGesture {
                    //                            self.showingDetail.toggle()
                    //                        }
                    //                        .sheet(isPresented: $showingDetail){
                    //                            DevicesView()
                    //                        }
                    //                    }
                    //                    .padding(.leading, 0)
                    //                    .padding(.bottom, 20)
                }
            }
            //        .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
