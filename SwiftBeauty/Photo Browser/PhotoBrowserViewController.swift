//
//  PhotoBrowserViewController.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/14.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import UIKit

protocol PhotoBrowserViewControllerDelegate: AnyObject {
    func photoBrowserViewController(_ viewController: PhotoBrowserViewController, closeAt index: Int)
}

final class PhotoBrowserViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: PhotoBrowserViewControllerDelegate?
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }

    // MARK: - Private Properties
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var maskImageView: UIImageView!
    @IBOutlet private weak var indexLabel: UILabel!
    private var data = [URL]()
    private var currentIndex = 0 {
        didSet {
            if data.count > 0 {
                indexLabel.text = "\(currentIndex + 1) / \(data.count)"
            }
        }
    }

    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        maskImageView.isHidden = true
    }

    func load(_ imageURLs: [URL], scrollTo index: Int) {
        guard index < imageURLs.count else { return }
        data = imageURLs
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
        currentIndex = index
    }

    // MARK: - Private Methods
    @IBAction private func close(_ sender: Any) {
        delegate?.photoBrowserViewController(self, closeAt: currentIndex)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as! PhotoCell
        maskImageView.image = cell.imageView.image
        maskImageView.isHidden = false
        collectionView.isHidden = true
        coordinator.animate(alongsideTransition: { (_) in
            let offset = CGPoint(x: CGFloat(self.currentIndex) * self.collectionView.bounds.size.width, y: 0)
            self.collectionView.contentOffset = offset
        }) { (_) in
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.isHidden = false
            self.maskImageView.isHidden = true
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoBrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.setImage(with: data[indexPath.item])
        return cell;
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoBrowserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
    }
}
