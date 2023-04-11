//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Алексей Тиньков on 10.04.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    private var correctAnswers: Int = 0
    weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService!
    //private var alertPresenter: AlertPresenter?
    
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func isLastQuestion() -> Bool { //+
        currentQuestionIndex == questionsAmount - 1
    }
    
//    func resetQuestionIndex() {
//        currentQuestionIndex = 0
//    }
    
    func switchToNextQuestion() { //+
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel { //+
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() { //+
//        guard let currentQuestion else { return }
//        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() { //+
//        guard let currentQuestion else { return }
//        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) { //+
        guard let currentQuestion else { return }
        //viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == isYes)
        proceedWithAnswer(isCorrect: currentQuestion.correctAnswer == isYes)
    }
    
    private func proceedWithAnswer(isCorrect: Bool) { //+
        didAnswer(isCorrectAnswer: isCorrect)

        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    private func proceedToNextQuestionOrResults() { //+
        if self.isLastQuestion() {
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: makeResultsMessage(),
                buttonText: "Сыграть ещё раз")
                viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func didAnswer(isCorrectAnswer: Bool) { //+
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) { //+
        guard let question else { return }
        //viewController?.hideLoadingIndicator()
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didFailToLoadData(with error: Error) { //+
        //guard let questionFactory else { return }
        viewController?.showNetworkError(message: error.localizedDescription) //, completion: questionFactory.loadData)
    }
    
    func didFailToLoadImage(with error: Error) { //+
        //guard let questionFactory else { return }
        viewController?.showNetworkError(message: error.localizedDescription)//, completion: questionFactory.requestNextQuestion)
    }
    
    func didLoadDataFromServer() { //+
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func restartGame() { //+
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
//    func showNextQuestionOrResults() {
//        if !isLastQuestion() {
//            self.switchToNextQuestion()
//            viewController?.showLoadingIndicator()
//            questionFactory?.requestNextQuestion()
//        } else {
//            guard let statisticService else { return }
//            statisticService.store(correct: correctAnswers, total: questionsAmount)
//            let text = """
//                Ваш результат: \(correctAnswers) из \(questionsAmount)
//                Колтчество сыграных квизов: \(statisticService.gamesCount)
//                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
//                Средняя точность: \(String(format: "%.2f",(statisticService.totalAccuracy) / Double(statisticService.gamesCount) * 100.0))%
//                """
//            let viewModel = QuizResultsViewModel(
//                title: "Раунд окончен",
//                text: text,
//                buttonText: "Сыграть ещё раз")
//            viewController?.show(quiz: viewModel)
//        }
//    }
    
    func makeResultsMessage() -> String { //+
        statisticService.store(correct: correctAnswers, total: questionsAmount)

        let resultsMessage = """
            Ваш результат: \(correctAnswers) из \(questionsAmount)
            Колтчество сыграных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f",(statisticService.totalAccuracy) / Double(statisticService.gamesCount) * 100.0))%
            """

        return resultsMessage
    }
    
    
} 
