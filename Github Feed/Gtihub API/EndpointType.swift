//
//  EndpointType.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 19/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation

protocol EndpointType {
    var base: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var request: URLRequest? { get }
    var cachable: Bool { get }
}
