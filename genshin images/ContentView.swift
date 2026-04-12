//
//  ContentView.swift
//  genshin images
//
//  Created by Кирилл Паничкин on 4/8/26.
//

import SwiftUI

struct ContentView: View {
    // AppStorage сохраняет значения между запусками приложения
    @AppStorage("titleOn") private var titleOn = true
    @AppStorage("selectedRegion") private var selectedRegion: Region = .liyue

    // Передаём в викторину последнего открытого персонажа со страницы списка
    @State private var lastViewedPost: Post? = nil

    var body: some View {
        TabView {
            InfoView(titleOn: titleOn, regionColor: selectedRegion.color, onPostViewed: { post in
                lastViewedPost = post
            })
            .tabItem {
                Label("Персонажи", systemImage: "person.3.fill")
            }

            QuizView(titleOn: titleOn, lastViewedPost: lastViewedPost, regionColor: selectedRegion.color)
                .tabItem {
                    Label("Викторина", systemImage: "questionmark.circle.fill")
                }

            SettingsView(titleOn: $titleOn, selectedRegion: $selectedRegion, regionColor: selectedRegion.color)
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
        }
        .tint(selectedRegion.color)
    }
}
