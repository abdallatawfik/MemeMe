//
//  Constants.swift
//  MemeMe
//
//  Created by Abdalla Tawfik on 2/19/18.
//  Copyright © 2018 AT Apps. All rights reserved.
//


// MARK: - General Constants

struct GeneralConstants {
    static let MemeFont = "Impact"
    static let DefaultTopText = "TOP"
    static let DefaultBottomText = "BOTTOM"
}

// MARK: - Reuse Identifiers

struct ReuseIdentifiers {
    static let TableViewCell = "MemeTableViewCell"
    static let CollectionViewCell = "MemeCollectionViewCell"
}

// MARK: - Segue Identifiers

struct SegueIdentifiers {
    static let ToMemeDetailsVC = "showMemeDetails"
    static let ToCreateMemeVC = "createMeme"
}

// MARK: - CoreData

struct CoreDataConstants {
    static let ModelName = "Model"
    static let MemeEntityName = "Meme"
}
