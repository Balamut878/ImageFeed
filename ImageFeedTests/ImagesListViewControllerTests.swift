//
//  ImagesListViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Александр Дудченко on 11.02.2025.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewControllerTests: XCTestCase {
    func testViewControllerCallsPresenter() {
        // Given
        let presenterSpy = ImagesListPresenterSpy()
        let sut = ImagesListViewController()

        // When
        sut.configure(presenterSpy)

        // Then
        XCTAssertTrue(presenterSpy.didSetView, "ImagesListViewController должен установить presenter.view")
    }
}
