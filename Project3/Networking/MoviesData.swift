//
//  MoviesData.swift
//  Project3
//
//  Created by Nicolas Lantean on 4/25/19.
//  Copyright © 2019 Nicolas Lantean. All rights reserved.
//

import Foundation
import Alamofire

struct Movie: Codable {
    let title: String
    let genre: [Int]
    let popularity: Double
    let overview: String
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case genre = "genre_ids"
        case image = "poster_path"
        
        case title
        case popularity
        case overview
    }
    
}

struct Genre: Codable {
    let name: String
    let id: Int
}

class MoviesData {
    
    static func getMoovies(completion: @escaping ([Movie]?,Error?) -> Void) {
        AF.request("https://api.themoviedb.org/3/discover/movie/?sort_by=vote_average.asc&api_key=b43c71d0fdf94851c8ee07a60a157a5f").responseJSON { response in
            
            switch response.result {
            case .success(let value):
                if let dict = value as? [String: Any], let list = dict["results"] {
                    if let data = try? JSONSerialization.data(withJSONObject: list) {
                        let decoder = JSONDecoder()
                        let finalData = try! decoder.decode([Movie].self, from: data)
                        completion(finalData, nil)
                    }
                }
            case .failure(let error): completion(nil, error)
            }
        }
    }
    
    static func getGenres(completion: @escaping ([Genre]?,Error?) -> Void) {
        AF.request("https://api.themoviedb.org/3/genre/movie/list?api_key=b43c71d0fdf94851c8ee07a60a157a5f&language=en-US").responseJSON { response in
            
            switch response.result {
            case .success(let value):
                if let dict = value as? [String: Any], let list = dict["genres"] {
                    if let data = try? JSONSerialization.data(withJSONObject: list) {
                        let decoder = JSONDecoder()
                        let finalData = try! decoder.decode([Genre].self, from: data)
                        completion(finalData, nil)
                    }
                }
            case .failure(let error): completion(nil, error)
            }
        }
    }
}
