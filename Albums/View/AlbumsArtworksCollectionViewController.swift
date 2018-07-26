//
//  AlbumsArtworksCollectionViewController.swift
//  Albums
//
//  Created by Дмитрий Вашлаев on 19.06.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let numberOfItems: CGFloat = 3

enum MainVCSegues: String {
    case showAlbumDetail
}

enum CollectionViewLayout: CGFloat {
    case interitemSpacing = 3
}

class AlbumsArtworksCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    // MARK: - Public Properties
    let searchBar = UISearchBar()
    var albumsArtworksViewModel: AlbumsArtworksViewModel!
    
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configuring search bar
        setUpSearchBar()
        // Bind model
        bindModel()
        // Set up layout
        setUpLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Search Bar
    /// Configure Search Bar
    func setUpSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search albums"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        // start searching
        guard let searchingString = searchBar.text else {
            fatalError("No valid string was submitted")
        }
        
        albumsArtworksViewModel.searchAlbum(searchingString)
    }
    
    // MARK: - Catching signals on data updating
    func bindModel() {
        albumsArtworksViewModel.isFound.signal.observeResult{ [weak self] (result) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.collectionView?.reloadData()
            }
        }
    }
    
    // MARK: - Set Up Layout
    func setUpLayout() {
        let interitemSpacing = CollectionViewLayout.interitemSpacing.rawValue
        let itemSize = UIScreen.main.bounds.width / numberOfItems - interitemSpacing
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: interitemSpacing, left: 0, bottom: interitemSpacing, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = interitemSpacing
        layout.minimumLineSpacing = interitemSpacing
        
        collectionView?.collectionViewLayout = layout
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == MainVCSegues.showAlbumDetail.rawValue {
            let destinationViewController =  segue.destination as! AlbumDetailedViewController
            if let indexPaths = collectionView?.indexPathsForSelectedItems {
                let index = indexPaths[0]
                destinationViewController.viewModel = albumsArtworksViewModel.getAlbumDetailedViewModel(at: index)
            }
        }
    }
    
    
    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        nothingIsFound()
        return albumsArtworksViewModel.numberOfSections()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumsArtworksViewModel.numberOfItemsInSection(section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCollectionViewCell
        
        // Configure the cell
        cell.viewModel = albumsArtworksViewModel.getCellViewModel(at: indexPath)
        
        return cell
    }
    
    // MARK: - Private Methods
    private func nothingIsFound() {
        if !albumsArtworksViewModel.isFound.value {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height))
            noDataLabel.text = "Nothing is found"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            collectionView!.backgroundView = noDataLabel
        } else {
            collectionView!.backgroundView = nil
        }
    }
}
