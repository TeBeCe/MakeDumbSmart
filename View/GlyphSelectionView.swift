//
//  GlyphSelectionView.swift
//  MakeDumbSmart
//
//  Created by Martin Bachraty on 09/03/2021.
//  Copyright © 2021 Martin Bachratý. All rights reserved.
//

import SwiftUI
var glyphArray = ["lightbulb","alarm","dial.min","flashlight.off.fill","drop","sun.min","moon","power","togglepower","escape"]
struct GlyphSelectionView: View {
    @Binding var selectedGlyph : String
    var glyphArray:[String]
    var body: some View {
        VStack{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40, maximum: 40))],spacing:10) {
                ForEach(glyphArray, id:\.self){i in
                    Image(systemName: i)
                        .font(.system(size: 30))
                        .frame(width:45,height:45)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(.systemOrange), lineWidth: (selectedGlyph == i) ? 3 : 0)
                        ).onTapGesture {
                            selectedGlyph = i
                        }
                }
            }.navigationBarTitle(Text("Select Glyph"))
            Spacer()
        }.padding(.top,5)
    }
}

struct GlyphSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GlyphSelectionView(selectedGlyph: .constant("lightbulb"), glyphArray: glyphArray)
    }
}
