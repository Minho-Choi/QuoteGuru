//
//  QuoteList.swift
//  Quotes
//
//  Created by Minho Choi on 2020/04/13.
//  Copyright © 2020 Minho Choi. All rights reserved.
//
// http://ssjossjo1204.pythonanywhere.com/quotes/api/all/?format=json


import SwiftUI
import Combine

struct QuoteList: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var qlist = FetchQuoteList()
    @State var sharedQuoteData = Quotes.init()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(qlist.quoteList) { list in
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        ContentView().self.quoteData.showData(data: list)
                        print("1: \(ContentView().self.quoteData.quote.quote)")
                        print("3: \(list.quote)")
                        ContentView().quoteData.refresh()
//                        print("listview: \(list)")
                    }) {
                        VStack(alignment: .leading) {
                            Text("\(list.author)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            Spacer()
                            Text("\(list.quote)")
                                .frame(height:20)
                            .scaledToFit()
                        }
                    }
                }
            }.navigationBarTitle("Quotes List")
        }
    }
}

struct QuoteList_Previews: PreviewProvider {
    static var previews: some View {
        QuoteList()
    }
}

class FetchQuoteList: ObservableObject {

    @Published var quoteList: [Quotes] = [Quotes.init()]
    
    init() {
        fetch()
    }
    
    func fetch() {

        let url = URL(string: "https://ssjossjo1204.pythonanywhere.com/quotes/api/all/?format=json")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
        do {
            if let qData = data {
                let decodedQuotes = try JSONDecoder().decode([Quotes].self, from: qData)
                DispatchQueue.main.async {
                    self.quoteList = decodedQuotes
//                    print(self.quoteList)
                }
                } else {
                print("No Data")
                }
            } catch {
                print("Error")
            }
        }.resume()
    
    }
    
    func refresh() {
        fetch()
    }
}

