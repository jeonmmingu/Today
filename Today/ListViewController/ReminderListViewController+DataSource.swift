import UIKit
// 이렇게 기존의 ViewController로부터 내용을 분리함으로써 간결한 구조의 코딩을 진행할 수 있다.

extension ReminderListViewController {
    // << 5th >>
    // typealias: 타입에 별칭을 붙일 때 사용하는 Keyword 입니다.
    // 즉 UICollectionViewDiffableDataSource<Int, String> 이러한 타입을 DataSource라고 지정했다고 보면 됨.
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    // << 6th >>
    // Diffable Data Source는 Snapshot을 사용하여 데이터를 관리한다.
    // 즉 Snapshot 타입을 만든 이유는 Datasource에게 데이터가 변했다는 것을 알리기 위해서 이다.
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }
    
    // parameter의 default 값으로 empty array를 준 것은 처음에 viewDidLoad에서 snapshot을 등록하는 경우를 고려해 지정한 것이다.
    func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map{ $0.id })
        if !ids.isEmpty {
            snapshot.reloadItems(ids) // 해당 부분에서 차이가 있음을 알리는 역할을 한다.
        }
        dataSource.apply(snapshot) // snapshot은 diff 객체이기 때문에 다른점을 알려야 apply 시에 데이터 변화가 감지가 된다.
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminder(for: id)
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        // 제목을 강조하기 위해 dayAndTimeText를 작게 함
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        cell.accessibilityCustomActions = [doneButtonAccessibilityAction(for: reminder)]
        cell.accessibilityValue = reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
        
        // disclosureIndicator: ">" 표시이다.
        // 기본적으로 accessories는 trailing 방향에 존재한다.
        cell.accessories = [ .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)]
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    
    func completeReminder(with id: Reminder.ID){
        var reminder = reminder(for: id)
        reminder.isComplete.toggle()
        update(reminder, with: id)
        updateSnapshot(reloading: [id])
    }
    
    
    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
        // 클로저 안에서 외부의 값을 사용하면 보통 강한 순환 참조에 빠지게 된다.
        // 이를 방지하기 위해 [weak self] keyword를 작성해준다.
        let action = UIAccessibilityCustomAction(name: name){ [weak self] action in
            self?.completeReminder(with: reminder.id)
            return true
        }
        return action
    }
    
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside) // touchUpInside : When we touch button in UI Control area
        button.id = reminder.id
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
    // reminder model에 접근가능하도록 하는 함수 정의
    func reminder(for id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(with: id)
        return reminders[index]
    }
    
    // index에 맞는 reminder의 정보를 update 하는 함수
    func update(_ reminder: Reminder, with id: Reminder.ID) {
        let index = reminders.indexOfReminder(with: id)
        reminders[index] = reminder
    }
}
