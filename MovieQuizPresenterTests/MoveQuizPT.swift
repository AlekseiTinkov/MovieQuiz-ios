//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Алексей Тиньков on 12.04.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMockk: MovieQuizViewControllerProtocol {
    
    var result: QuizResultsViewModel = QuizResultsViewModel(title: "", text: "", buttonText: "")
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    
    func show(quiz result: QuizResultsViewModel) {
        self.result = result
    }
    
    func showNetworkError(message: String, completion: @escaping ()->Void) {
        completion()
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func highlightImageBorder(highlightOn: Bool, isCorrectAnswer: Bool) {
        
    }
    
    func buttonEnabled(_ isEnabled: Bool) {
        
    }
}

final class MovieQuizPT: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMockk()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        sut.didReceiveNextQuestion(question: QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true))
        
        pause(1)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewControllerMock.result.text, question.text)
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
