//
//  Github_FeedTests.swift
//  Github FeedTests
//
//  Created by Beniamin Idziak on 19/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import XCTest
@testable import Github_Feed

class Github_FeedTests: XCTestCase {
    
    func testURLEncoding() {
        guard let url = URL(string: "https://api.github.com/search/repositories") else {
            XCTFail("Wrong URL format")
            return
        }
        
        var request = URLRequest(url: url)
        do {
            request = try URLParameterEncoder().encode(urlRequest: request, with: ["q" : "query"])
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertEqual(request.url?.absoluteString, "https://api.github.com/search/repositories?q=query")
    }
    
    func testJSONEncoding() {
        guard let url = URL(string: "https://api.github.com/search/repositories") else {
            XCTFail("Wrong URL format")
            return
        }
        let parameters: [String : String] = ["q" : "query"]
        var request = URLRequest(url: url)
        
        do {
            request = try JSONParameterEncoder().encode(urlRequest: request, with: parameters)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        guard let data = request.httpBody else {
            XCTFail("Encoder failed to provide parameters")
            return
        }
        
        do {
            let result = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String : String]
            XCTAssertEqual(result, parameters)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testRepositoryEndpointCreation() {
        let endpoint = Endpoint.repos(query: "test")
        XCTAssertEqual(endpoint.request?.url?.absoluteString, "https://api.github.com/search/repositories?q=test")
    }
    
    func testRepositoryEndpointCreationWithWrongQuery() {
        let endpoint = Endpoint.repos(query: "test123")
        XCTAssertNotEqual(endpoint.request?.url?.absoluteString, "https://github.com/search/repositories?q=321tset")
    }
    
    func testRepositoriesDecoding() {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "Repositories", withExtension: "json") else {
            XCTFail("Missing file: Repositories.json")
            return
        }
        
        do {
            let json = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let repository: GithubRepos = try decoder.decode(GithubRepos.self, from: json)
            guard let firstItem = repository.items?[0] else {
                XCTFail("Couldn't read first item")
                return
            }
        
            XCTAssertEqual(firstItem.name, "g")
            XCTAssertEqual(firstItem.fullName, "antvis/g")
            XCTAssertEqual(firstItem.description, "A powerful rendering engine which providing Canvas and SVG draw for G2 & G6")
            XCTAssertEqual(firstItem.license?.name, nil)
            XCTAssertEqual(firstItem.language, "TypeScript")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
