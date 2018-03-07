//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Abdalla Tawfik on 2/13/17.
//  Copyright © 2017 AT Apps. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    
    var memes:[Meme] {
        get {
            return Model.sharedInstance().getAllMemes()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionViewFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView?.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.ToMemeDetailsVC {
            if let detailsViewController = segue.destination as? MemeDetailViewController, let meme = sender as? Meme {
                detailsViewController.meme = meme
            }
        }
    }
}

// MARK: - CollectionView delegate and data source

extension MemeCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.CollectionViewCell, for: indexPath) as! MemeCollectionViewCell
        
        cell.setupCell(with: memes[indexPath.row])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.ToMemeDetailsVC, sender: memes[indexPath.row])
    }
    
    func configureCollectionViewFlowLayout() {
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}
