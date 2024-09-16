//
//  SettingsView.swift
//  Todo App
//
//  Created by naswakhansa on 10/09/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iconSettings: IconNames
    
    
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared
    @State private var isThemeChange: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                Form {
                    Section(header: Text("Choose the app icon")) {
                        AppIconsView()
                    }
                    .padding(.vertical, 3)
                    
                    Section(header:
                        HStack {
                            Text("Choose the app theme")
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(themes[self.theme.themeSettings].themeColor)
                        }
                    ) {
                        List {
                            ForEach(themes, id: \.id) { item in
                                Button (action: {
                                    self.theme.themeSettings = item.id
                                    UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                                    self.isThemeChange.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.themeColor)
                                        
                                        Text(item.themeName)
                                    }
                                }
                                .accentColor(Color.primary)
                            }
                        }
                    }.padding(.vertical, 3)
                        .alert(isPresented: $isThemeChange) {
                            Alert(
                                title: Text("SUCCESS!"),
                                message: Text("App has been changed to the \(themes[self.theme.themeSettings].themeName). Now close and restart"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    
                    Section(header: Text("Follow us on social media")) {
                        FormRowLinkView(icon: "globe", color: Color.pink, text: "Website", link: "https://swiftuimasterclass.com")
                        FormRowLinkView(icon: "link", color: Color.blue, text: "X", link: "https://x.com/rrrrrr7746431")
                        FormRowLinkView(icon: "play.rectangle", color: Color.green, text: "Courses", link: "https://www.udemy.com/user/robert-petras")
                    }
                    .padding(.vertical, 3)
                    
                    Section(header: Text("About The Application")) {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Naswa")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Robert Petras")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    }
                    .padding(.vertical, 3)
                }//: Form
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                Text("Copyright © All right reserved.\nBetter Apps ♡ Less Code")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(Color.secondary)
            }//: Vstack
            .navigationBarItems(trailing:
                                    Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            }
            )
            .navigationBarTitle("Settings", displayMode: .inline)
            .background(Color("ColorBackground"))
            
        }//: Navigation
        .accentColor(themes[self.theme.themeSettings].themeColor)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    SettingsView().environmentObject(IconNames())
}
