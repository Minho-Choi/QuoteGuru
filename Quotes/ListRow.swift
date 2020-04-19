//
//  ListRow.swift
//  Quotes
//
//  Created by Minho Choi on 2020/04/13.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import SwiftUI

let exampleQuote = Quotes()

struct ListRow: View {
    
    var list: Quotes
    @State var scrollTtext = false
    
    var body: some View {
        VStack {
            Text("\(list.author)")
                .font(.footnote)
                .foregroundColor(.gray)
                .frame(width: 600, height: 15, alignment: .leading)
            padding(10)
            Text("\(list.quote)")
            .frame(width: 600, height: 30)
                .offset(x: scrollTtext ? -182:300)
                .animation(Animation.linear(duration: 8).repeatForever(autoreverses: false))
                .onAppear() {
                    self.scrollTtext.toggle()
            }
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        ListRow(list: exampleQuote)
    }
}


