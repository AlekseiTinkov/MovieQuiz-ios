import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        showLoadingIndicator()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    func show(quiz step: QuizStepViewModel) {
        buttonEnabled(true)
        highlightImageBorder(highlightOn: false, isCorrectAnswer: true)
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        alertPresenter?.showAlert(alert: AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self else { return }
                self.presenter.restartGame()
            }))
    }
    
    func showNetworkError(message: String, completion: @escaping ()->Void) {
        hideLoadingIndicator()
        alertPresenter?.showAlert(alert: AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                guard let self else { return }
                self.showLoadingIndicator()
                completion()
            }
        ))
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
    }
    
    func highlightImageBorder(highlightOn: Bool, isCorrectAnswer: Bool) {
        imageView.layer.borderWidth = highlightOn ? 8 : 0
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func buttonEnabled(_ isEnabled: Bool) {
        textLabel.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }

}
