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
    // MARK: - Private Properties
    private var albumModel: AlbumModel?
    private var cellViewModelArray: [AlbumCVCViewModel] = [AlbumCVCViewModel]()
    private var albumDetailedViewModelArray: [AlbumDetailedViewModel] = [AlbumDetailedViewModel]()
    
    // MARK: - Public Properties
    private(set) var isFound = MutableProperty(false)
    
    // MARK: - Initializer
    init(model: AlbumModel) {
        self.albumModel = model
        self.isFound.value = true
        
        albumModel?.albumsArray.signal.observeResult({ [weak self] (result) in
            guard let weakSelf = self else { return }
            guard let array = result.value else { return }
            
            weakSelf.initializeViewModels(with: array)
            
            if array.count > 0 {
                weakSelf.isFound.value = true
            } else {
                weakSelf.isFound.value = false
            }
        })
    }
    
    // MARK: - Private Methods
    private func initializeViewModels(with albumsArray: [Album]) {
        cellViewModelArray.removeAll()
        albumDetailedViewModelArray.removeAll()
        for album in albumsArray {
            let newCollectionViewCellViewModel = AlbumCVCViewModel(with: album.artwork100)
            cellViewModelArray.append(newCollectionViewCellViewModel)
            albumDetailedViewModelArray.append(AlbumDetailedViewModel(with: album, image: newCollectionViewCellViewModel.albumImage))
        }
    }
    
    // MARK: - Public Methods
    func disposeOfResources() {
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
        return cellViewModelArray.count > 0 ? 1 : 0
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return cellViewModelArray.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> AlbumCVCViewModel? {
        return cellViewModelArray[indexPath.row]
    }
}

