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
    // Public variables
    private(set) var hasUpdated = MutableProperty(false)
    
    // MARK: - Initializer
    init(model: AlbumModel) {
        self.albumModel = model
        albumModel?.albumsArray.signal.observeResult({ [weak self] (result) in
            guard let weakSelf = self else { return }
            guard let array = result.value else { return }
            
            weakSelf.hasUpdated.value = true
        })
    }
}
