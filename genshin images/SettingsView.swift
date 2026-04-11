//
//  SettingsView.swift
//  genshin images
//
//  Created by Кирилл Паничкин on 4/8/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var titleOn: Bool
    @Binding var selectedRegion: String
    var regionColor: Color

    let regions = ["Мондштадт", "Ли Юэ", "Инадзума", "Сумеру", "Фонтейн", "Натлан", "Нодкрай"]

    @State private var fontSize: Double = 16

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Общее")) {
                    Text(colorScheme == .dark ? "Dark Theme enabled" : "Light Theme enabled")
                        .foregroundColor(regionColor)

                    Picker("Любимый регион", selection: $selectedRegion) {
                        ForEach(regions, id: \.self) { region in
                            Text(region)
                        }
                    }
                }

                Section(header: Text("Навигация")) {
                    Toggle("Navigation title enabled", isOn: $titleOn)

                    if titleOn {
                        Text("Navigation title enabled")
                    }
                }

                Section(header: Text("Внешний вид")) {
                    Text("Размер текста: \(Int(fontSize))")
                    Slider(value: $fontSize, in: 12...24, step: 1)
                }
            }
            .navigationTitle("Настройки")
        }
    }
}
