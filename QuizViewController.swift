import UIKit

struct Question {
    let text: String
    let correctAnswer: String
}

class QuizCounter {
    var count = 0
    
    func increment() {
        count += 1
    }
    
    func reset() {
        count = 0
    }
}

class Quiz {
    let questions: [Question]
    let counter = QuizCounter()
    
    init(questions: [Question]) {
        self.questions = questions
    }
}

class QuizViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var quiz: Quiz!
    var currentQuestionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let question1 = Question(text: "Is the earth round?", correctAnswer: "Yes")
        let question2 = Question(text: "Is the sky green?", correctAnswer: "No")
        let questions = [question1, question2]
        quiz = Quiz(questions: questions)
        
        loadQuestion()
    }
    
    func loadQuestion() {
        let currentQuestion = quiz.questions[currentQuestionIndex]
        questionLabel.text = currentQuestion.text
    }
    
    @IBAction func yesButtonPressed(_ sender: UIButton) {
        checkAnswer(userAnswer: "Yes")
    }
    
    @IBAction func noButtonPressed(_ sender: UIButton) {
        checkAnswer(userAnswer: "No")
    }
    
    @IBAction func resetScoreButtonPressed(_ sender: UIButton) {
        quiz.counter.reset()
        scoreLabel.text = "Score: \(quiz.counter.count)"
    }
    
    func checkAnswer(userAnswer: String) {
        if userAnswer == quiz.questions[currentQuestionIndex].correctAnswer {
            quiz.counter.increment()
        }
        scoreLabel.text = "Score: \(quiz.counter.count)"
        
        // 다음 질문으로 넘어가거나, 질문이 모두 끝났다면 처음으로 돌아갑니다.
        if currentQuestionIndex < quiz.questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            currentQuestionIndex = 0
        }
        loadQuestion()
    }
}
