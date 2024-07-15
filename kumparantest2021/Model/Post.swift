//
//  Post.swift
//  kumparantest2021
//
//  Created by irfan wahendra on 14/07/24.
//

import Foundation

struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let company: Company
}

struct Company: Codable {
    let name: String
}

