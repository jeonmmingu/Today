import UIKit
// << 2nd >> - Controller 이름이랑 상속을 바꾸고 스토리보드에 적용
class ReminderListViewController: UICollectionViewController {
    // optional 값을 unwrapping 해서 사용하는 것은 매우 위험하다. 때문에 바로 초기화를 해주는 것이 run time error가 발생하지 않도록 하는 방법이다.
    // 이번 프로젝트 같은 경우 viewDidLoad 오버라이드 함수에서 바로 초기화를 진행한다.
    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // << 3rd >>
        let listLayout = listLayout()
        // collectionView layout 설정
        collectionView.collectionViewLayout = listLayout
        
        // << 4th >>
        // cell 구성 정보를 저장
        // data source에 관련된 내용은 따로 swift 파일을 만들어 분리
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        // << 5th >>
        // DataSource의 인자: collectionView & Reusable Cell에 대한 클로저
        // 데이터 정보를 가지고 있는 cell과 collectionView를 연결
        // Dequeue를 사용한 이유: 매번 cell을 만들어서 등록하는 절차는 매우 cost가 많이 든다. 때문에 Cell을 Reuse하여 사용.(cellRegistration을 통해 구현)
        // item이 혹시 위에 reminder.title이 아닐까 함..
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        updateSnapshot()
        
        // << 7th >>
        collectionView.dataSource = dataSource
    }
    
    // << 3rd >>
    // list layout에서 section을 만드는 함수이다.
    private func listLayout() -> UICollectionViewCompositionalLayout{
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false // ??
        listConfiguration.backgroundColor = .clear
        // 반환값이 UICollectionViewCompositionalLayout이기 때문에 변환해서 반환 값을 주어야 한다.
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}

