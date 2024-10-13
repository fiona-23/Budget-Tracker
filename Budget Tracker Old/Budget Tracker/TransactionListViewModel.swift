//
//  TransactionListViewModel.swift
//  Project DubHacks Curr
//
//  Created by Fiona Evans on 10/12/24.
//

import Foundation
import Combine
import Collections
import PythonKit

var file_path = "/Users/fionae/Downloads/BankStatement.pdf"
typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
typealias TransactionPrefixSum = [(String, Double)]
let budgeter = Python.import(file_path)
let result = budgeter.process_pdf(file_path)

final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = [] // sends notifications to user when value has changes
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        //getTransactions()
    }
    func getTransactions() {
        // Call the Python function to process the PDF
        let result = budgeter.process_pdf(file_path)

        // Check if result is a valid PythonObject (list of dictionaries)
        guard let parsedTransactions = result as? PythonObject else {
            print("Error: No valid result returned from Python function")
            return
        }

        var transactionsArray: [Transaction] = []

        // Iterate over the Python result (assuming it's a list of dictionaries)
        for transactionData in parsedTransactions {
            // Make sure that each transactionData is a dictionary-like object
            guard let transactionDict = transactionData as? PythonObject else {
                continue
            }

            // Extract the transaction fields with explicit casting
            let transaction = Transaction( // date &type & amount
                id: Int(transactionDict["id"]) ?? 0,
                date: String(transactionDict["date"]) ?? "",
//                Institution: String(transactionDict["Institution"]) ?? "",
//                account: String(transactionDict["account"]) ?? "",
                merchant: String(transactionDict["merchant"]) ?? "",
                amount: Double(transactionDict["amount"]) ?? 0.0,
                //type: String(transactionDict["type"]) ?? "",
                categoryId: Int(transactionDict["categoryId"]) ?? 0,
//                category: String(transactionDict["category"]) ?? "",
//                isPending: Bool(transactionDict["isPending"]) ?? false,
                isExpense: Bool(transactionDict["isTransfer"]) ?? false
//                isExpense: Bool(transactionDict["isExpense"]) ?? false,
//                isEdited: Bool(transactionDict["isEdited"]) ?? false
            )

            transactionsArray.append(transaction)
        }

        // Update the transactions array on the main thread
        DispatchQueue.main.async {
            self.transactions = transactionsArray
        }
    }

    
//    func getTransactions(){
//        // imported data
//        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
//                print("Invalid URL")
//                return
//        }
//        URLSession.shared.dataTaskPublisher(for: url)
//            .tryMap { (data, response) -> Data in
//                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                    dump(response)
//                    throw URLError(.badServerResponse)
//                }
//                return data
//            }
//            .decode(type: [Transaction].self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                switch completion{
//                case.failure(let error):
//                    print("Error fetching Transactions")
//                case.finished:
//                    print("Finished fetching Transactions")
//                }
//            } receiveValue: { [weak self] result in
//                self?.transactions = result
//            }
//            .store(in: &cancellables)
//    }
//      
    
    func groupTransactionByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else {return [:]}
        
        let groupTransactions = TransactionGroup(grouping: transactions) { $0.month }
        return groupTransactions
    }
    
    func accumulateTransactions() -> TransactionPrefixSum {
        print("Accumulate Transactions")
        guard !transactions.isEmpty else {return []}
        let today = "10/12/2024".dateParsed()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)
        print("dateInterval", dateInterval)
        
        var sum: Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        for date in stride(from: dateInterval!.start, to: today, by: 60*60*24){
            let dailyExpenses = transactions.filter {$0.dateParsed == date && $0.isExpense}
            let dailyTotal = dailyExpenses.reduce(into: 0) {$0-$1.amount}
            sum += dailyTotal
            cumulativeSum.append((date.formatted(), sum))
            print(date.formatted(), "daily total:", dailyTotal, "sum:", sum)
            }
        return cumulativeSum
    }
}


