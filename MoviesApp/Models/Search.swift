//
//  Repo.swift
//  MoviesApp
//
//  Created by Armin Spahic on 23/06/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct Search {
    
    let id: Int
    let name: String
    let voteCount: Int
    let voteRating: Double
    let imageURL : String
    let mediaType: String

    init?(object: [String: Any]) {
        
            guard let name = object["title"] as? String ?? object["name"] as? String,
            let id = object["id"] as? Int,
            let voteCount = object["vote_count"] as? Int,
            let voteRating = object["vote_average"] as? Double,
            let imageURL = object["poster_path"] as? String,
            let mediaType = object["media_type"] as? String
            else {
                return nil
        }
        self.id = id
        self.name = name
        self.voteCount = voteCount
        self.voteRating = voteRating
        self.imageURL = imageURL
        self.mediaType = mediaType
    }
    
    init(_ id: Int, _ name: String, _ voteCount: Int, _ voteRating: Double, _ imageURL: String, _ mediaType: String) {
        self.id = id
        self.name = name
        self.voteCount = voteCount
        self.voteRating = voteRating
        self.imageURL = imageURL
        self.mediaType = mediaType
    }
}
