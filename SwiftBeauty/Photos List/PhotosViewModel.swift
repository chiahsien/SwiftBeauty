//
//  PhotosViewModel.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/12.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import Foundation

protocol PhotosViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: PhotosViewModel, didSelect index: Int, for data: [URL])
}

final class PhotosViewModel {
    // MARK: - Public Properties
    var title: String {
        return post.title
    }
    weak var delegate: PhotosViewModelDelegate?

    // MARK: - Private Properties
    private let fetcher: SourceFetchable
    private let post: Post
    private var urls = [URL]()

    // MARK: - Public Methods
    init(_ fetcher: SourceFetchable, post: Post) {
        self.fetcher = fetcher
        self.post = post
    }

    func fetchPhotos(_ completion: @escaping (FetchResult<[URL]>) -> Void) {
        fetcher.fetchPhotos(at: post.url) { result in
            if case let .success(urls) = result {
                self.urls = urls
            }
            completion(result)
        }
    }

    func select(index: Int, for data: [URL]) {
        delegate?.viewModel(self, didSelect: index, for: urls)
    }
}
