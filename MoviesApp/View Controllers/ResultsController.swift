//
//  ResultsController.swift
//  MoviesApp
//
//  Created by Armin Spahic on 23/06/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ResultsController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchBar = searchController.searchBar
        setRxQuery()
    }
    
    private let bag = DisposeBag()
    var searchBar : UISearchBar?
    var repoId = 0
    var mediaType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
        setRxSelectionOption()
    }
    
    private func setupTableView() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.tableFooterView = UIView()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //MARK: RXSWIFT LIVE SEARCH METHOD
    func setRxSelectionOption() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rx.modelSelected(Search.self)
            .subscribe(onNext: { (item) in
                print(item.id)
                self.mediaType = item.mediaType
                self.repoId = item.id
                let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
                if self.mediaType == "movie" {
                    destinationVC.setMovieId(id: self.repoId)
                    destinationVC.navigationItem.title = "Movie"
                } else {
                    destinationVC.setTVShowID(id: self.repoId)
                    destinationVC.navigationItem.title = "TV Show"
                }
                
                self.presentingViewController?.navigationController?.pushViewController(destinationVC, animated: true)
            })
            .disposed(by: bag)
    }
    
    func setRxQuery(){
        tableView.delegate = nil
        tableView.dataSource = nil
        searchBar?.rx.text
            .orEmpty
            .filter { query in
                return query.count > 2
            }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map { query in
                let apiUrl = URL(string: "https://api.themoviedb.org/3/search/multi?api_key=\(Globals.init().apiKey)&query=" + query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
                return URLRequest(url: apiUrl)
            }
            .flatMapLatest { request in
                return URLSession.shared.rx.json(request: request)
                    .catchErrorJustReturn([])
            }
            .map { json -> [Search] in
                guard let json = json as? [String: Any],
                    let items = json["results"] as? [[String: Any]]
                    else {
                        return []
                        
                }
                return items.compactMap(Search.init)
            }
            .bind(to: tableView.rx.items) { tableView, row, search in
                let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCell
                tableView.separatorStyle = .none
                cell.nameLabel.text = search.name
                cell.votesLabel.text = "Vote rating: \(search.voteRating) with \(search.voteCount) votes"
                cell.descriptionLabel.text = "Media type: \(search.mediaType.uppercased())"
                cell.cellImageView?.kf.setImage(with: URL(string: "http://image.tmdb.org/t/p/w185/\(search.imageURL)"))
                return cell
            }
            .disposed(by: bag)
    }
}
    

