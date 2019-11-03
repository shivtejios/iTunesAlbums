//
//  Album.swift
//  iTunesAlbums
//
//  Created by Shiva Teja on 10/31/19.
//  Copyright © 2019 Verizon. All rights reserved.
//

import UIKit

class AlbumsModel:  NSObject {
    
    var title: String?
    var author: [String: Any]?
    var links: [[String: Any]]?
    var country: String?
    var albums = [Album]()
    
    init(with dataDictionary: [String: Any]) {
        super.init()
        title = dataDictionary["title"] as? String ?? ""
        country = dataDictionary["country"] as? String ?? ""
        
        if let authorDictionary = dataDictionary["author"] as? [String: Any] {
            author = authorDictionary
        }
        if let linksArray = dataDictionary["links"] as? [[String: Any]] {
            links = linksArray
        }
        if let albumsArray = dataDictionary["results"] as? [[String: Any]] {
            albumsArray.forEach { (albumDictionary) in
                let album = Album(with: albumDictionary)
                albums.append(album)
            }
        }
    }
}

class Album: NSObject {

    var id: String?
    var releaseDate: String?
    var name: String?
    var kind: String?
    var copyRight: String?
    var artistId: String?
    var artistName: String?
    var contentAdvisoryRating: String?
    var artistURL: String?
    var thumbnailURL: String?
    var url: String?
    var genres = [Genre]()
    
    init(with dataDictionary: [String: Any]) {
        super.init()
        id = dataDictionary["id"] as? String ?? ""
        releaseDate = dataDictionary["releaseDate"] as? String ?? ""
        name = dataDictionary["name"] as? String ?? ""
        kind = dataDictionary["kind"] as? String ?? ""
        copyRight = dataDictionary["copyright"] as? String ?? ""
        artistId = dataDictionary["artistId"] as? String ?? ""
        artistName = dataDictionary["artistName"] as? String ?? ""
        contentAdvisoryRating = dataDictionary["contentAdvisoryRating"] as? String ?? ""
        artistURL = dataDictionary["artistUrl"] as? String ?? ""
        thumbnailURL = dataDictionary["artworkUrl100"] as? String ?? ""
        url = dataDictionary["url"] as? String ?? ""
        if let genresArray = dataDictionary["genres"] as? [[String: Any]] {
            genresArray.forEach { (genreDictionary) in
                let genre = Genre(with: genreDictionary)
                genres.append(genre)
            }
        }
    }
}

class Genre: NSObject {
    
    var genreId: String?
    var name: String?
    var url: String?
    
    init(with dataDictionary: [String: Any]) {
        super.init()
        genreId = dataDictionary["genreId"] as? String ?? ""
        name = dataDictionary["name"] as? String ?? ""
        url = dataDictionary["url"] as? String ?? ""
    }
}
