//
//  SearchPresenter.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 01.10.2020.
//  Copyright (c) 2020 Yuri Mogorita. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
  func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
  weak var viewController: SearchDisplayLogic?
  
  func presentData(response: Search.Model.Response.ResponseType) {
    switch response {
    case .presentTracks(responseTracks: let searchResult):
        print("Presented tracks")
        let cell = searchResult.results.map { (track) in
            cellViewModel(from: track)
        }
        let searchViewModel = SearchViewModel.init(cells: cell)
        viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayTracks(track: searchViewModel))
    case .presentFooterView:
        viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayFooterView)
    }
  }
  
    private func cellViewModel(from track: Track) -> SearchViewModel.Cell {
        
        return SearchViewModel.Cell(artistName: track.artistName,
                                    iconURLString: track.artworkUrl100 ?? "",
                                    trackName: track.trackName,
                                    collectionName: track.collectionName ?? "",
                                    previewURL: track.previewUrl)
    }
}
