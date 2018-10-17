//
//  Album.swift
//  Albums
//
//  Created by Дмитрий Вашлаев on 19.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit
import ReactiveSwift

struct ItunesReplyByAlbums: Decodable {
    var resultCount: Int?
    var results: [AlbumInfo]?
}

struct AlbumInfo: Decodable {
    var wrapperType: String?
    var collectionType: String?
    var artistId: String?
    var collectionId: Int?
    var amgArtistId: Int?
    var artistName: String?
    var collectionName: String?
    var collectionCensoredName: String?
    var artistViewUrl: String?
    var collectionViewUrl: String?
    var artworkUrl60: String?
    var artworkUrl100: String?
    var collectionPrice: Double?
    var collectionExplicitness: String?
    var contentAdvisoryRating: String?
    var trackCount: Int?
    var copyright: String?
    var country: String?
    var currency: String?
    var releaseDate: String?
    var primaryGenreName: String?
}

struct ItunesReplyBySongs: Decodable {
    var resultCount: Int?
    var results: [Song]?
}

struct Song: Decodable {
    var trackId: Int?
    var artistName: String?
    var trackName: String?
    var trackCensoredName: String?
    var trackPrice: Double?
    var trackExplicitness: String?
    var trackNumber: Int?
    var trackTimeMillis: Int?
}

class Album {
    // MARK: - Public Properties
    private(set) var info: AlbumInfo?
    private(set) var songs = MutableProperty([Song]())
    private(set) var artwork60: String?
    private(set) var artwork100: String?
    
    // MARK: - Initializer
    init(withAlbumInfo albumInfo: AlbumInfo) {
        info = albumInfo
        
        if let collectionId = info?.collectionId {
            deriveListOfSongs(withAlbum: collectionId)
        }
        
        artwork60 = info?.artworkUrl60
        artwork100 = info?.artworkUrl100
    }
    
    // MARK: - Private Methods
    private func deriveListOfSongs(withAlbum collectionId: Int) {
        let itunes = ItunesAPI()
        
        itunes.downloadSongs(withAlbumID: collectionId) { [weak self] (receivedData) in
            do {
                guard let weakSelf = self else { return }
                guard let data = receivedData else { return }
                // Parsing JSON
                let result = try JSONDecoder().decode(ItunesReplyBySongs.self, from: data)
                
                if var array = result.results {
                    // as first entity contains album information it must be removed
                    if let index = array.index(where: { (song) -> Bool in
                        return song.trackId == nil ? true : false
                    }) {
                        array.remove(at: index)
                    }
                    weakSelf.songs.value = array
                }
                
            } catch let jsonErr {
                print("Error serializing JSON:", jsonErr)
            }
        }
    }
}

