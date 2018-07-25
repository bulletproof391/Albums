//
//  AlbumsArtworksViewModel.swift
//  Albums
//
//  Created by Дмитрий Вашлаев on 19.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import Foundation
import ReactiveSwift

class AlbumsArtworksViewModel {
    // MARK: - Properties
    // Private variables
    private var albumModel: AlbumModel?
    private var albumsArray: [Album] = [Album]()
    private var cellViewModelArray: [AlbumCVCViewModel] = [AlbumCVCViewModel]()
    private var albumDetailedViewModelArray: [AlbumDetailedViewModel] = [AlbumDetailedViewModel]()
    
    // Public variables
    private(set) var hasUpdated = MutableProperty(false)
    
    // MARK: - Initializer
    init(model: AlbumModel) {
        self.albumModel = model
        albumModel?.albumsArray.signal.observeResult({ [weak self] (result) in
            guard let weakSelf = self else { return }
            guard let array = result.value else { return }
            
            weakSelf.albumsArray = array
            weakSelf.initializeViewModels(with: array)
            
            weakSelf.hasUpdated.value = true
        })
    }
    
    private func initializeViewModels(with albumsArray: [Album]) {
        cellViewModelArray.removeAll()
        albumDetailedViewModelArray.removeAll()
        for album in albumsArray {
            cellViewModelArray.append(AlbumCVCViewModel(withAlbumImage: album.artwork100))
            albumDetailedViewModelArray.append(AlbumDetailedViewModel(with: album))
        }
    }
    
    func disposeOfResources() {
        albumsArray.removeAll()
        cellViewModelArray.removeAll()
        albumDetailedViewModelArray.removeAll()
    }
    
    func searchAlbum(_ searchingString: String) {
        disposeOfResources()
        albumModel?.searchAlbumsWithName(searchingString)
    }
    
    func getAlbumDetailedViewModel(at indexPath: IndexPath) -> AlbumDetailedViewModel? {
        return albumDetailedViewModelArray[indexPath.row]
    }
    
    // MARK: Updating collection view
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return albumsArray.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> AlbumCVCViewModel? {
        return cellViewModelArray[indexPath.row]
    }
}

