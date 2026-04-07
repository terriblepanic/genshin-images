//
//  Post.swift
//  genshin images
//
//  Created by Кирилл Паничкин on 4/8/26.
//

import SwiftUI

struct Post: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var image: Image
}
