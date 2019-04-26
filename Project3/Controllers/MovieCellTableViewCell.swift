//
//  MovieCellTableViewCell.swift
//  Project3
//
//  Created by Nicolas Lantean on 4/25/19.
//  Copyright © 2019 Nicolas Lantean. All rights reserved.
//

import UIKit

class MovieCellTableViewCell: UITableViewCell {

    static let cellIdentifier = "MovieCell"
    static let nibName = "MovieCell"
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGendre: UILabel!
    @IBOutlet weak var moviePopularity: UILabel!
    @IBOutlet weak var overview: UILabel!
    

}
