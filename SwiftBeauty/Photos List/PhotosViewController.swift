//
//  PhotosViewController.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/12.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import UIKit

final class PhotosViewController: UIViewController {
    // MARK: - Public Properties
    var viewModel: PhotosViewModel!

    // MARK: - Private Properties
    @IBOutlet private weak var collectionView: UICollectionView!
    private var data = [URL]()

    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        viewModel.fetchPhotos { result in
            switch result {
            case .success(let data):
                self.data = data
                self.collectionView.reloadData()
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }

    func scrollToData(at index: Int, animated: Bool) {
        guard index < data.count else { return }
        let indexPath = IndexPath(item: index, section: 0)
        if !collectionView.indexPathsForVisibleItems.contains(indexPath) {
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .top, animated: animated)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.select(index: indexPath.item, for: data)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! PhotoCell
        cell.setImage(with: data[indexPath.item])
    }
}
