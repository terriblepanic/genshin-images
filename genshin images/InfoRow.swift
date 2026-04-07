//
//  InfoRow.swift
//  genshin images
//
//  Created by Кирилл Паничкин on 4/8/26.
//

import SwiftUI

struct InfoRow: View {
    var post: Post

    var body: some View {
        HStack {
            post.image
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .cornerRadius(8)
                .clipped()

            Text(post.title)
                .font(.headline)
        }
    }
}
