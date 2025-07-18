//
//  SystemSettings.swift
//  logCost
//
//  Created by McLin on 2025/7/18.
//

import Foundation
import SwiftUI
import Combine

class SystemSettings: ObservableObject {
    @Published var navigationTabChosen: Int = 1
    // "1" for BillListView; "2" for AssertsView; "3" for AnalysisView
}
