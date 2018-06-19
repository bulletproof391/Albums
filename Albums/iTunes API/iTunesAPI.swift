//
//  iTunesAPI.swift
//  Albums
//
//  Created by Дмитрий Вашлаев on 19.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation

enum Country: String {
    case us
    case ru
}

enum Entity: String {
    case movie = "movie"
    case album = "album"
    case allArtist = "allArtist"
    case podcast = "podcast"
    case musicVideo = "musicVideo"
    case mix = "mix"
    case audiobook = "audiobook"
    case tvSeason = "tvSeason"
    case allTrack = "allTrack"
    case song = "song"
}

enum Attribute: String {
    case mixTerm = "mixTerm"
    case genreIndex = "genreIndex"
    case artistTerm = "artistTerm"
    case composerTerm = "composerTerm"
    case albumTerm = "albumTerm"
    case ratingIndex = "ratingIndex"
    case songTerm = "songTerm"
}

enum APIParameters: String {
    case search = "https://itunes.apple.com/search?"
    case lookup = "https://itunes.apple.com/lookup?"
    case term = "term"
    case country = "country"
    case media = "media"
    case entity = "entity"
    case attribute = "attribute"
    case callback = "callback"
    case limit = "limit"
    case lang = "lang"
    case version = "version"
    case explicit = "explicit"
    case id = "id"
}

// https://itunes.apple.com/search?term=Noize+mc&country=ru&entity=album
// https://itunes.apple.com/lookup?id=1180061840&country=ru&entity=song

class ItunesAPI {
    private func replace(string: String, separator: String = " ", withSeparator: String = "+") -> String {
        let splittedStringArray = string.components(separatedBy: separator)
        return splittedStringArray.joined(separator: withSeparator)
    }
    
    func downloadAlbums(withName name: String, completionHandler: @escaping (Data?) -> Void) {
        let term = replace(string: name, separator: " ", withSeparator: "+")
        
        // Compose search request
        let concatenatedString = "\(APIParameters.search.rawValue)\(APIParameters.term.rawValue)=\(term)&\(APIParameters.country.rawValue)=\(Country.ru.rawValue)&\(APIParameters.entity.rawValue)=\(Entity.album.rawValue)"
        guard let encondedString = concatenatedString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else { return }
        guard let url = URL(string: encondedString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, urlRsponse, err) in
            completionHandler(data)
            }.resume()
    }
    
    func downloadSongs(withAlbumID: Int, completionHandler: @escaping (Data?) -> Void) {
        // Compose lookup request
        let concatenatedString = "\(APIParameters.lookup.rawValue)\(APIParameters.id.rawValue)=\(withAlbumID)&\(APIParameters.country.rawValue)=\(Country.ru.rawValue)&\(APIParameters.entity.rawValue)=\(Entity.song.rawValue)"
        guard let url = URL(string: concatenatedString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, urlRsponse, err) in
            completionHandler(data)
            }.resume()
    }
}
