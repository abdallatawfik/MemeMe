//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Abdalla Tawfik on 2/13/17.
//  Copyright © 2017 AT Apps. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    // MARK: - Properties
    
    var memes:[Meme] {
        get {
            return Model.sharedInstance().getAllMemes()
        }
    }
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If there is no memes saved yet, it will navigate to CreateMemeViewController
        checkMemesCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.ToMemeDetailsVC {
            if let detailsViewController = segue.destination as? MemeDetailViewController, let meme = sender as? Meme {
                detailsViewController.meme = meme
            }
        }
    }
    
    func checkMemesCount() {
        if memes.count == 0 {
            performSegue(withIdentifier: SegueIdentifiers.ToCreateMemeVC, sender: nil)
        }
    }

}

// MARK: - TableView delegate and data source

extension MemeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.TableViewCell, for: indexPath) as! MemeTableViewCell
        
        cell.setupCell(with: memes[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.ToMemeDetailsVC, sender: memes[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Model.sharedInstance().deleteMeme(meme: memes[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .top)
            
            // If all memes were deleted, it will navigate to CreateMemeViewController
            checkMemesCount()
        }
    }
}
