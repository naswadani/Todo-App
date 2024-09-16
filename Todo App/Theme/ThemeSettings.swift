//
//  ThemeSettings.swift
//  Todo App
//
//  Created by naswakhansa on 16/09/24.
//

import SwiftUI

final public class ThemeSettings: ObservableObject {
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
        }
    }
    
    private init() {}
    public static let shared = ThemeSettings()
}
