//
//  ProfileViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Александр Дудченко on 11.02.2025.
//

import XCTest
@testable import ImageFeed

final class ProfileViewControllerTests: XCTestCase {
    func testViewControllerCallsPresenter() {
        // Given
        let presenterSpy = ProfilePresenterSpy()
        let sut = ProfileViewController()
        
        // When
        sut.configure(presenterSpy)
        
        // Then
        XCTAssertTrue(presenterSpy.didSetView, "ProfileViewController должен установить presenter.view")
    }
}
