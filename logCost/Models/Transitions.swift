//
//  File.swift
//  logCost
//
//  Created by McLin on 2025/7/18.
//

import Foundation
import SwiftData

@Model
class Accounts {
    var name: String
    var balance: Double

    init(name: String, balance: Double) {
        self.name = name
        self.balance = balance
    }
}

@Model
class Transitions {
    var name: String
    var value: Double
    var time: Date
    var isExpanse: Bool
    var desc: String
    @Relationship var account: Accounts
    
    init(name: String, value: Double, time: Date, isExpanse: Bool, desc: String, account: Accounts) {
        self.name = name
        self.value = value
        self.time = time
        self.isExpanse = isExpanse
        self.desc = desc
        self.account = account
        
    }
}

#if DEBUG
extension Accounts {
    /// 默认示例账户
    static let samples: [Accounts] = [
        Accounts(name: "示例账户", balance: 1000.0),
        Accounts(name: "示例账户2", balance: 10200.0)
        ]
}

extension Transitions {
    /// 默认示例数据列表
    static let samples: [Transitions] = [
        Transitions(name: "午餐", value: 45.0, time: Calendar.current.date(byAdding: .hour, value: -5, to: Date())!, isExpanse: true, desc: "午餐消费", account: Accounts.samples[0]),
        Transitions(name: "工资", value: 8000.0, time: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, isExpanse: false, desc: "月度工资", account: Accounts.samples[1]),
        Transitions(name: "交通", value: 20.0, time: Calendar.current.date(byAdding: .hour, value: 3, to: Date())!, isExpanse: true, desc: "公交地铁", account: Accounts.samples[0])
    ]
}
#endif
