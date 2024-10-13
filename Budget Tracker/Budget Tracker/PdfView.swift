//
//  ContentView.swift
//  BudgetApp
//
//  Created by Anushka Malpani on 12/10/24.
//

//import SwiftUI
//import FirebaseAnalytics
//import FirebaseStorage // Import Firebase Storage
//
//struct ContentView: View {
//    let storage = Storage.storage()
//    
//    var body: some View {
//        VStack {
//            Text("Welcome to BudgetApp")
//                .padding()
//            Button(action: {
//                uploadTestFileToStorage()
//            }) {
//                Text("Upload File to Storage")
//            }
//            Button(action: {
//                downloadTestFileFromStorage()
//            }) {
//                Text("Download File from Storage")
//            }
//        }
//    }
//    
//    func uploadTestFileToStorage() {
//        let storageRef = storage.reference().child("testFile.txt")
//        let data = "This is a test file".data(using: .utf8)!
//        
//        storageRef.putData(data, metadata: nil) { (metadata, error) in
//            if let error = error {
//                print("Error uploading: \(error)")
//            } else {
//                print("File uploaded successfully")
//            }
//        }
//    }
//    
//    func downloadTestFileFromStorage() {
//        let storageRef = storage.reference().child("testFile.txt")
//        
//        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//            if let error = error {
//                print("Error downloading: \(error)")
//            } else {
//                let text = String(data: data!, encoding: .utf8)
//                print("Downloaded file content: \(text ?? "Error decoding")")
//            }
//        }
//    }
//}

import SwiftUI
import FirebaseAnalytics
import SwiftUICharts

struct PdfView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: URL? // Store the URL of the uploaded PDF
    @EnvironmentObject var transactionListVM: TransactionListViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Text("Upload Bank Statements")
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    // PDF Upload Section
                    Button(action: {
                        showImagePicker.toggle()
                    }) {
                        Text("Upload PDF")
                            .font(.headline)
                            .padding()
                            .background(Color.iconColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .sheet(isPresented: $showImagePicker) {
                        DocumentPicker(selectedURL: $selectedImage) // Present Document Picker
                    }

                    if let selectedImage = selectedImage {
                        Text("Uploaded PDF: \(selectedImage.lastPathComponent)")
                            .padding()
                    }

                    // Expense Overview
                    let data = transactionListVM.accumulateTransactions()
                    let totalExpenses = data.last?.1 ?? 0
                    
//                    // Expense Card View
//                    VStack {
//                        Text(totalExpenses.formatted(.currency(code: "USD"))) // Title label
//
//                        //LineChartView(data: data.map { $1 }, title: "Expenses", legend: "Monthly") // Use LineChartView directly
//                            .frame(height: 300)
//                    }
//                    .background(Color(.systemBackground))
//                    .cornerRadius(10)
//                    .shadow(radius: 5)

                    // Transaction List
                    RecentTransactionList()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.blue, .primary)
                }
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.primary)
    }
}

struct PdfView_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
        let transactionListVM = TransactionListViewModel()
        transactionListVM.transactions = transactionListPreviewData
        return transactionListVM
    }()
    static var previews: some View {
        Group {
            ContentView()
        }
        .environmentObject(transactionListVM)
    }
}

