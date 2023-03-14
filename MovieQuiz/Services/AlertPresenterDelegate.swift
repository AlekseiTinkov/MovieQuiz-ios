//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Алексей Тиньков on 13.03.2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    //var currentQuestionIndex: Int { get set }
    //var correctAnswers: Int { get set }
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    
    //func didReceiveNextQuestion(question: QuizQuestion?)
}
