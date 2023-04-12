//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Алексей Тиньков on 09.04.2023.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
        sleep(3)
        
        let secondPoster = app.images["Poster"] // ещё раз находим постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation

        XCTAssertFalse(firstPosterData == secondPosterData) // проверяем, что постеры разные
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap() // находим кнопку `Нет` и нажимаем её
        sleep(3)
        
        let secondPoster = app.images["Poster"] // ещё раз находим постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertFalse(firstPosterData == secondPosterData) // проверяем, что постеры разные
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testFinalAlert() {
        sleep(3)
        for _ in 0..<10 {
            app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
            sleep(3)
        }
        
        XCTAssertTrue(app.alerts["Раунд окончен"].exists)
        XCTAssertEqual(app.alerts["Раунд окончен"].buttons.firstMatch.label, "Сыграть еще раз")
        
    }
    
    func testRegame() {
        sleep(3)
        for _ in 0..<10 {
            app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
            sleep(3)
        }
        
        XCTAssertTrue(app.alerts["Раунд окончен"].exists)
        XCTAssertEqual(app.alerts["Раунд окончен"].buttons.firstMatch.label, "Сыграть еще раз")
        
        app.alerts["Раунд окончен"].buttons.firstMatch.tap()
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertEqual(indexLabel.label, "1/10")
        
    }
    
}
