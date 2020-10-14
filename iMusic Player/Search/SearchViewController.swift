//
//  SearchViewController.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 01.10.2020.
//  Copyright (c) 2020 Yuri Mogorita. All rights reserved.
//

import UIKit


protocol SearchDisplayLogic: class {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {
    
    let searchBarController = UISearchController(searchResultsController: nil)
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var timer: Timer?
    private var searchViewModel = SearchViewModel(cells: [])
    private lazy var footerView = FooterView()
    
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = SearchInteractor()
        let presenter             = SearchPresenter()
        let router                = SearchRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setup()
        setupTableVIew()
    }
    
    private func setupTableVIew() {
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TrackCell.reuseIdentifire)
        tableView.tableFooterView = footerView
    }
    
    
    func setupSearchBar() {
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBarController.searchBar.delegate = self
        searchBarController.obscuresBackgroundDuringPresentation = false
    }
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayTracks(track: let searchViewModel):
            self.searchViewModel = searchViewModel
            tableView.reloadData()
//            print("viewModel .display tracks")
            footerView.stopLoader()
        case .displayFooterView:
            footerView.showLoader()
        }
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseIdentifire , for: indexPath) as! TrackCell
        let searchModel = searchViewModel.cells[indexPath.row]
        cell.setupCell(trackCellViewModel: searchModel)
        cell.trackImage.backgroundColor = .red
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter text in search bar..."
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchModel = searchViewModel.cells[indexPath.row]
        
        tabBarDelegate?.maximizeTrackDetailController(viewModel: searchModel)
//        print("searchViewModel.cells: \(searchModel)")
// 
//        trackDetailsVIew.delegate = self
//        trackDetailsVIew.set(viewModel: searchModel)
//        window?.addSubview(trackDetailsVIew)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchViewModel.cells.count > 0 ? 0 : 250
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchText: searchText))
        })
    }
}

// MARK: - TrackMovingDelegate

extension SearchViewController: TrackMovingDelegate {
    
    func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        tableView.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath
        
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == searchViewModel.cells.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = searchViewModel.cells.count - 1
            }
        }
        tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let viewModelCell = searchViewModel.cells[nextIndexPath.row]
        return viewModelCell
    }
    
    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        getTrack(isForwardTrack: false)
    }
    
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell? {
        getTrack(isForwardTrack: true)
        
    }
    
}
