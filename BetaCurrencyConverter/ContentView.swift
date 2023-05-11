//
//  ContentView.swift
//  BetaCurrencyConverter
//
//  Created by Adam Permana on 09/05/23.
//

import SwiftUI

struct ContentView: View {
    @State var input = ""
    @State var base = ""
    @State var currencyList = [String]()
    @State private var selectedCurrency = 0
    @State private var inputIsFocused = false
    
    let currencies = ["AUD", "BRL", "CAD", "CHF", "CNY", "EUR", "GBP", "HKD", "IDR", "INR", "JPY", "KRW", "MXN", "MYR", "PHP", "RUB", "SGD", "THB", "USD", "ZAR"]
    
    func makeRequest(showAll: Bool, currencies: [String] = ["AUD", "BRL", "CAD", "CHF", "CNY", "EUR", "GBP", "HKD", "IDR", "INR", "JPY", "KRW", "MXN", "MYR", "PHP", "RUB", "SGD", "THB", "USD", "ZAR"]) {
        let url = "https://api.exchangerate.host/latest?base=\(base)&amount=\(input)"
        apiRequest(url: url) { currency in
            var tempList = [String]()
            for currency in currency.rates {
                if showAll {
                    tempList.append("\(currency.key) \(String(format: "%.2f", currency.value))")
                } else if currencies.contains(currency.key) {
                    tempList.append("\(currency.key) \(String(format: "%.2f", currency.value))")
                }
            }
            tempList.sort()
            currencyList = tempList
            print(tempList)
        }
    }
    
    let logoImage = Image("Logo")
    
    var body: some View {
        VStack {
            HStack {
                logoImage
                    .resizable()
                    .frame(width: 190, height:100)
                    .foregroundColor(.black)
            }
            List {
                ForEach(currencyList, id: \.self) { currency in
                    Text(currency)
                }
            }
            VStack {
                Form {
                    TextField("Enter an amount", text: $input)
                        .padding()
                        .background(Color.gray.opacity(0.10))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .onTapGesture {
                            self.inputIsFocused = true
                        }
                    
                    Picker(selection: $selectedCurrency, label: Text("From")) {
                        ForEach(0..<currencies.count) { index in
                            Text(currencies[index]).tag(index)
                        }
                    }
                    .frame(minWidth: 3, maxWidth: .infinity)
                    .padding()
                    
                    Button("Convert") {
                        base = currencies[selectedCurrency]
                        makeRequest(showAll: true, currencies: currencies)
                        inputIsFocused = false
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(20.0)
                    .padding(.horizontal)
                    .bold()
                }
            }
            .onAppear {
                makeRequest(showAll: true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
