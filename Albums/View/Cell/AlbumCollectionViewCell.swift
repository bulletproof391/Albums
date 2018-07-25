//
//  AlbumCollectionViewCell.swift
//  Albums
//
//  Created by Дмитрий Вашлаев on 19.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit
import ReactiveSwift
//import enum Result.NoError

class AlbumCollectionViewCell: UICollectionViewCell {
    // MARK: Public Properties
    @IBOutlet weak var albumImage: UIImageView!
    
    var imageDisposable: Disposable?
    var viewModel: AlbumCVCViewModel? {
        didSet {
            initializeCell()
        }
    }
    
    // MARK: - Private Methods
    private func initializeCell() {
        imageDisposable = viewModel?.albumImage?.producer.startWithResult({ [weak self] (receivedImage) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                if let image = receivedImage.value {
                    weakSelf.albumImage.image = image
                }
            }
        })
        
    }
    
    // MARK: - Public Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDisposable?.dispose()
    }
}
