//
//  Region.swift
//  genshin images
//
//  Created by Кирилл Паничкин on 4/12/26.
//

import SwiftUI

enum Region: String, CaseIterable, Identifiable {
    case mondstadt = "mondstadt"
    case liyue     = "liyue"
    case inazuma   = "inazuma"
    case sumeru    = "sumeru"
    case fontaine  = "fontaine"
    case natlan    = "natlan"
    case nodkray   = "nodkray"

    var id: String { rawValue }

    var localizedName: String {
        switch self {
        case .mondstadt: return "Мондштадт"
        case .liyue:     return "Ли Юэ"
        case .inazuma:   return "Инадзума"
        case .sumeru:    return "Сумеру"
        case .fontaine:  return "Фонтейн"
        case .natlan:    return "Натлан"
        case .nodkray:   return "Нодкрай"
        }
    }

    var color: Color {
        switch self {
        case .mondstadt: return Color(red: 0.494, green: 0.784, blue: 0.890)
        case .liyue:     return Color(red: 0.961, green: 0.651, blue: 0.137)
        case .inazuma:   return Color(red: 0.482, green: 0.184, blue: 0.745)
        case .sumeru:    return Color(red: 0.176, green: 0.620, blue: 0.373)
        case .fontaine:  return Color(red: 0.102, green: 0.420, blue: 0.604)
        case .natlan:    return Color(red: 0.851, green: 0.310, blue: 0.169)
        case .nodkray:   return Color(red: 0.722, green: 0.831, blue: 0.910)
        }
    }
}
