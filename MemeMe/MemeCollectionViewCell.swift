//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Abdalla Tawfik on 2/13/17.
//  Copyright © 2017 AT Apps. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!
    
    func setupCell(with meme:Meme) {
        imageView.image = UIImage(data: meme.originalImage! as Data)
        topTextLabel.text = meme.topText
        bottomTextLabel.text = meme.bottomText
    }
}
