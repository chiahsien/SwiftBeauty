//
//  JKForumFetcher.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/18.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import Foundation
import Alamofire
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
        let path = "https://www.jkforum.net/forum.php?mod=forumdisplay&fid=\(forumID)&mobile=yes&page=\(page)"
        Alamofire.request(path).validate().responseHTMLDocument { response in
            guard case let .success(document) = response.result else {
                let result: FetchResult<[Post]> = .failure(response.result.error! as! CustomError)
                completionHandler(result)
                return
            }

            do {
                let posts: [Post] = try self.parse(document)
                let result: FetchResult<[Post]> = (posts.isEmpty ? .failure(.emptyData) : .success(posts))
                completionHandler(result)
            } catch {
                let result: FetchResult<[Post]> = .failure(.parse(error: error))
                completionHandler(result)
            }
        }
    }

    func fetchPhotos(at url: URL, completionHandler: @escaping (FetchResult<[URL]>) -> Void) {
        Alamofire.request(url).validate().responseHTMLDocument { response in
            guard case let .success(document) = response.result else {
                let result: FetchResult<[URL]> = .failure(response.result.error! as! CustomError)
                completionHandler(result)
                return
            }

            do {
                let urls: [URL] = try self.parse(document)
                let result: FetchResult<[URL]> = (urls.isEmpty ? .failure(.emptyData) : .success(urls))
                completionHandler(result)
            } catch {
                let result: FetchResult<[URL]> = .failure(.parse(error: error))
                completionHandler(result)
            }
        }
    }

    // MARK: - Private Methods

    private func parse(_ document: Document) throws -> [Post] {
        let elements = try document.select("ul#alist a")
        let baseURL = URL(string: "https://www.jkforum.net/")!

        let posts = elements.array().compactMap { e -> Post? in
            guard let href = try? e.attr("href"),
                let image = try? e.select("img").first(),
                let title = try? e.select("h1").first()
                else {
                    return nil
            }
            guard let t = try? title!.text(),
                let src = try? image!.attr("src")
                else {
                    return nil
            }
            let post = Post(title: t,
                            coverURL: URL(string: "\(src)", relativeTo: baseURL)!,
                            url: URL(string: "\(href)", relativeTo: baseURL)!)
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
