//
//  ContentView.swift
//  Todo App
//
//  Created by naswakhansa on 07/09/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    
    @EnvironmentObject var iconSettings: IconNames
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.name, ascending: true)]) var todos: FetchedResults<Todo>
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    @State private var showingSettingsView: Bool = false
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(self.todos, id: \.self) { todo in
                        HStack {
                            Circle()
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(self.colorize(priority: todo.priority ?? "Normal" ))
                            Text(todo.name ?? "Unknown")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(todo.priority ?? "Unknown")
                                .font(.footnote)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .padding(3)
                                .frame(minWidth: 62)
                                .overlay(
                                    Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
                                )
                        }
                        .padding(.vertical, 10)
                    }
                    .onDelete(perform: deleteTodo)
                }
                .navigationBarTitle("Todo", displayMode: .inline)
                .navigationBarItems(
                    leading: 
                        EditButton().accentColor(themes[self.theme.themeSettings].themeColor),
                    trailing:
                        Button(action: {
                            self.showingSettingsView.toggle()
                        }) {
                            Image(systemName: "paintbrush")
                                .imageScale(.large)
                        }
                        .accentColor(themes[self.theme.themeSettings].themeColor)
                        .sheet(isPresented: $showingSettingsView, content: {
                            SettingsView()
                                .environmentObject(self.iconSettings)
                        })
                )
                
                if todos.count == 0 {
                    EmptyListView()
                }
            }//: ZSTACK
            .sheet(isPresented: $showingAddTodoView, content: {
                AddTodoView().environment(\.managedObjectContext, self.managedObjectContext)
            })
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(Color.blue)
                            .opacity(self.animatingButton ? 0.2 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(Color.blue)
                            .opacity(self.animatingButton ? 0.15 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0)
                            .frame(width: 88, height: 86)
                    }
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    }
                    .accentColor(themes[self.theme.themeSettings].themeColor)
                    .onAppear(perform: {
                        self.animatingButton.toggle()
                    })
                }
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
                ,alignment: .bottomTrailing
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = todos[index]
            managedObjectContext.delete(todo)
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    private func colorize(priority: String) -> Color {
        switch priority {
        case "High":
            return .pink
        case "Normal":
            return .green
        case "Low":
            return .blue
        default:
            return .gray
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
