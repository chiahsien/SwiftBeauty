//
//  PostsViewController.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/2.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import UIKit

final class PostsViewController: UIViewController {
    var viewModel: PostsViewModel!
    @IBOutlet private weak var tableView: UITableView!
    private var data = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        viewModel.fetchPostsAtFirstPage { result in
            self.handleResult(result)
        }
    }

    private func handleResult(_ result: FetchResult<[Post]>) {
        switch result {
        case .success(let data):
            self.data = data
            tableView.reloadData()
        case .failure(let error):
            print("error: \(error)")
        }
    }
}

// MARK: - UITableViewDataSource
extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.setPost(data[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == data.count - 1, viewModel.hasMoreData else {
            return
        }
        viewModel.fetchPostsAtNextPage { result in
            self.handleResult(result)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.show(data[indexPath.row])
    }
}
