//
//  TimLiaoFetcher.swift
//  SwiftBeauty
//
//  Created by Nelson on 2018/8/8.
//  Copyright © 2018年 Nelson. All rights reserved.
//

import Foundation
import Alamofire
import SwiftSoup

final class TimLiaoFetcher: SourceFetchable {
    private static let cfEncoding = CFStringEncodings.big5
    private static let nsEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
    private static let encoding = String.Encoding(rawValue: nsEncoding)

    // MARK: - SourceFetchable

    static var sourceName: String {
        return "提姆正妹"
    }

    func fetchPosts(at page: UInt, completionHandler: @escaping (FetchResult<[Post]>) -> Void) {
        let path = "http://www.timliao.com/bbs/forumdisplay.php?fid=18&filter=0&orderby=dateline&page=\(page)"
        Alamofire.request(path).validate().responseHTMLDocument(encoding: TimLiaoFetcher.encoding) { response in
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
        Alamofire.request(url).validate().responseHTMLDocument() { response in
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
        let query = "#container_all > form li.forum-card > div.pic > a:not([href='http://www.timliao.com'])"
        let elements = try document.select(query)

        let posts = elements.array().compactMap{ e -> Post? in
            guard let image = try? e.select("img").first(),
                let title = try? e.parent()?.parent()?.select("h2.subject > a").first()
            else {
                return nil
            }
            guard let t = try? title!.text(),
                let src = try? image!.attr("src"),
                let href = try? title!.attr("href")
            else {
                return nil
            }
            let post = Post(title: t,
                            coverURL: URL(string: "http://www.timliao.com/bbs/\(src)")!,
                            url: URL(string: "http://www.timliao.com/bbs/\(href)")!)
            return post
        }
        return posts
    }

    private func parse(_ document: Document) throws -> [URL] {
        let query = "div.postcontent > div.mt10 > a > img"
        let elements = try document.select(query)

        let urls = elements.array().compactMap{ e -> URL? in
            guard let src = try? e.attr("src") else {
                return nil
            }
            return URL(string: src)
        }
        return urls
    }
}
