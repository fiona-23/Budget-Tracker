//
//  RecentTransactionList.swift
//  Project DubHacks Curr
//
//  Created by Fiona Evans on 10/12/24.
//

import SwiftUI

struct RecentTransactionList: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Recent Transactions")
                    .bold()
                
                Spacer()
                
                // Header Link
                NavigationLink {
                    TransactionList()
                    
                } label: {
                    HStack(spacing: 4) {
                        Text("See All")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(Color.textColor)
                }
                
            }
            .padding(.top)
            // Recent Transaction List
            ForEach(Array(transactionListVM.transactions.prefix(5).enumerated()), id:
                    \.element) { index, transaction in TransactionRow(transaction: transaction)
                
                Divider()
                    .opacity(index == 4 ? 0 : 1)
            }
            Spacer()
            NavigationLink{
                PdfView()
            }label: {
                HStack(spacing: 7) {
                    Text("Upload PDF")
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(Color.textColor)
            }
            .padding(.bottom, 16)
        }
        .padding()
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.primary.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct RecentTransactionList_Previews: PreviewProvider{
    static let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    
    static var previews: some View{
        RecentTransactionList()
            .environmentObject(transactionListVM)
    }

}
