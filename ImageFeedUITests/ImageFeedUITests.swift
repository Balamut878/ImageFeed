
//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Александр Дудченко on 13.02.2025.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    // MARK: - Тест авторизации
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("ВАШ ЛОГИН")
        app.tap()
        
        sleep(2)
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("ВАШ ПАРОЛЬ")
        app.tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["No Active"].tap()
        
        sleep(2)
        
        cellToLike.buttons["Active"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav_back_button"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(2)

        app.tabBars.buttons.element(boundBy: 1).tap()

        let nameText = app.staticTexts.matching(identifier: "nameLabel").firstMatch
        XCTAssertTrue(nameText.waitForExistence(timeout: 5), "Имя пользователя не появилось.")

        let usernameText = app.staticTexts.matching(identifier: "loginLabel").firstMatch
        XCTAssertTrue(usernameText.waitForExistence(timeout: 5), "Никнейм не появился.")

        let logoutButton = app.buttons.matching(identifier: "logoutButton").firstMatch
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 5), "Кнопка выхода не найдена.")
        logoutButton.tap()

        let yesButton = app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"]
        XCTAssertTrue(yesButton.waitForExistence(timeout: 5), "Кнопка 'Да' в алерте 'Пока, пока!' не найдена.")
        yesButton.tap()
    }
   }
