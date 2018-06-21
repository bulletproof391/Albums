//
//  AlbumDetailedViewController.swift
//  Albums
//
//  Created by Дмитрий Вашлаев on 21.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AlbumDetailedViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource{
    // MARK: Properties
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: AlbumDetailedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel?.albumImage?.producer.startWithResult{ [weak self] (receivedImage) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                if let image = receivedImage.value {
                    weakSelf.albumImage.image = image
                }
            }
        }
        
        artistName.text = viewModel?.getArtistName()
        albumName.text = viewModel?.getAlbumName()
        albumName.frame = CGRect(x: albumName.frame.origin.x, y: albumName.frame.origin.y, width: albumName.frame.width, height: albumName.optimalHeight)
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = viewModel.songForRow(indexPath)
        
        return cell
    }    
}

