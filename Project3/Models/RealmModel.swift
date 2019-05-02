//
//  RealmModel.swift
//  Project3
//
//  Created by Nicolas Lantean on 4/30/19.
//  Copyright © 2019 Nicolas Lantean. All rights reserved.
//

import Foundation
import RealmSwift

class RealmModel {
    
    func saveMovies(_ movies: [Movie]?, _ error: Error?) -> (Array<MovieObject>, Error?) {
        let realm = try! Realm()
        
        if let movies = movies {
            let allMovieObjects = realm.objects(MovieObject.self)
            realm.beginWrite()
            realm.delete(allMovieObjects)

            for movie in movies {
                let movieObject = MovieObject()
                movieObject.title = movie.title
                
                let listGenres = List<Int>()
                for object in movie.genre {
                    listGenres.append(object)
                }
                
                movieObject.genre = listGenres
                movieObject.image = movie.image
                movieObject.popularity = movie.popularity
                movieObject.overview = movie.overview
                
                realm.add(movieObject)
                
            }
            try! realm.commitWrite()
            print(Array(realm.objects(MovieObject.self)).count)
        }
        print(Array(realm.objects(MovieObject.self)).count)
        return (Array(realm.objects(MovieObject.self)),error)
        
    }
    
    func saveGenres(_ genres: [Genre]?, _ error: Error?) -> (Array<GenreObject>, Error?) {
        let realm = try! Realm()
        if let genres = genres {
            let allGenreObjects = realm.objects(GenreObject.self)
            realm.beginWrite()
            realm.delete(allGenreObjects)
            for genre in genres {
                let genreObject = GenreObject()
                genreObject.id = genre.id
                genreObject.name = genre.name
                
                realm.add(genreObject)
            }
            try! realm.commitWrite()
        }
        return (Array(realm.objects(GenreObject.self)), error)
    }
}
