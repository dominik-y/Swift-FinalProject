//
//  Comment.swift
//  BookApp
//
//  Created by Dominik Maric on 09.12.2021..
//

import Foundation

struct Comment: Codable,Hashable{
    var bookName: String
    var name: String
    var surname: String
    var comment: String
}
