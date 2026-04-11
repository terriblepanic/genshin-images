//
//  SettingsView.swift
//  genshin images
//
//  Created by Кирилл Паничкин on 4/8/26.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsOn = true
    @State private var selectedRegion = "Ли Юэ"
    @State private var fontSize: Double = 16

    let regions = ["Мондштадт", "Ли Юэ", "Инадзума", "Сумеру", "Фонтейн", "Натлан", "Нодкрай"]

    var body: some View {
        Form {
            Section(header: Text("Общее")) {
                Toggle("Уведомления", isOn: $notificationsOn)
                Picker("Любимый регион", selection: $selectedRegion) {
                    ForEach(regions, id: \.self) { region in
                        Text(region)
                    }
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
