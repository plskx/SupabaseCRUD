//  Date: 5/22/23
//
//  Author: Zai Santillan
//  Github: @plskz


import Foundation

struct Todo: Identifiable, Codable {
    let id: UUID
    let title: String
    let done: Bool
}
