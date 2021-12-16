//
//  Book.swift
//  BookApp
//
//  Created by Dominik Maric on 08.12.2021..
//

import Foundation

struct Book: Codable, Hashable{
    var author: String
    var description: String
    var publisher: String
    var rank : Int
    var title: String
    var url : String
    var commNum: Int
    var likeNum: Int
}
