//
//  ContentView.swift
//  Project DubHacks Curr
//
//  Created by Fiona Evans on 10/12/24.
//

import SwiftUI
import SwiftUICharts
import PythonKit

struct ContentView: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
//var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    var body: some View {
        
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 24){
                    //Title
                    Text("Overview")
                        .font(.title2)
                        .bold()
                    
                    let data = transactionListVM.accumulateTransactions()
                    let totalExpenses = data.last?.1 ?? 0
                    CardView{
                        
                        ChartLabel(totalExpenses.formatted(.currency(code: "USD")), type: .title)
                            .background(Color.systemBackground)

                        LineChart()
                            .background(Color.systemBackground)

                    }
                    .data(data)
                    .chartStyle(ChartStyle(backgroundColor: Color.backgroundColor, foregroundColor: ColorGradient(Color.iconColor.opacity(0.5), Color.iconColor)))
                    .frame(height: 300)
                                    
                    //Transaction List
                    RecentTransactionList()
                    
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.backgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // notification icon
                ToolbarItem {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.iconColor, .primary)
                }
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.primary)
    }
}


struct ContentView_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    static var previews: some View {
        Group{
            ContentView()
        }
        .environmentObject(transactionListVM)
    }
}
