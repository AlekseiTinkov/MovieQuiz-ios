//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Алексей Тиньков on 12.04.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMockk: MovieQuizViewControllerProtocol {
    
    var quiz: QuizStepViewModel = QuizStepViewModel(image: UIImage(), question: "", questionNumber: "")
    
    func show(quiz step: QuizStepViewModel) {
        print(">>---- \(step.question)")
        self.quiz = step
    }
    
    func show(quiz result: QuizResultsViewModel) {
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
    func testPresenterConvertModel()  {
        
        let viewControllerMock = MovieQuizViewControllerMockk()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let expectation = expectation(description: "Loading expectation")
        sut.didReceiveNextQuestion(question: QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true))
        
        
        
//        //XCTAssertNotNil(viewModel.image)
//        //XCTAssertEqual(viewControllerMock.quiz.image, nil)
//        XCTAssertEqual(viewControllerMock.quiz.question, question.text)
//        XCTAssertEqual(viewControllerMock.quiz.questionNumber, "1/10")
        
        waitForExpectations(timeout: 5)
        
        XCTAssertEqual(viewControllerMock.quiz.question, question.text)
    }
}
