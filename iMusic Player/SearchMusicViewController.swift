//
//  SearchViewController.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 29.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import UIKit
import Alamofire

struct TrackModel {
    let trackName: String
    let artistName: String
}

class SearchMusicViewController: UITableViewController {
    
    private var timer: Timer?
    let searchBarController = UISearchController(searchResultsController: nil)
    
    var trackList = [Track]()
    
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBarController.searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Artist name - \(trackList[indexPath.row].artistName) Atrist track - \(trackList[indexPath.row].trackName)"
        cell.imageView?.image = #imageLiteral(resourceName: "600")
        return cell
    }
    
}

extension SearchMusicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        networkService.fetchTracks(searchText: searchText) { [weak self] (tracks) in
            guard let self = self else { return }
            guard let tracks = tracks else { return }
            self.trackList = tracks.results
            self.tableView.reloadData()
        }
        
        
       
    }
}


