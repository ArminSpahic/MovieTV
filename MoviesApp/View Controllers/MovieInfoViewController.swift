//
//  MovieInfoViewController.swift
//  MoviesApp
//
//  Created by Armin Spahic on 21/06/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class MovieInfoViewController: UIViewController {

    var movieId: Int = 0
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL.init(string: "http://image.tmdb.org/t/p/w185/5JYzfyKBwReaQ41WFhqXgOZnPWV.jpg")
        imageView.kf.setImage(with: url)
        // Do any additional setup after loading the view.
    }
    
    func setMovieId(id: Int) {
        self.movieId = id
        print(movieId)
        
        
    }

  

}
