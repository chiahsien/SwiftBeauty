//
//  PostCell.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/12.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import UIKit
import Kingfisher

final class PostCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    private lazy var options: KingfisherOptionsInfo = [
        .processor(DownsamplingImageProcessor(size: photoImageView.frame.size)),
        .scaleFactor(UIScreen.main.scale),
        .cacheOriginalImage,
        .transition(.fade(0.2)),
        .backgroundDecode
    ]
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.kf.cancelDownloadTask()
    }

    func setPost(_ post: Post) {
        titleLabel.text = post.title
        photoImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(with: post.coverURL, options: options)
    }
}
