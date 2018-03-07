//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Abdalla Tawfik on 7/17/17.
//  Copyright © 2017 AT Apps. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var bottomTextLabel: UILabel!
    @IBOutlet weak var fullTextLabel: UILabel!
    
    func setupCell(with meme:Meme) {
        memeImageView.image = UIImage(data: meme.originalImage! as Data)
        topTextLabel.text = meme.topText
        bottomTextLabel.text = meme.bottomText
        fullTextLabel.text = meme.topText! + "..." + meme.bottomText!
    }
}
