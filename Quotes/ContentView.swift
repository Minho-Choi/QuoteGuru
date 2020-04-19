//
//  ContentView.swift
//  Quotes
//
//  Created by Minho Choi on 2020/04/04.
//  Copyright © 2020 Minho Choi. All rights reserved.
//
//  "Icon made by Pixel perfect from www.flaticon.com"

import SwiftUI
import Combine

struct ContentView: View {
    
    @State private var showModalEdit = false
    @State private var showModalList = false
    @State private var ispushed = 1
    @ObservedObject var quoteData = FetchQuote()
    
        var body: some View {
            ZStack {
                Color.init(.clear)
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .center, spacing: 40) {
                    Text("Quote Guru's Wisdom")
                        .font(.custom("Papyrus", size: 30))
                        .foregroundColor(Color.init(red: 252/255, green: 31/255, blue: 193/255))
                        .padding(10)

//                        .shadow(color: .init(red: 255/255, green: 255/255, blue: 126/255), radius: 3)
                    ZStack {
                    Color.init(red: 251/255, green: 154/255, blue: 234/255)
                        .shadow(color: Color.init(red: 151/255, green: 54/255, blue: 134/255), radius: 10, x: 5, y: 5)
                        
                        VStack {
                        
                            Text("『 \(quoteData.quote.quote) 』")
                                .font(.custom("Papyrus", size: 30))
                                    .kerning(1)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .frame(alignment: .center)
                                    .lineSpacing(7)
                                .foregroundColor(.black)
                                .padding(25)
    //                            .shadow(color: .yellow, radius: 3)
                            .minimumScaleFactor(0.01)
                            
                            Text("- \(quoteData.quote.author) ")
                                .font(.custom("Papyrus", size: 20))
                                        .bold()
                                        .frame(width: 300, alignment: .trailing)
                                .foregroundColor(.black)

                                    .background(Color.clear)
                        }
                    }
                    
                            Button(action: {
                                self.quoteData.refresh()
                                self.ispushed = self.ispushed + 1

                            }) {
                                HStack {
                                    Image(systemName: "arrow.2.circlepath")
                                        .imageScale(.large)
                                        .scaleEffect(1.2)
                                        .rotationEffect(.degrees(Double(ispushed * 360)))
                                        .animation(.default)
                                        .foregroundColor(.black)
                                    Text("     Reload   ")
                                        .font(.body)
                                    .bold()
                                        .scaleEffect(1.5)
                                        .foregroundColor(.black)
                                }.padding(20)
                                .background(Color.init(red: 255/255, green: 220/255, blue: 255/255))
                                .cornerRadius(20)
                            }
                    
// spicy web 링크 버튼
//                    Button(action: {
//                        if let url = URL(string:"https://ssjossjo1204.pythonanywhere.com") {
//                            UIApplication.shared.open(url, options: [:])
//                        }
//                    }) {
//                        Text("SPICY WEB 방문하기")
//                            .font(.body)
//                            .bold()
//                                .padding(20)
//                            .foregroundColor(.black)
//                                    .background(Color.init(red: 255/255, green: 220/255, blue: 255/255))
//                            .cornerRadius(20)
//                            }
                    
                            Spacer()
                    HStack(alignment: .center, spacing: 160) {
                        
                        Button(action: {
                            self.showModalList = true
                        }) {
                            Image(systemName: "list.dash")
                                .imageScale(.large)
                                .scaleEffect(1.5)
                                .animation(.default)
                                .foregroundColor(.black)
                                .sheet(isPresented: self.$showModalList) {
                                    QuoteList()
                            }
                        }
                        
                        Button(action: {
                            self.showModalEdit = true
                        }) {
                            Image(systemName: "square.and.pencil")
                                .imageScale(.large)
                                .scaleEffect(1.5)
                                .animation(.default)
                                .foregroundColor(.black)
                                .sheet(isPresented: self.$showModalEdit) {
                                    QuoteInput()
                            }
                        }
                    }
                .padding(20)
                }.padding()
            }
        }
}
    
struct Quotes: Codable, Identifiable {
    
    var id: Int = 0
    var author: String = ""
    var quote: String = "Loading..."
    var created_date: String = ""
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(quoteData: FetchQuote())
    }
}


class FetchQuote: ObservableObject {
//    static var count = 0
    
//    var didChange = PassthroughSubject<FetchQuote, Never>()
//    var quote = Quotes.init() {
//        didSet {
////            didChange.send(self)
//            print("출력")
//        }
//    }
    @Published var quote: Quotes = Quotes.init()
//    var quote: String = "아윽"
    
    init() {
        fetch()
    }
    
    func fetch() {

        let url = URL(string: "https://ssjossjo1204.pythonanywhere.com/quotes/api/one/?format=json")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
        do {
            if let qData = data {
                let decodedQuotes = try JSONDecoder().decode(Quotes.self, from: qData)
                DispatchQueue.main.async {
                    self.quote = decodedQuotes
//                    print(self.quote)
                }
//                        self.didChange.send(self)
                
//                        self.quote = "aa"+"\(FetchQuote.count)"
//                        FetchQuote.count = FetchQuote.count + 1
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
    
    func showData(data: Quotes) {
        DispatchQueue.main.async {
            self.quote = data
            print("2: \(data.quote)")
        }
    }
}
