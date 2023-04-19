//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Алексей Тиньков on 12.04.2023.


import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    private(set) var viewModel: QuizStepViewModel!
    var reciveQuestion: (()->Void)!
    
    func show(quiz step: QuizStepViewModel) {
        viewModel = step
        reciveQuestion()
        print(step.question)
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

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let exp = expectation(description: #function)
        let viewControllerMock = MovieQuizViewControllerMock()
        viewControllerMock.reciveQuestion = {
            exp.fulfill()
        }
        let sut = MovieQuizPresenter(viewController: viewControllerMock)

        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        //let viewModel = sut.convert(model: question)
        sut.didReceiveNextQuestion(question: question)
        
        waitForExpectations(timeout: 3)

        XCTAssertNotNil(viewControllerMock.viewModel.image)
        XCTAssertEqual(viewControllerMock.viewModel.question, question.text)
        XCTAssertEqual(viewControllerMock.viewModel.questionNumber, "1/10")
    }
}
