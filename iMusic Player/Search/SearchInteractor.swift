//
//  SearchInteractor.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 01.10.2020.
//  Copyright (c) 2020 Yuri Mogorita. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    
    var networkService = NetworkService()
    var presenter: SearchPresentationLogic?
    var service: SearchService?
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil {
            service = SearchService()
        }
        
        switch request {
        case .getTracks(searchText: let searchText):
            print("Get tracks")
            presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
            networkService.fetchTracks(searchText: searchText) { [weak self] (responseTracks) in
                guard let self = self else { return }
                guard let responseTracks = responseTracks else { return }
                self.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(responseTracks: responseTracks))
            }
        }
    }
}
