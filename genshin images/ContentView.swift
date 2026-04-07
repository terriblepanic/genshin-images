//
//  ContentView.swift
//  genshin images
//
//  Created by Кирилл Паничкин on 4/8/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            InfoView()
                .tabItem {
                    Label("Персонажи", systemImage: "person.3.fill")
                }

            HelloView()
                .tabItem {
                    Label("Hello", systemImage: "hand.wave.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
        }
    }
}
