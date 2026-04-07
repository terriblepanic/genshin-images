//
//  InfoDetails.swift
//  genshin images
//
//  Created by Кирилл Паничкин on 4/8/26.
//

import SwiftUI

struct InfoDetails: View {
    var post: Post

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                post.image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)

                Text(post.title)
                    .font(.title)
                    .bold()

                Text(post.description)
                    .font(.body)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(post.title)
    }
}
