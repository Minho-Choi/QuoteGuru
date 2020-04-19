//
//  QuoteInput.swift
//  Quotes
//
//  Created by Minho Choi on 2020/04/05.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import SwiftUI

struct QuoteInput: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var quote = ""
    @State var author = ""
    @State private var showingInfo = false
    @State var quoteNil = false
    @State var authorNil = false
    @State var state = 3
    
    var body: some View {

        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                        .foregroundColor(Color.init(red: 252/255, green: 31/255, blue: 193/255))
                    }
                }.padding()
                Form {
                    Section(header: Text("Quote")) {
                    TextField("Enter the quote", text: $quote)
                        .keyboardType(.default)
                    }
                    .alert(isPresented: $quoteNil) {
                        Alert(title: Text("Error"), message: Text("Please enter quote."), dismissButton: .default(Text("OK")))
                    }
                    Section(header: Text("Author")) {
                        TextField("Enter the author", text: $author)
                            .keyboardType(.default)
                    }
                    .alert(isPresented: $authorNil) {
                            Alert(title: Text("Error"), message: Text("Please enter author."), dismissButton: .default(Text("OK")))
                    }
                    Section {
                        Text("『\(quote)』")
                            .font(.title)
                            .kerning(1)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .frame(alignment: .center)
                            .lineSpacing(10)

                        
                        Text("- \(author) -")
                            .font(.body)
                            .frame(width: 330, alignment: .trailing)
                    }
                    Button(action: {
                        self.state = submit(quote: self.quote, author: self.author)
                        
                        if self.state == 1 {
                            self.quoteNil = true
                            print("quoteNil: \(self.quoteNil)")
                        }
                            
                        else if self.state == 2 {
                            self.authorNil = true
                            print("authorNil: \(self.authorNil)")
                        }
                        else {
                            self.showingInfo = true
                        }
                    }) {
                        HStack {
                            Spacer()
                        Text("Submit")
                            .font(.headline)
                            .foregroundColor(Color.init(red: 252/255, green: 31/255, blue: 193/255))
                            Spacer()
                        }
                    }
                    .alert(isPresented: $showingInfo) {
                        Alert(title: Text("Success"), message: Text("Quote is added to the list successfully."), dismissButton:  .default(Text("OK")))
                    }
                }
            }.navigationBarTitle("Add New Quote")
        }
    }
}

struct QuoteInput_Previews: PreviewProvider {
    static var previews: some View {
        QuoteInput()
    }
}

func submit(quote: String, author: String) -> Int {
    
    if quote == "" {
        print("quote nil")
        return 1
    }
    else if author == "" {
        print("author nil")
        return 2
    }
    else {
    // Prepare URL
    let url = URL(string: "https://ssjossjo1204.pythonanywhere.com/quotes/api/one/")
    guard let requestUrl = url else { fatalError() }
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
     
    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString = "quote=\(quote)&author=\(author)";
    // Set HTTP Request Body
    request.httpBody = postString.data(using: String.Encoding.utf8);
    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
     
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
    }
    task.resume()
        return 0
    }
}
