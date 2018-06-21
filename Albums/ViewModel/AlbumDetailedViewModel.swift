//
//  AlbumDetailedViewModel.swift
//  Albums
//
//  Created by Дмитрий Вашлаев on 21.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation
import ReactiveSwift

class AlbumDetailedViewModel {
    // MARK: Properties
    private var artistName: String?
    private var collectionName: String?
    private var songs: [Song]?
    private var mutablePropertySongs: MutableProperty<[Song]>?
    private(set) var albumImage: MutableProperty<UIImage>?
    
    init(with album: Album?) {
        self.artistName = album?.info?.artistName
        self.collectionName = album?.info?.collectionName
        self.mutablePropertySongs = album?.songs
        
        mutablePropertySongs?.producer.startWithResult{ [weak self] (receivedSongs) in
            guard let weakSelf = self else { return }
            if let array = receivedSongs.value {
                weakSelf.songs = array
            }
        }
        
        self.albumImage = album?.artwork100
    }
    
    func getArtistName() -> String? {
        return artistName
    }
    
    func getAlbumName() -> String? {
        return collectionName
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        guard let count = songs?.count else { return 0 }
        return count
    }
    
    func songForRow(_ indexPath: IndexPath) -> String? {
        return songs?[indexPath.row].trackName
    }
}
