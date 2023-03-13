//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Алексей Тиньков on 13.03.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
