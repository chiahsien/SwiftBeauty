//
//  PhotoCell.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/12.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import UIKit
import Kingfisher

final class PhotoCell: UICollectionViewCell {
    private lazy var processor: ResizingImageProcessor = {
        let scale = UIScreen.main.scale
        let size = CGSize(
            width: imageView.bounds.size.width * scale,
            height: imageView.bounds.size.height * scale
        )
        return ResizingImageProcessor(referenceSize: size, mode: .aspectFill)
    }()
    private lazy var options: KingfisherOptionsInfo = [
        .processor(processor),
        .transition(.fade(0.2)),
        .backgroundDecode,
        .cacheOriginalImage
    ]
    @IBOutlet weak var imageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
    }

    func setImage(with url: URL) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
    }
}
