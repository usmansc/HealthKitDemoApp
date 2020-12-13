//
//  HealthKitDemoApp.swift
//  HealthKitDemoApp
//
//  Created by Lukas Schmelcer on 12/12/2020.
//

import SwiftUI

@main
struct HealthKitDemoAppApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel.init())
        }
    }
}
