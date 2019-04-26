//
//  MovieFanViewController.swift
//  Project3
//
//  Created by Nicolas Lantean on 4/25/19.
//  Copyright © 2019 Nicolas Lantean. All rights reserved.
//

import UIKit

class MovieFanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var movies = [Movie]()
    var genres = [Genre]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        
        MoviesData.getMoovies() { (movies,error) in
            if let movies = movies {
                self.movies = movies
            } else {
                print("error")
            }
        }
        
        MoviesData.getGenres() { (genres,error) in
            if let genres = genres {
                self.genres = genres
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
        print(movies.count)
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCellTableViewCell else {
            fatalError("The dequeued cell is not an instance of MovieCell.")
        }
        
        if let image = movies[indexPath.row].image {
            let url = URL(string: "https://image.tmdb.org/t/p/w500/" + image)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.movieImage.image = UIImage(data: data!)
        } else {
            cell.movieImage.image = UIImage(named: "noimage")
        }

        
        cell.movieTitle.text = movies[indexPath.row].title
        cell.moviePopularity.text = "Popularity: " + String(movies[indexPath.row].popularity)
        cell.movieGendre.text = String(movies[indexPath.row].genre[0])
        cell.overview.text = movies[indexPath.row].overview
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }

}
