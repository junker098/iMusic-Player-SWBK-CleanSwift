//
//  SearchModels.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 01.10.2020.
//  Copyright (c) 2020 Yuri Mogorita. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getTracks(searchText: String)
      }
    }
    struct Response {
      enum ResponseType {
        case presentTracks(responseTracks: SearchResponse)
        case presentFooterView
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayTracks(track: SearchViewModel)
        case displayFooterView
      }
    }
  }
}

struct SearchViewModel {
    struct Cell: TrackCellViewModel {
        var artistName: String
        var iconURLString: String?
        var trackName: String
        var collectionName: String
        var previewURL: String?
    }
    
    let cells: [Cell]
}
