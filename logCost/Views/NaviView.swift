//
//  NavigationView.swift
//  logCost
//
//  Created by McLin on 2025/7/18.
//

import SwiftUI
import SwiftData

struct NaviView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var systemSetting: SystemSettings
    var body: some View {
        //
        TabView(selection: $systemSetting.navigationTabChosen) {
            Tab.init("账单", systemImage: "text.page.fill", value: 1){
                NavigationStack {
                    BillListView()
                        .navigationTitle("账单")
                }
            }
            
            //
            
            Tab.init("资产", systemImage: "creditcard.fill", value: 2) {
                NavigationStack {
                    AssertsView()
                        .navigationTitle("资产")
                }
            }
            
        }
    }
}

#Preview {

    NaviView()
        .environmentObject(SystemSettings())
        .modelContainer(for: [Transitions.self, Accounts.self])
}
