import Foundation

// << 1st >>
// struct는 initialize가 자동으로 이뤄지기 때문에 초기화를 하지 않아도 오류가 발생하지 않는다.
struct Reminder{
    var title: String
    var dueDate: Date
    var notes: String? = nil
    var isComplete: Bool = false
}

// Release 되어 컴파일 되는 경우 실행되지 않도록 동봉하는 플래그이다.
// static keyword: Type Property를 선언하기 위해서 사용되는 키워드이다.
// Reminder 구조체를 선언하는 경우 전부 다 sampleData를 공유하게 된다.
#if DEBUG
extension Reminder {
    static var sampleData = [
            Reminder(title: "Submit reimbursement report", dueDate: Date().addingTimeInterval(800.0), notes: "Don't forget about taxi receipts"),
            Reminder(title: "Code review", dueDate: Date().addingTimeInterval(14000.0), notes: "Check tech specs in shared folder", isComplete: true),
            Reminder(title: "Pick up new contacts", dueDate: Date().addingTimeInterval(24000.0), notes: "Optometrist closes at 6:00PM"),
            Reminder(title: "Add notes to retrospective", dueDate: Date().addingTimeInterval(3200.0), notes: "Collaborate with project manager", isComplete: true),
            Reminder(title: "Interview new project manager candidate", dueDate: Date().addingTimeInterval(60000.0), notes: "Review portfolio"),
            Reminder(title: "Mock up onboarding experience", dueDate: Date().addingTimeInterval(72000.0), notes: "Think different"),
            Reminder(title: "Review usage analytics", dueDate: Date().addingTimeInterval(83000.0), notes: "Discuss trends with management"),
            Reminder(title: "Confirm group reservation", dueDate: Date().addingTimeInterval(92500.0), notes: "Ask about space heaters"),
            Reminder(title: "Add beta testers to TestFlight", dueDate: Date().addingTimeInterval(101000.0),  notes: "v0.9 out on Friday")
        ]
}
#endif
