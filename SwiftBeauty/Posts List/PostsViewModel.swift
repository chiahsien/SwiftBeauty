//
//  PostsViewModel.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/10.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import Foundation

protocol PostsViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: PostsViewModel, show post: Post)
}

final class PostsViewModel {
    // MARK: - Public Properties
    private(set) var hasMoreData = true
    weak var delegate: PostsViewModelDelegate?
    var title: String {
        return type(of: fetcher).sourceName
    }

    // MARK: - Private Properties
    private var page: UInt = 1
    private var posts = [Post]()
    private let fetcher: SourceFetchable

    // MARK: - Public Methods
    init(_ fetcher: SourceFetchable) {
        self.fetcher = fetcher
    }

    func fetchPostsAtFirstPage(_ completion: @escaping (FetchResult<[Post]>) -> Void) {
        page = 1
        fetchPosts(at: page, completion: completion)
    }

    func fetchPostsAtNextPage(_ completion: @escaping (FetchResult<[Post]>) -> Void) {
        page += 1
        fetchPosts(at: page, completion: completion)
    }

    func show(_ post: Post) {
        delegate?.viewModel(self, show: post)
    }

    // MARK: - Private Methods
    private func fetchPosts(at page: UInt, completion: @escaping (FetchResult<[Post]>) -> Void) {
        fetcher.fetchPosts(at: page) { result in
            guard case let .success(data) = result else {
                self.hasMoreData = false
                completion(result)
                return
            }

            let posts = (page == 1 ? data : self.posts + data)
            self.posts = posts
            self.hasMoreData = true
            completion(.success(posts))
        }
    }
}
