//
//  MovieGridViewController.swift
//  Flix
//
//  Created by pratyush on 2/28/22.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10 // some minimum value is set, won't go below that
     
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                  
                 self.movies = dataDictionary["results"] as! [[String : Any]]
                 self.collectionView.reloadData()
                 
             }
        }
        task.resume()
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
                //let movie = movies[indexPath.item] // CV has an item, not row
        
                let baseUrl = "https://image.tmdb.org/t/p/w185"
                let posterPath = movies[indexPath.item]["poster_path"] as! String
                let posterUrl = URL(string: baseUrl + posterPath)
        
                cell.posterView.af.setImage(withURL: posterUrl!)
        
                return cell
    }
 

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let poster = sender as! UICollectionViewCell
        let index = collectionView.indexPath(for: poster)!
        //let index = tableView.indexPath(for: cell)!
        let movie = movies[index.row]

        let detailsViewController = segue.destination as! MoviesDetailsViewController
        detailsViewController.movie = movie
        collectionView.deselectItem(at: index, animated: true)
        //collectionView.deselectRow(at: index, animated: true)
    }
    


}
