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
    @Binding var selectedRegion: Region
    var regionColor: Color

    // fontSize нигде не сохраняется — сбросится при перезапуске, это нужно только для превью
    @State private var fontSize: Double = 16

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Общее")) {
                    Text(colorScheme == .dark ? "Dark Theme enabled" : "Light Theme enabled")
                        .foregroundColor(regionColor)

                    Picker("Любимый регион", selection: $selectedRegion) {
                        ForEach(Region.allCases) { region in
                            Text(region.localizedName).tag(region)
                        }
                    }
                }

                Section(header: Text("Навигация")) {
                    Toggle("Показывать заголовок страниц", isOn: $titleOn)

                    if titleOn {
                        Text("Заголовок: «Персонажи Геншин»")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }

                Section(header: Text("Внешний вид")) {
                    Text("Размер текста: \(Int(fontSize))")
                    Slider(value: $fontSize, in: 12...24, step: 1)
                    Text("Так будет выглядеть текст в приложении")
                        .font(.system(size: fontSize))
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle(titleOn ? "Настройки" : "")
        }
    }
}
