//
//  Movies.swift
//  MoviesApp
//
//  Created by Armin Spahic on 20/06/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import Foundation



class Movies {
    
    let title: String
    let description: String
    let number: Int
    let voteCount: Int
    let voteRating: Double
    
    //let image: String
    
    
    init(title: String, description: String, number: Int, voteCount: Int, voteRating: Double ) {//, image: String) {
        self.title = title
        self.description = description
        self.number = number
        self.voteCount = voteCount
        self.voteRating = voteRating
       // self.image = image
        
    }
    
}
