//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Александр Дудченко on 11.02.2025.
//

import Foundation
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    weak var view: ImagesListViewProtocol? {
        didSet {
            didSetView = true
        }
    }
    private(set) var didSetView = false
}
