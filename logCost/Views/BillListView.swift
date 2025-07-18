//
//  BillListView.swift
//  logCost
//
//  Created by McLin on 2025/7/18.
//

import SwiftUI
import SwiftData
import Foundation

struct BillListView: View {
    @Query private var transitionsSource: [Transitions]
    @Query private var accountsSource: [Accounts]
    @EnvironmentObject var systemSetting: SystemSettings
    @State private var selectedTransition: Transitions? = nil
    
    private var transitions: [Transitions] {
        #if DEBUG
        return transitionsSource.isEmpty ? Transitions.samples : transitionsSource
        #else
        return transitionsSource
        #endif
    }
    
    private var accounts: [Accounts] {
        #if DEBUG
        return accountsSource.isEmpty ? Accounts.samples : accountsSource
        #else
        return accountsSource
        #endif
    }
    
    var body: some View {
        if transitions.isEmpty {
            Text("暂无记录")
                .foregroundStyle(.secondary)
        } else {
            let grouped = Dictionary(grouping: transitions) { Calendar.current.startOfDay(for: $0.time) }
            let sortedDates = grouped.keys.sorted(by: >)
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(sortedDates, id: \.self) { date in
                        // Date header
                        Text(date.formatted(
                            .dateTime.year().month().day()
                            .locale(Locale(identifier: "zh_CN"))
                        ))
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)

                        // Entries for this date
                        ForEach(grouped[date]!) { transition in
                            VStack {
                                HStack {
                                    Text(transition.name)
                                    Spacer()
                                    Text(String(format: "%.2f", transition.value))
                                }
                                HStack {
                                    Text(transition.account.name)
                                    Spacer()
                                    Text(transition.time.formatted(
                                        .dateTime.hour().minute()
                                        .locale(Locale(identifier: "zh_CN"))
                                    ))
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedTransition = transition
                            }
                        }
                    }
                }
                .padding()
            }
            .sheet(item: $selectedTransition) { transition in
                TransitionDetailView(transition: transition)
            }
        }
    }
}


struct TransitionDetailView: View {
    @Bindable var transition: Transitions
    @Environment(\.dismiss) private var dismiss
    @Query private var accountsSource: [Accounts]
    
    @State private var originalValue: Double = 0
    @State private var originalIsExpanse: Bool = true
    
    private var accounts: [Accounts] {
        #if DEBUG
        return accountsSource.isEmpty ? Accounts.samples : accountsSource
        #else
        return accountsSource
        #endif
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section() {
                    Picker("账单类型", selection: $transition.isExpanse)
                    {
                        Text("支出").tag(true)
                        Text("收入").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: transition.isExpanse) { oldValue, isExpense in
                        // revert original impact
                        if originalIsExpanse {
                            transition.account.balance += originalValue
                        } else {
                            transition.account.balance -= originalValue
                        }
                        // apply new impact
                        if isExpense {
                            transition.account.balance -= transition.value
                        } else {
                            transition.account.balance += transition.value
                        }
                        originalIsExpanse = isExpense
                    }
                    HStack {
                        TextField("点击输入账单内容", text: $transition.name)
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                        Spacer(minLength: 30)
                        HStack () {
                            TextField("0.00", value: $transition.value, format: .number.precision(.fractionLength(2)))
                                .multilineTextAlignment(.trailing)
                                .onChange(of: transition.value) { oldValue, newValue in
                                    let diff = newValue - originalValue
                                    if transition.isExpanse {
                                        transition.account.balance -= diff
                                    } else {
                                        transition.account.balance += diff
                                    }
                                    originalValue = newValue
                                }
                            Text("CNY")
                                .padding(.trailing)
                                .font(.footnote)
                                .fontWeight(.bold)
                        }
                        
                    }
                }
                
                Picker("账户", selection: $transition.account) {
                    ForEach(accounts) { account in
                        Text(account.name).tag(account)
                    }
                }
                
                
                DatePicker("时间", selection: $transition.time, displayedComponents: [.date, .hourAndMinute])
                TextField("描述", text: $transition.desc)
            }
            .navigationTitle("账单详情")
            .toolbar {
                Button("关闭") {
                    dismiss()
                }
            }
            .onAppear {
                originalValue = transition.value
                originalIsExpanse = transition.isExpanse
            }
        }
    }
    
    
}

#Preview {
    TransitionDetailView(transition: Transitions.samples.first!)
}
