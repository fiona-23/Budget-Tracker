//
//  PreviewData.swift
//  Project DubHacks Curr
//
//  Created by Fiona Evans on 10/12/24.
//

import Foundation

var transactionPreviewData = Transaction(id: 1, date: "10/12/2024", merchant: "University of Washington", amount: 4000.0, categoryId: 801, isExpense: true)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)
