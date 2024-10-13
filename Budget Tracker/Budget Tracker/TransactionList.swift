//
//  TransactionsList.swift
//  Project DubHacks Curr
//
//  Created by Fiona Evans on 10/12/24.
//

import SwiftUI
import Foundation

struct TransactionList: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    var body: some View {
        VStack {
            List {
                //transaction groups
                ForEach(Array(transactionListVM.groupTransactionByMonth()), id: \.key){ month, transactions in
                    Section {
                        ForEach(transactions){transaction in TransactionRow(transaction: transaction)}
                    }header: {
                        Text(month)
                    }
                    .listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TransactionList_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    static var previews: some View {
        NavigationView{
            TransactionList()
        }
        .environmentObject(transactionListVM)
    }
    
}
