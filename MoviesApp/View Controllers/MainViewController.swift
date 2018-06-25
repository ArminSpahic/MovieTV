//
//  MainViewController.swift
//  MoviesApp
//
//  Created by Armin Spahic on 22/06/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import RxSwift
import RxCocoa


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func segmentedControlChanged(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            self.navigationItem.title = "Top Movies"
        } else if segmentedControl.selectedSegmentIndex == 1 {
            self.navigationItem.title = "Top TV Shows"
        }
        self.tableView.reloadData()
    }
    var arrayOfMovies = [Movies]()
    var arrayOfTVShows = [TVShows]()
    let globals = Globals()
    var textToSearch = ""
    var repoMovieId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewSetup()
        configureTableView()
        loadData()
        setupNavBar()
    }
    
    func tableviewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customCell")
        //tableView.bounces = false
    }
    
    func setupNavBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resultsController = storyboard.instantiateViewController(withIdentifier: "searchResults") as! ResultsController
        let searchController = UISearchController(searchResultsController: resultsController)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = resultsController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        tableView.separatorStyle = .none
    }
    
    @objc func alertClose(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: NETWORK ALERT POPUP
    func networkErrorAlert() {
    let alert = UIAlertController(title: "Network error", message: "The application will not work properly", preferredStyle: .alert)
    self.present(alert, animated: true, completion:{
    alert.view.superview?.isUserInteractionEnabled = true
    alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(gesture:))))
    })
    }
    
    //MARK: TABLEVIEW DATASOURCE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return arrayOfMovies.count
        }else{
            return arrayOfTVShows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        if segmentedControl.selectedSegmentIndex == 0 {
            
            let movie = arrayOfMovies[indexPath.row]
            customCell.nameLabel.text = movie.title
            customCell.descriptionLabel.text = "Release date: \(movie.description)"
            customCell.numberLabel.text = String(movie.number)
            customCell.votesLabel.text = "Vote rating: \(movie.voteRating) with \(movie.voteCount) votes"
            customCell.cellImageView.kf.setImage(with: URL(string: movie.imageURL))
            return customCell
            
        } else {

            let tvShow = arrayOfTVShows[indexPath.row]
            customCell.nameLabel.text = tvShow.name
            customCell.descriptionLabel.text = "First air date: \(tvShow.overview)"
            customCell.numberLabel.text = String(tvShow.number)
            customCell.votesLabel.text = "Vote rating: \(tvShow.voteRating) with \(tvShow.voteCount) votes"
            customCell.cellImageView.kf.setImage(with: URL(string: tvShow.imageURL))
            return customCell
        }
    }
        
    //MARK: PROVIDING ID FOR DESTINATION VIEW CONTROLLER
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            
            let id = arrayOfMovies[indexPath.row].movieId;
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            vc.setMovieId(id: id)
            vc.navigationItem.title = "Top Movies"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
            let id = arrayOfTVShows[indexPath.row].tvShowId
            let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            vc.setTVShowID(id: id)
            vc.navigationItem.title = "Top TV Shows"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: NETWORKING FOR MOVIES
    func getMovies(url: String, parameters: [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                if let fetchedData: [String: Any] = response.result.value as! [String: Any]? {
                    self.updateMovieData(response: fetchedData)
                }
            } else {
                print("Error getting data \(String(describing: response.result.error))")
                self.networkErrorAlert()
            }
        }
    }

    func updateMovieData(response: [String: Any]) {
        if let responseMovies = response["results"] as! [[String: Any]]? {
            for i in 0..<responseMovies.count {
                let movies = Movies()
                movies.title = responseMovies[i]["title"] as? String ?? ""
                movies.description = responseMovies[i]["release_date"] as? String ?? ""
                movies.number = Int(i + 1)
                movies.voteCount = responseMovies[i]["vote_count"] as? Int ?? 0
                movies.voteRating = responseMovies[i]["vote_average"] as? Double ?? 0.0
                movies.movieId = responseMovies[i]["id"] as? Int ?? 0
                let picture = responseMovies[i]["poster_path"] ?? ""
                movies.imageURL = String.init(format: "%@%@", globals.imageBaseURL ,picture as! String)
                self.arrayOfMovies.append(movies)
                //self.arrayOfMovies.append(Movies(title: name, description: description, number: number, voteCount: voteCount, voteRating:            voteRating, movieId: movieId, imageURL: imageURL))
                if(i == 9){
                    break
                }
            }
            segmentedControl.selectedSegmentIndex = 0;
            self.tableView.reloadData()
        }
    }
    
    //MARK: NETWORKING FOR TVSHOWS
    func getTVShows(url: String, parameters: [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                if let fetchedData: [String: Any] = response.result.value as! [String: Any]? {
                    self.updateTVData(response: fetchedData)
                }
            } else {
                print("Error getting data \(String(describing: response.result.error))")
            }
        }
    }
    
    func updateTVData(response: [String: Any]) {
        if let responseTVShows = response["results"] as! [[String: Any]]? {
            for i in 0..<responseTVShows.count {
                let tvShows = TVShows()
                tvShows.name = responseTVShows[i]["name"] as? String ?? ""
                tvShows.overview = responseTVShows[i]["first_air_date"] as? String ?? ""
                tvShows.number = Int(i + 1)
                tvShows.voteCount = responseTVShows[i]["vote_count"] as? Int ?? 0
                tvShows.voteRating = responseTVShows[i]["vote_average"] as? Double ?? 0.0
                tvShows.tvShowId = responseTVShows[i]["id"] as? Int ?? 0
                let image = responseTVShows[i]["poster_path"] ?? ""
                tvShows.imageURL = String.init(format: "%@%@", globals.imageBaseURL ,image as! String)
                self.arrayOfTVShows.append(tvShows)
                if(i == 9){
                    break
                }
            }
           self.tableView.reloadData()
        }
    }
    
    //MARK: LOADING DATA
    func loadData() {
        let params : [String : String] = ["api_key" : globals.apiKey, "language" : globals.language, "page" : globals.page]
        getMovies(url: globals.moviesURL , parameters: params)
        getTVShows(url: globals.tvShowsURL, parameters: params)
    }
}




