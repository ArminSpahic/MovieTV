//
//  MovieInfoViewController.swift
//  MoviesApp
//
//  Created by Armin Spahic on 22/06/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var movieId: Int = 0 {
        didSet {
            loadMovieDetails()
        }
    }
    var tvShowId: Int = 0 {
        didSet {
            loadTVDetails()
        }
    }
    let details = Details()
    let globals = Globals()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
   func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        backButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setMovieId(id: Int) {
        self.movieId = id
    }
    
    func setTVShowID(id: Int) {
        self.tvShowId = id
    }
    
    @objc func alertClose(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func networkErrorAlert() {
        let alert = UIAlertController(title: "Network error", message: "Error fetching data", preferredStyle: .alert)
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(gesture:))))
        })
    }
    
    //MARK: MOVIE DETAILS NETWORKING
    func getMovieDetails(url: String, parameters: [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
               // print("Got the movie data!")
                let detailedInfo : JSON = JSON(response.result.value!)
                 self.updateMovieDetails(json: detailedInfo)
                self.activityIndicator.stopAnimating()
            } else {
                print("Error \(String(describing: response.result.error))")
                self.networkErrorAlert()
                
            }
        }
    }
    
    func updateMovieDetails(json : JSON){
        
        if let movieName = json["title"].string  {
            details.name = movieName
            details.overview = json["overview"].stringValue
            details.imageURL = json["backdrop_path"].stringValue 
            let genreExist = json["genres"][0]["name"].string ?? ""
            details.genre = genreExist
            updateUIWithDetailedInfo()
        } else {
            print("Movie Unavailable")
            nameLabel.text = "Movie not available"
        }
    }
    
    //MARK: TV SHOW DETAILS NETWORKING
    func getTVDetails(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                //print("Got the movie data!")
                let detailedInfo : JSON = JSON(response.result.value!)
                 self.updateTVShowDetails(json: detailedInfo)
                self.activityIndicator.stopAnimating()
            } else {
                print("Error \(String(describing: response.result.error))")
                self.networkErrorAlert()
                
            }
        }
    }

    func updateTVShowDetails(json: JSON) {
        if let tvShowName = json["name"].string {
            details.name = tvShowName
            details.overview = json["overview"].stringValue
            details.imageURL = json["backdrop_path"].stringValue
            let genreExist = json["genres"][0]["name"].string ?? ""
            details.genre = genreExist
            updateUIWithDetailedInfo()
        } else {
                print("Movie Unavailable")
                nameLabel.text = "Movie not available"
            }
        }
    
    //MARK: UPDATING UI WITH DETAILED INFO
    func updateUIWithDetailedInfo() {
        
        nameLabel.text = details.name
        descriptionLabel.text = details.overview
        genreLabel.text = "Genre: \(details.genre)"
        let url = URL.init(string: "http://image.tmdb.org/t/p/w1280/\(details.imageURL)")
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
    }
    
    //MARK: LOADING MOVIE DETAILS
    func loadMovieDetails() {
        let movieDetailedURL = globals.movieDetailsURL + "/\(movieId)"
        let params : [String : String] = ["api_key" : globals.apiKey, "language" : globals.language, ]
        getMovieDetails(url: movieDetailedURL , parameters: params)
        
        
        }
    
    //MARK: LOADING TV SHOW DETAILS
    func loadTVDetails() {
        let tvShowDetailedURL = globals.tvShowDetailsURL + "/\(tvShowId)"
        let params : [String : String] = ["api_key" : globals.apiKey, "language" : globals.language, ]

        getTVDetails(url: tvShowDetailedURL, parameters: params)
    }
    

}


