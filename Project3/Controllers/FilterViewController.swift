//
//  FilterViewController.swift
//  Project3
//
//  Created by Nicolas Lantean on 4/29/19.
//  Copyright © 2019 Nicolas Lantean. All rights reserved.
//

import UIKit
import Eureka

class FilterViewController: FormViewController {
    
    var genres = [Int:String]()
    
    @IBAction func clearFilters(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "genre")
        UserDefaults.standard.removeObject(forKey: "genreId")
        UserDefaults.standard.removeObject(forKey: "year")
        UserDefaults.standard.removeObject(forKey: "adult")
        
        print("Asd")
        form.setValues(["genre" : "Any", "year" : "", "adult" : false])
        tableView.reloadData()
    }
    
    @IBAction func applyButton(_ sender: UIButton) {
        let values = form.values()
        for value in values {
            if value.key == "genre" {
                UserDefaults.standard.set(value.value, forKey: "genre")
                let idGenreList = (genres as NSDictionary).allKeys(for: value.value) as! [Int]
                let idGenre = idGenreList.first
                UserDefaults.standard.set(idGenre, forKey: "genreId")
                
            } else {
                UserDefaults.standard.set(value.value, forKey: value.key)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form
            
            +++ Section("Filter results")
                <<< ActionSheetRow<String>("genre") {
                    $0.title = "Genre"
                    $0.value = UserDefaults.standard.value(forKey: "genre") as? String
                    $0.options = self.listOfGenres()
                }
            
                <<< IntRow(){ row in
                    row.tag = "year"
                    row.title = "Year"
                    if let year = UserDefaults.standard.value(forKey: "year") {
                        row.value = year as? Int
                    }
                    row.placeholder = "Enter a year here"
                }
                
                <<< SwitchRow() {
                    $0.tag = "adult"
                    $0.title = "Display adult content"
                    if let year = UserDefaults.standard.value(forKey: "adult") {
                        $0.value = year as? Bool
                    } else {
                        $0.value = false
                    }
                }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func listOfGenres() -> [String] {
        var res = [String]()
        for genre in genres {
            res.append(genre.value)
        }
        return res
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
