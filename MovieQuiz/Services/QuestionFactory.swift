//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Алексей Тиньков on 12.03.2023.
//

import Foundation

final class QuestionFactory : QuestionFactoryProtocol {
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    
    /*private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                     text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 9,2
                     correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 9
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 8,1
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 8
                     correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 8
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 6,6
                     correctAnswer: true),
        QuizQuestion(image: "Old",
                     text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 5,8
                     correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 4,3
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 5,1
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     text: "Рейтинг этого фильма больше чем 6?", //Настоящий рейтинг: 5,8
                     correctAnswer: false)
    ]*/
    
    private var movies: [MostPopularMovie] = []
    private var questionsIndex: [Int] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    private func makeQuestion(_ rating : Float) -> (String, Bool) {
        print("rating = \(rating)")
        var questionRating = (7...9).randomElement() ?? 7
        if Float(questionRating) == rating { questionRating -= 1 }
        return ("Рейтинг этого фильма больше чем \(questionRating)?", rating > Float(questionRating))
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if self.questionsIndex.count == 0 { self.questionsIndex = Array(0..<self.movies.count) }
            let index = (0..<self.questionsIndex.count).randomElement() ?? 0
            if self.questionsIndex.count == 0 { return }
            guard let movie = self.movies[safe: self.questionsIndex.remove(at: index)] else { return }
            
            var imageData = Data()
           
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didFailToLoadImage(with: error)
                }
                return
            }
            
            let text: String
            let correctAnswer: Bool
            (text, correctAnswer) = self.makeQuestion(Float(movie.rating) ?? 0)
            
            let question = QuizQuestion(image: imageData,
                                         text: text,
                                         correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    func loadData() {
            moviesLoader.loadMovies { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success(let mostPopularMovies):
                        self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                        self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
                    case .failure(let error):
                        self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
                    }
                }
            }
        }
    
    
} 
