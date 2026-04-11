//
//  InfoView.swift
//  genshin images
//
//  Created by Кирилл Паничкин on 4/8/26.
//

import SwiftUI

struct InfoView: View {
    var titleOn: Bool
    var regionColor: Color

    var body: some View {
        NavigationView {
            List(posts) { post in
                NavigationLink(destination: InfoDetails(post: post)) {
                    InfoRow(post: post)
                }
            }
            .navigationTitle(titleOn ? "Персонажи Геншин" : "")
        }
        .tint(regionColor)
    }
}
