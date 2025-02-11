//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Александр Дудченко on 11.02.2025.
//

import Foundation
@testable import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false // Фиксируем вызов метода
    var view: WebViewViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true // Отмечаем, что метод вызван
    }

    func didUpdateProgressValue(_ newValue: Double) {}

    func code(from url: URL) -> String? {
        return nil
    }
}
