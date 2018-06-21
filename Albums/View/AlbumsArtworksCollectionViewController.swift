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
    // MARK: - Properties
    let searchBar = UISearchBar()
    var albumsArtworksViewModel: AlbumsArtworksViewModel!
    
    // MARK: - View loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    // clear Collection View when nothing is typed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            albumsArtworksViewModel.disposeOfResources()
            collectionView?.reloadData()
        }
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
        albumsArtworksViewModel.hasUpdated.signal.observeResult{ [weak self] (result) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.collectionView?.reloadData()
            }
        }
    }
    
    // MARK: - Set up layout
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
}
