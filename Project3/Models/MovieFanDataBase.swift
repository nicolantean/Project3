//
//  MovieFanDataBase.swift
//  Project3
//
//  Created by Nicolas Lantean on 4/26/19.
//  Copyright © 2019 Nicolas Lantean. All rights reserved.
//

import Foundation
import RealmSwift

class GenreObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
}

class MovieObject: Object {
    
    @objc dynamic var title = ""
    var genre = List<Int>()
    @objc dynamic var popularity = 0.0
    @objc dynamic var overview = ""
    @objc dynamic var image: String? = ""
    
}

