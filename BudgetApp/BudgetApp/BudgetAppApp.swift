// BudgetAppApp.swift

import SwiftUI

@main
struct BudgetAppApp: App {
    init() {
        // Set navigation bar appearance to black
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().tintColor = .black // Back button color
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .accentColor(.black) // Set accent color to black
        }
    }
}
