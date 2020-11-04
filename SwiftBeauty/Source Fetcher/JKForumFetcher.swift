//
//  JKForumFetcher.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/18.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import Foundation
import SwiftSoup

final class JKForumWesternFetcher: JKForumFetcher, SourceFetchable {
    static var sourceName: String {
        return "JKF - 歐美美女"
    }

    func fetchPosts(at page: UInt, completionHandler: @escaping (FetchResult<[Post]>) -> Void) {
        self.fetchPosts(with: "522", at: page, completionHandler: completionHandler)
    }
}

final class JKForumAsiaFetcher: JKForumFetcher, SourceFetchable {
    static var sourceName: String {
        return "JKF - 亞洲美女"
    }

    func fetchPosts(at page: UInt, completionHandler: @escaping (FetchResult<[Post]>) -> Void) {
        self.fetchPosts(with: "393", at: page, completionHandler: completionHandler)
    }
}

final class JKForumAmateurFetcher: JKForumFetcher, SourceFetchable {
    static var sourceName: String {
        return "JKF - 素人正妹"
    }

    func fetchPosts(at page: UInt, completionHandler: @escaping (FetchResult<[Post]>) -> Void) {
        self.fetchPosts(with: "574", at: page, completionHandler: completionHandler)
    }
}

final class JKForumJkfGirlFetcher: JKForumFetcher, SourceFetchable {
    static var sourceName: String {
        return "JKF - JKF女郎"
    }

    func fetchPosts(at page: UInt, completionHandler: @escaping (FetchResult<[Post]>) -> Void) {
        self.fetchPosts(with: "1112", at: page, completionHandler: completionHandler)
    }
}

class JKForumFetcher {

    // MARK: - Public Methods

    func fetchPosts(with forumID: String, at page: UInt, completionHandler: @escaping (FetchResult<[Post]>) -> Void) {
        let path = "https://www.jkforum.net/forum-\(forumID)-\(page).html"
        let task = URLSession.shared.dataTask(with: URL(string: path)!) { (data, _, error) in
            guard let data = data, error == nil else {
                let result = FetchResult<[Post]>.failure(.networkError(error!))
                completionHandler(result)
                return
            }

            guard let html = String(data: data, encoding: .utf8) else {
                let result = FetchResult<[Post]>.failure(.invalidData(data))
                completionHandler(result)
                return
            }

            do {
                let document: Document = try SwiftSoup.parse(html)
                let posts: [Post] = try self.parse(document)
                let result: FetchResult<[Post]> = (posts.isEmpty ? .failure(.emptyData) : .success(posts))
                completionHandler(result)
            } catch {
                let result: FetchResult<[Post]> = .failure(.parseError(error))
                completionHandler(result)
            }
        }
        task.resume()
    }

    func fetchPhotos(at url: URL, completionHandler: @escaping (FetchResult<[URL]>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                let result = FetchResult<[URL]>.failure(.networkError(error!))
                completionHandler(result)
                return
            }

            guard let html = String(data: data, encoding: .utf8) else {
                let result = FetchResult<[URL]>.failure(.invalidData(data))
                completionHandler(result)
                return
            }

            do {
                let document: Document = try SwiftSoup.parse(html)
                let urls: [URL] = try self.parse(document)
                let result: FetchResult<[URL]> = (urls.isEmpty ? .failure(.emptyData) : .success(urls))
                completionHandler(result)
            } catch {
                let result: FetchResult<[URL]> = .failure(.parseError(error))
                completionHandler(result)
            }
        }
        task.resume()
    }

    // MARK: - Private Methods

    private func parse(_ document: Document) throws -> [Post] {
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

    private func parse(_ document: Document) throws -> [URL] {
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
