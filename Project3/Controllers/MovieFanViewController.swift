//
//  MovieFanViewController.swift
//  Project3
//
//  Created by Nicolas Lantean on 4/25/19.
//  Copyright © 2019 Nicolas Lantean. All rights reserved.
//

import UIKit
import RealmSwift

class MovieFanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var movies = [MovieObject]()
    var genres = [Int:String]()

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        
        MoviesData.getMoovies() { (movies,error) in
            if let movies = movies {
                let realm = try! Realm()
                
                realm.beginWrite()
                realm.deleteAll()
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
                
                self.movies = Array(realm.objects(MovieObject.self))
                self.loadingText.isHidden = true
                self.loadingIndicator.stopAnimating()
                self.tableView.isHidden = false
                self.tableView.reloadData()
                
            } else {
                print("error")
            }
        }
        
        MoviesData.getGenres() { (genres,error) in
            if let genres = genres {
                let realm = try! Realm()
                
                realm.beginWrite()
                realm.deleteAll()
                for genre in genres {
                    let genreObject = GenreObject()
                    genreObject.id = genre.id
                    genreObject.name = genre.name
                    
                    realm.add(genreObject)
                    
                    }
                try! realm.commitWrite()
            
                let genreList = Array(realm.objects(GenreObject.self))
                for genre in genreList {
                    self.genres[genre.id] = genre.name
                }
                print(self.genres.count)
                self.tableView.reloadData()
            } else {
                print("error")
            }
            
            
        }
        

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCellTableViewCell else {
            fatalError("The dequeued cell is not an instance of MovieCell.")
        }
        
        if let image = movies[indexPath.row].image, let url = URL(string: "https://image.tmdb.org/t/p/w200/" + image), let data = try? Data(contentsOf: url)  {
             //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.movieImage.image = UIImage(data: data)
        } else {
            cell.movieImage.image = UIImage(named: "noimage")
        }
        
        var genreString = ""
        for (index,genreObject) in movies[indexPath.row].genre.enumerated() {
            if let genreNew = genres[genreObject] {
                genreString.append(genreNew)
            }
            if index != movies[indexPath.row].genre.endIndex - 1 {
                genreString.append(", ")
            }
        }

        cell.movieGendre.text = genreString
        cell.movieTitle.text = movies[indexPath.row].title
        cell.moviePopularity.text = "Popularity: " + String(movies[indexPath.row].popularity)
        cell.overview.text = movies[indexPath.row].overview
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is FilterViewController
        {
            let vc = segue.destination as? FilterViewController
            vc?.genres = self.genres
        }
    }

}
