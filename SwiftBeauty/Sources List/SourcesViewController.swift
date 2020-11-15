//
//  SourcesViewController.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/15.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import UIKit

protocol SourcesViewControllerDelegate: AnyObject {
    func sourcesViewController(_ controller: SourcesViewController, didSelect source: SourceFetchable)
}

final class SourcesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    weak var delegate: SourcesViewControllerDelegate?

    let data: [SourceFetchable] = [
        TimLiaoFetcher(),
        JKForum(forum: .western),
        JKForum(forum: .asian),
        JKForum(forum: .amateur),
        JKForum(forum: .jkfGirl)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Source List"
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SourcesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let source = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell", for: indexPath)
        cell.textLabel?.text = source.sourceName
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SourcesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.sourcesViewController(self, didSelect: data[indexPath.row])
    }
}
