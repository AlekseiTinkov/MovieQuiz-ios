import UIKit

final class MovieQuizViewController: UIViewController {

//    private var currentQuestionIndex: Int = 0
//    private var correctAnswers: Int = 0
//    private let questionsAmount: Int = 10
//    private var questionFactory: QuestionFactoryProtocol?
//    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
//    private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
//        presenter.viewController = self
//        textLabel.isEnabled = false
        imageView.layer.cornerRadius = 20
//        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
//        statisticService = StatisticServiceImplementation()
//        showLoadingIndicator()
//        questionFactory?.loadData()
    }
    
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
//    }
    
    func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        textLabel.isEnabled = true
        noButton.isEnabled = true // включаем обработку нажатия кнопок
        yesButton.isEnabled = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
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
//                self.presenter.resetQuestionIndex()
//                self.correctAnswers = 0
//                self.showLoadingIndicator()
//                self.questionFactory?.requestNextQuestion()
                self.presenter.restartGame()
            }))
    }
    
//    private func showNextQuestionOrResults() {
//        if !presenter.isLastQuestion() {
//            presenter.switchToNextQuestion()
//            showLoadingIndicator()
//            questionFactory?.requestNextQuestion()
//        } else {
//            guard let statisticService else { return }
//            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
//            let message = """
//                Ваш результат: \(correctAnswers) из \(presenter.questionsAmount)
//                Колтчество сыграных квизов: \(statisticService.gamesCount)
//                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
//                Средняя точность: \(String(format: "%.2f",(statisticService.totalAccuracy) / Double(statisticService.gamesCount) * 100.0))%
//                """
//            alertPresenter?.showAlert(alert: AlertModel(
//                title: "Раунд окончен",
//                message: message,
//                buttonText: "Сыграть еще раз",
//                completion: { [weak self] in
//                    guard let self else { return }
//                    self.presenter.resetQuestionIndex()
//                    self.correctAnswers = 0
//                    self.showLoadingIndicator()
//                    self.questionFactory?.requestNextQuestion()
//                }))
//        }
//    }
    
//    func showAnswerResult(isCorrect: Bool) {
//        correctAnswers += isCorrect ? 1 : 0
//        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
//        imageView.layer.borderWidth = 8
//        textLabel.isEnabled = false
//        noButton.isEnabled = false // отключаем обработку нажатия кнопок до завершения демонстрации результата
//        yesButton.isEnabled = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
//            guard let self else { return }
//            self.presenter.showNextQuestionOrResults()
//        }
//    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
    }
    
//    private func showNetworkError(message: String, completion: @escaping ()->Void) {
//        hideLoadingIndicator() // скрываем индикатор загрузки
//        alertPresenter?.showAlert(alert: AlertModel(
//            title: "Ошибка",
//            message: message,
//            buttonText: "Попробовать ещё раз",
//            completion: { [weak self] in
//                guard let self else { return }
//                self.showLoadingIndicator()
//                completion()
//            }
//        ))
//    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()

        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)

            let action = UIAlertAction(title: "Попробовать ещё раз",
            style: .default) { [weak self] _ in
                guard let self = self else { return }

                self.presenter.restartGame()
            }

        alert.addAction(action)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
//        guard let currentQuestion else { return }
//        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
//        guard let currentQuestion else { return }
//        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
        presenter.noButtonClicked()
    }

}

//extension MovieQuizViewController: QuestionFactoryDelegate {
//
////    func didReceiveNextQuestion(question: QuizQuestion?) {
////        guard let question else { return }
////        hideLoadingIndicator()
////        presenter.currentQuestion = question
////        let viewModel = presenter.convert(model: question)
////        DispatchQueue.main.async { [weak self] in
////            self?.show(quiz: viewModel)
////        }
////    }
//
//    func didFailToLoadData(with error: Error) {
//        guard let questionFactory else { return }
//        showNetworkError(message: error.localizedDescription, completion: questionFactory.loadData)
//    }
//
//    func didFailToLoadImage(with error: Error) {
//        guard let questionFactory else { return }
//        showNetworkError(message: error.localizedDescription, completion: questionFactory.requestNextQuestion)
//    }
//
//    func didLoadDataFromServer() {
//        questionFactory?.requestNextQuestion()
//    }
//}
