//
//  ContentView.swift
//  genshin images
//
//  Created by Кирилл Паничкин on 4/8/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("titleOn") private var titleOn = true
    @AppStorage("selectedRegion") private var selectedRegion = "Ли Юэ"

    var regionColor: Color {
        switch selectedRegion {
        case "Мондштадт": return Color(red: 0.494, green: 0.784, blue: 0.890)
        case "Ли Юэ":     return Color(red: 0.961, green: 0.651, blue: 0.137)
        case "Инадзума":  return Color(red: 0.482, green: 0.184, blue: 0.745)
        case "Сумеру":    return Color(red: 0.176, green: 0.620, blue: 0.373)
        case "Фонтейн":   return Color(red: 0.102, green: 0.420, blue: 0.604)
        case "Натлан":    return Color(red: 0.851, green: 0.310, blue: 0.169)
        case "Нодкрай":   return Color(red: 0.722, green: 0.831, blue: 0.910)
        default:          return .accentColor
        }
    }

    var body: some View {
        TabView {
            InfoView(titleOn: titleOn, regionColor: regionColor)
                .tabItem {
                    Label("Персонажи", systemImage: "person.3.fill")
                }

            HelloView()
                .tabItem {
                    Label("Hello", systemImage: "hand.wave.fill")
                }

            SettingsView(titleOn: $titleOn, selectedRegion: $selectedRegion, regionColor: regionColor)
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
        }
        .tint(regionColor)
    }
}
