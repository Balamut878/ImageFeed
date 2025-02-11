//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Александр Дудченко on 11.02.2025.
//

import Foundation
@testable import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false // Фиксируем вызов метода

    func load(request: URLRequest) {
        loadRequestCalled = true // Отмечаем, что метод вызван
    }

    func setProgressValue(_ newValue: Float) {}

    func setProgressHidden(_ isHidden: Bool) {}
}
