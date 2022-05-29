//
//  Credit_Card_Spending_Money_TrackerApp.swift
//  Credit Card Spending Money Tracker
//
//  Created by Nkosi Yafeu on 5/28/22.
//

import SwiftUI

@main
struct Credit_Card_Spending_Money_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
