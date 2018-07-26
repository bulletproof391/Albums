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
    // MARK: - Private Properties
    private var image: UIImage?
    
    // MARK: - Public Properties
    private(set) var albumImage = MutableProperty(UIImage()) // MutableProperty<UIImage>?
    
    // MARK: - Initializer
    init(with urlString: String?) {
        downloadImage(urlString)
    }
    
    // MARK: - Private Methods
    private func downloadImage(_ urlString: String?) {
        guard let string = urlString else { return }
        
        if let url = URL(string: string) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, urlRsponse, err) in
            if let receivedData = data, let weakSelf = self, let receivedImage = UIImage(data: receivedData) {
                weakSelf.image = receivedImage
                weakSelf.albumImage.value = receivedImage
            }
            }.resume()
        }
    }
    
    // MARK: - Public Methods
    func getImage(completionHandler: @escaping(UIImage) -> Void) {
        if let _ = image {
            completionHandler(image!)
        } else {
            albumImage.producer.startWithResult{ (receivedImage) in
                if let _ = receivedImage.value {
                    completionHandler(receivedImage.value!)
                }
            }
        }
    }
}
