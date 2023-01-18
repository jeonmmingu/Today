import UIKit
// 이렇게 기존의 ViewController로부터 내용을 분리함으로써 간결한 구조의 코딩을 진행할 수 있다.

extension ReminderListViewController {
    // << 5th >>
    // typealias: 타입에 별칭을 붙일 때 사용하는 Keyword 입니다.
    // 즉 UICollectionViewDiffableDataSource<Int, String> 이러한 타입을 DataSource라고 지정했다고 보면 됨.
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    // << 6th >>
    // Diffable Data Source는 Snapshot을 사용하여 데이터를 관리한다.
    // 즉 Snapshot 타입을 만든 이유는 Datasource에게 데이터가 변했다는 것을 알리기 위해서 이다.
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: String) {
        let reminder = Reminder.sampleData[indexPath.item]
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        // 제목을 강조하기 위해 dayAndTimeText를 작게 함
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        // disclosureIndicator: ">" 표시이다.
        // 기본적으로 accessories는 trailing 방향에 존재한다.
        cell.accessories = [ .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)]
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration{
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = UIButton()
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
}
