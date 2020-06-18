//
//  MovieFanViewController.swift
//  Project3
//
//  Created by Nicolas Lantean on 4/25/19.
//  Copyright © 2019 Nicolas Lantean. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import AlamofireImage

class MovieFanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var movies = [MovieObject]()
    var genres = [Int:String]()
    var ascending = true

    @IBAction func sortButton(_ sender: UIButton) {
        if ascending {
            movies = movies.sorted(by: { (lhsData, rhsData) -> Bool in
                return lhsData.popularity < rhsData.popularity
            })
            sender.setTitle("Best rated ▲", for: .normal)
            ascending = false
        } else {
            movies = movies.sorted(by: { (lhsData, rhsData) -> Bool in
                return lhsData.popularity > rhsData.popularity
            })
            sender.setTitle("Best rated ▼", for: .normal)
            ascending = true
        }
        tableView.reloadData()
    }
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let realmModel = RealmModel()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        
        MoviesData.getMoovies() { (movies,error) in
            let (movieList, error) = realmModel.saveMovies(movies, error)
            if let error = error {
                self.errorView.isHidden = false
            }
            self.movies = movieList
            self.loadingText.isHidden = true
            self.loadingIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
        
        MoviesData.getGenres() { (genres,error) in
            let (genreList, error) = realmModel.saveGenres(genres, error)
            guard error == nil else {
                return
            }
            for genre in genreList {
                self.genres[genre.id] = genre.name
            }
            self.tableView.reloadData()
        }

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
        if let image = movies[indexPath.row].image, let url = URL(string: "https://image.tmdb.org/t/p/w200/" + image) {
            Alamofire.request(url).responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                
                if let imageMovie = response.result.value {
                    cell.movieImage.image = imageMovie
                }
            }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

}
