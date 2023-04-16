//
//  QuestionFactoryTest.swift
//  MovieQuizTests
//
//  Created by Алексей Тиньков on 13.04.2023.
//

import XCTest
import zlib
@testable import MovieQuiz

class QuestionFactoryPresenter: QuestionFactoryDelegate {
    
    private var questionFactory: QuestionFactoryProtocol?
    private var dataLoaded: (_: Bool)->Void = { _ in }
    
    var imageVariants: Set<uLong> = []
    var questionVariants: Set<String> = []
    var answerVariants: Set<Bool> = []
    
    private var questionCount: Int = 0
    private var testQuestionCount: Int
    
    init(testQuestionCount: Int) {
        self.testQuestionCount = testQuestionCount
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    }
    
    func loadData(dataLoaded: @escaping (_: Bool)->Void) {
        self.dataLoaded = dataLoaded
        questionFactory?.loadData()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        let data = question.image
        let checksum = data.withUnsafeBytes { crc32(0, $0.bindMemory(to: Bytef.self).baseAddress, uInt(data.count)) }
        imageVariants.insert(checksum)
        print("crc32: 0x\(String(format:"%08X", checksum))")
        
        questionVariants.insert(question.text)
        answerVariants.insert(question.correctAnswer)
        
        questionCount += 1
        if questionCount == testQuestionCount { self.dataLoaded(true) }
        
        questionFactory?.requestNextQuestion()
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        self.dataLoaded(false)
    }
    
    func didFailToLoadImage(with error: Error) {
        self.dataLoaded(false)
    }
    
}

// тест класса QuestionFactory
// - проверяет успешность загрузки данных
// - проверяет работу алгоритма выборки не повторяющихся впоросов путем сверки СRC32 полученных картинок
// - вариативность вопросов и ответов

class QuestionFactoryTest: XCTestCase {
    
    func testQuestionFactory() throws {
        let testQuestionCount = 50 // число запрашиваемых тестом вопросв (до 250)
        let questionFactoryPresenter = QuestionFactoryPresenter(testQuestionCount: testQuestionCount)

        let expectation = expectation(description:  "Loading expectation")
        
        questionFactoryPresenter.loadData { result in
            XCTAssertTrue(result)
            XCTAssertEqual(questionFactoryPresenter.imageVariants.count, testQuestionCount) // сверяем число уникальных картинок с числом запрошенных вопросов
            XCTAssert(questionFactoryPresenter.questionVariants.count > 1)
            XCTAssertEqual(questionFactoryPresenter.answerVariants.count, 2)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 60)
    }
    
}
