//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Алексей Тиньков on 13.03.2023.
//

import UIKit

final class AlertPresenter {
    private weak var delegate: UIViewController?

    func showAlert(alert: AlertModel) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        let action = UIAlertAction(title: alert.buttonText, style: .default) { _ in
            alert.completion()
        }
        alertController.addAction(action)
        self.delegate?.present(alertController, animated: true, completion: nil)
    }

    init(delegate: UIViewController) {
        self.delegate = delegate
    }
}
