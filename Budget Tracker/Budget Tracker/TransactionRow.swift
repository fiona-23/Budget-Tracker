//
//  Untitled.swift
//  Project DubHacks Curr
//
//  Created by Fiona Evans on 10/12/24.
//

import SwiftUI
import SwiftUIFontIcon

struct TransactionRow: View {
    var transaction: Transaction
    
    var body: some View {
        HStack(spacing: 20) {
            // Transaction Category Icon
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.iconColor.opacity(0.3))
                .frame(width: 44, height: 44)
                .overlay {
                    FontIcon.text(.awesome5Solid(code: transaction.icon), fontsize: 24, color: Color.iconColor)
                }
                
            VStack(alignment: .leading, spacing: 6){
                // Transaction Merchant
                Text(transaction.merchant)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                
                // Transaction Category
                Text(Date(), format: .dateTime.year().month().day())
                    .font(.footnote)
                    .foregroundColor(.secondary)
                

                //Transaction Date
                Text(transaction.dateParsed, format: .dateTime.month().day().year())
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Text(transaction.amount, format: .currency(code: "USD"))
                .bold()
                .foregroundColor(Color.textColor)
        }
        //Spacer()
        
        .padding([.top, .bottom], 8)
    }
    
}
    struct TransactionRow_Previews: PreviewProvider {
        static var previews: some View {
            Group{
                TransactionRow(transaction: transactionPreviewData)
            }
        }
    }
    

