//
//  AppIconsView.swift
//  Todo App
//
//  Created by naswakhansa on 12/09/24.
//

import SwiftUI

struct AppIconsView: View {
    
    @EnvironmentObject var iconSettings: IconNames
    @State private var indexIcon: Int = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(iconSettings.iconNames, id: \.self) { iconName in
                    Button(action: {
                        UIApplication.shared.setAlternateIconName(iconName) { error in
                            if let error = error {
                                print("Error changing app icon: \(error.localizedDescription)")
                            } else {
                                print("Success! You have changed the app icon to \(iconName)")
                            }
                        }
                        
                        
                        print(index)
                    }) {
                        Image(uiImage: UIImage(named: iconName ?? "Blue") ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                            .padding(5)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    AppIconsView().environmentObject(IconNames())
}
