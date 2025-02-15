//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Александр Дудченко on 11.02.2025.
//

import Foundation
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewProtocol? {
        didSet {
            didSetView = true
        }
    }
    
    var didSetView = false
}
