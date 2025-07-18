//
//  AssertsView.swift
//  logCost
//
//  Created by McLin on 2025/7/18.
//


import SwiftUI
import SwiftData

struct AssertsView: View {
    @Query private var accountsSource: [Accounts]
    @State private var selectedAccount: Accounts? = nil
    
    private var accounts: [Accounts] {
        #if DEBUG
        return accountsSource.isEmpty ? Accounts.samples : accountsSource
        #else
        return accountsSource
        #endif
    }

    var body: some View {
        
        
        ScrollView {
            VStack() {
                ForEach(accounts) { account in
                    VStack() {
                        Text(account.name)
                            .font(.headline)
                        Text(String(format: "%.2f", account.balance))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedAccount = account
                    }
                }
            }
        }
    }
}

#Preview {

    AssertsView()
}
