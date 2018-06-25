//
//  MainViewController.swift
//  MoviesApp
//
//  Created by Armin Spahic on 20/06/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func segmentedControlChanged(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    let apiKey = "1fc5ecb32d383543b855121f667b3a4c"
    let language = "en-US"
    let page = "1"
    let moviesURL = "https://api.themoviedb.org/3/movie/top_rated"
    let tvShowsURL = "https://api.themoviedb.org/3/tv/top_rated"
    let imageBaseURL = "http://image.tmdb.org/t/p/w185"
    var arrayOfMovies = [Movies]()
    var arrayOfTVShows = [TVShows]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "movieCell")
        tableView.register(UINib(nibName: "TVShowCell", bundle: nil), forCellReuseIdentifier: "tvCell")
        configureTableView()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        //tableView.separatorStyle = .none
    }
    
    //MARK: TableViewDatasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return arrayOfMovies.count
        }else{
            return arrayOfTVShows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            let movieCell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! CustomMovieCell
            movieCell.movieTitle.text = arrayOfMovies[indexPath.row].title
            movieCell.movieDescription.text = "Release date: \(arrayOfMovies[indexPath.row].description)"
            movieCell.movieNumber.text = String(arrayOfMovies[indexPath.row].number)
            movieCell.voteLabel.text = "Vote rating: \(arrayOfMovies[indexPath.row].voteRating) with \(arrayOfMovies[indexPath.row].voteCount) votes"
            print(arrayOfMovies[indexPath.row].imageURL)
            movieCell.movieImageView.kf.setImage(with: URL(string: arrayOfMovies[indexPath.row].imageURL))
            return movieCell
        }else{
            let tvCell = tableView.dequeueReusableCell(withIdentifier: "tvCell", for: indexPath) as! TVShowCell
            tvCell.tvShowName.text = arrayOfTVShows[indexPath.row].name
            tvCell.tvShowDescription.text = "First air date: \(arrayOfTVShows[indexPath.row].overview)"
            tvCell.tvShowNumber.text = String(arrayOfTVShows[indexPath.row].number)
            tvCell.tvShowVotes.text = "Vote rating: \(arrayOfTVShows[indexPath.row].voteRating) with \(arrayOfTVShows[indexPath.row].voteCount) votes"
            tvCell.tvImageView.kf.setImage(with: URL(string: arrayOfTVShows[indexPath.row].imageURL))
            //tvCell.movieImageView.kf.setImage(with: URL(string: ""))
            return tvCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            let id = arrayOfMovies[indexPath.row].movieId;
            let vc = storyboard?.instantiateViewController(withIdentifier: "MovieInfoViewController") as! MovieInfoViewController
            vc.setMovieId(id: id)
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
        }
    }
    
    //MARK: Networking for Movies
    
    func getData(url: String, parameters: [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                if let fetchedData: [String: Any] = response.result.value as! [String: Any]? {
                    
                    self.updateMovieData(response: fetchedData)
                    
                  
                }
            } else {
                print("Error getting data \(String(describing: response.result.error))")
                
            }
        }
    }
    
    func get2ndData(url: String, parameters: [String : String]){
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
    
    func updateMovieData(response: [String: Any]) {
        if let responseMovies = response["results"] as! [[String: Any]]? {
            for i in 0..<responseMovies.count {
                let name = responseMovies[i]["title"]
                let description = responseMovies[i]["release_date"]
                let number = Int(i + 1)
                let voteCount = responseMovies[i]["vote_count"]
                let voteRating = responseMovies[i]["vote_average"]
                let movieId = responseMovies[i]["id"]
                let imageURL = String.init(format: "%@%@", imageBaseURL ,responseMovies[i]["poster_path"] as! String)
                print(imageURL)
                self.arrayOfMovies.append(Movies(title: name as! String, description: description as! String, number: number, voteCount: voteCount as! Int, voteRating: voteRating as! Double, movieId: movieId as! Int, imageURL: imageURL))
                if(i == 9){
                    break
                }
            }
            segmentedControl.selectedSegmentIndex = 0;
            self.tableView.reloadData()
        }
        
    }
    
    func updateTVData(response: [String: Any]) {
        if let responseMovies = response["results"] as! [[String: Any]]? {
            for i in 0..<responseMovies.count {
                let name = responseMovies[i]["name"]
                let description = responseMovies[i]["first_air_date"]
                let number = Int(i + 1)
                let voteCount = responseMovies[i]["vote_count"]
                let voteRating = responseMovies[i]["vote_average"]
                let imageURL = String.init(format: "%@%@", imageBaseURL ,responseMovies[i]["poster_path"] as! String)
                self.arrayOfTVShows.append(TVShows(name: name as! String, overview: description as! String, number: number, voteCount: voteCount as! Int, voteRating: voteRating as! Double, imageURL: imageURL))
                if(i == 9){
                    break
                }
            }
//            self.tableView.reloadData()
        }
    }
    
    func loadData() {
        let params : [String : String] = ["api_key" : apiKey, "language" : language, "page" : page]
        getData(url: moviesURL , parameters: params)
        get2ndData(url: tvShowsURL, parameters: params)
    }
    
}
