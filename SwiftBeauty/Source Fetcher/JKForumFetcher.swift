//
//  JKForumFetcher.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/18.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import Foundation
import SwiftSoup

struct JKForum: SourceFetchable {
    enum Forum {
        case western, asian, amateur, jkfGirl
    }

    var sourceName: String {
        switch self.forum {
        case .western:
            return "JKF - 歐美美女"
        case .asian:
            return "JKF - 亞洲美女"
        case .amateur:
            return "JKF - 亞洲美女"
        case .jkfGirl:
            return "JKF - JKF女郎"
        }
    }

    private let forum: Forum
    private var forumId: UInt {
        switch self.forum {
        case .western:
            return 522
        case .asian:
            return 393
        case .amateur:
            return 574
        case .jkfGirl:
            return 1112
        }
    }

    init(forum: Forum) {
        self.forum = forum
    }

    func fetchPosts(at page: UInt, completionHandler: @escaping (FetchResult<[Post]>) -> Void) {
        let path = "https://www.jkforum.net/forum-\(self.forumId)-\(page).html"
        fetchHTML(at: URL(string: path)!, encoding: .utf8, using: postsParser, completionHandler: completionHandler)
    }

    func fetchPhotos(at url: URL, completionHandler: @escaping (FetchResult<[URL]>) -> Void) {
        fetchHTML(at: url, encoding: .utf8, using: photosParser, completionHandler: completionHandler)
    }

    // MARK: - Private Methods
    private let postsParser: Parser<Post> = { html in
        let document: Document = try SwiftSoup.parse(html)
        let baseURL = URL(string: "https://www.jkforum.net/")!
        let elements = try document.select("ul#waterfall > li > div.c > a")
        let posts = elements.array().compactMap { e -> Post? in
            guard let href = try? e.attr("href"),
                  let title = try? e.attr("title"),
                  let style = try? e.attr("style")
            else {
                return nil
            }
            guard let regex = try? NSRegularExpression(pattern: "https?:\\/\\/.+\\.(jpg|png)", options: .caseInsensitive),
                  let result = regex.firstMatch(in: style, options: [], range: NSRange(location: 0, length: style.count))
            else {
                return nil
            }
            let image = String(style[Range(result.range, in: style)!])
            let post = Post(title: title,
                            coverURL: URL(string: image, relativeTo: baseURL)!,
                            url: URL(string: href, relativeTo: baseURL)!)
            return post
        }

        return posts
    }

    private let photosParser: Parser<URL> = { html in
        let document: Document = try SwiftSoup.parse(html)
        let elements = try document.select("div.first ignore_js_op > img")
        let urls = elements.array().compactMap { e -> URL? in
            guard let src = try? e.attr("file") else {
                return nil
            }
            return URL(string: src)
        }
        return urls
    }
}
