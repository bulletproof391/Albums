//
//  AlbumCVCViewModel.swift
//  Albums
//
//  Created by Дмитрий Вашлаев on 19.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit
import ReactiveSwift

class AlbumCVCViewModel {
    // MARK: Properties
    private(set) var albumImage: MutableProperty<UIImage>?
    
    init(withAlbumImage image: MutableProperty<UIImage>?) {
        self.albumImage = image
    }
}
