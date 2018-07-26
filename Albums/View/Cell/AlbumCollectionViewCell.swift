//
//  AlbumCollectionViewCell.swift
//  Albums
//
//  Created by Дмитрий Вашлаев on 19.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit
import ReactiveSwift

class AlbumCollectionViewCell: UICollectionViewCell {
    // MARK: Public Properties
    @IBOutlet weak var albumImage: UIImageView!
    
    var viewModel: AlbumCVCViewModel? {
        didSet {
            initializeCell()
        }
    }
    
    // MARK: - Private Methods
    private func initializeCell() {
        viewModel?.getImage(completionHandler: { [weak self] (receivedImage) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.albumImage.image = receivedImage
            }
        })
    }
}
