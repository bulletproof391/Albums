//
//  AlbumModel.swift
//  Albums
//
//  Created by Дмитрий Вашлаев on 19.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation
import ReactiveSwift

class AlbumModel {
    // MARK: Properties
    // Array to be observed from ViewModel
    private(set) var albumsArray = MutableProperty([Album]())
    
    private func initAlbumsArrayWith(albumsInfo array: [AlbumInfo]) {
        var albums = [Album] ()
        for item in array {
            albums.append(Album(withAlbumInfo: item))
        }
        
        albumsArray.value = albums
    }
    
    func searchAlbumsWithName(_ albumName:String) {
        let itunes = ItunesAPI()
        
        itunes.downloadAlbums(withName: albumName) { [weak self] (receivedData) in
            do {
                guard let weakSelf = self else { return }
                guard let data = receivedData else { return }
                // Parsing JSON
                let result = try JSONDecoder().decode(ItunesReplyByAlbums.self, from: data)
                
                if var array = result.results {
                    // Sorting array
                    array.sort {
                        guard let nameOne = $0.collectionName, let nameTwo = $1.collectionName else { return false }
                        return nameOne < nameTwo
                    }
                    
                    weakSelf.initAlbumsArrayWith(albumsInfo: array)
                }
                
            } catch let jsonErr {
                print("Error serializing JSON:", jsonErr)
            }
        }
    }
}
