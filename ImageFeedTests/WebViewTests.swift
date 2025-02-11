//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Александр Дудченко on 11.02.2025.
//

import Testing
import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController

        // when
        _ = viewController.view

        // then
        XCTAssertTrue(presenter.viewDidLoadCalled, "Метод viewDidLoad должен быть вызван у презентера")
    }

    func testPresenterCallsLoadRequest() {
        // given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)

        viewController.presenter = presenter
        presenter.view = viewController

        // when
        presenter.viewDidLoad()

        // then
        XCTAssertTrue(viewController.loadRequestCalled, "Метод load(request:) должен быть вызван у вьюконтроллера")
    }
    
    func testProgressVisibleWhenLessThenOne() {
        // given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6

        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        // then
        XCTAssertFalse(shouldHideProgress, "Прогресс должен быть видим, если значение меньше 1.0")
    }

    func testProgressHiddenWhenOne() {
        // given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0

        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        // then
        XCTAssertTrue(shouldHideProgress, "Прогресс должен быть скрыт, если значение 1.0")
    }
    
    func testAuthHelperAuthURL() {
        // given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)

        // when
        let url = authHelper.authURL()

        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }

        // then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        XCTAssertTrue(urlString.contains("code"))
    }
    
    func testCodeFromURL() {
        // given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponents?.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents?.url
        let authHelper = AuthHelper()

        // when
        let code = authHelper.code(from: url!)

        // then
        XCTAssertEqual(code, "test code")
    }
}
