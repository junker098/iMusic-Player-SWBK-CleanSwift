//
//  SearchResponse.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 30.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var artistName: String
    var trackName: String
    var collectionName: String?
    var artworkUrl100: String?
    var previewUrl: String?
}
