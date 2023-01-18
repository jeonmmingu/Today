//
//  ViewController.swift
//  Today
//
//  Created by mingu on 2023/01/11.
//

import UIKit
// << 2nd >> - Controller 이름이랑 상속을 바꾸고 스토리보드에 적용
class ReminderListViewController: UICollectionViewController {
    // << 5th >>
    // typealias: 타입에 별칭을 붙일 때 사용하는 Keyword 입니다.
    // 즉 UICollectionViewDiffableDataSource<Int, String> 이러한 타입을 DataSource라고 지정했다고 보면 됨.
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    // << 6th >>
    // Diffable Data Source는 Snapshot을 사용하여 데이터를 관리한다.
    // 즉 Snapshot 타입을 만든 이유는 Datasource에게 데이터가 변했다는 것을 알리기 위해서 이다.
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    // optional 값을 unwrapping 해서 사용하는 것은 매우 위험하다. 때문에 바로 초기화를 해주는 것이 run time error가 발생하지 않도록 하는 방법이다.
    // 이번 프로젝트 같은 경우 viewDidLoad 오버라이드 함수에서 바로 초기화를 진행한다.
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // << 3rd >>
        let listLayout = listLayout()
        // collectionView layout 설정
        collectionView.collectionViewLayout = listLayout
        
        // << 4th >>
        // cell 구성 정보를 저장
        let cellRegistration = UICollectionView.CellRegistration { (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
            let reminder = Reminder.sampleData[indexPath.item]
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = reminder.title
            cell.contentConfiguration = contentConfiguration
        }
        
        // << 5th >>
        // DataSource의 인자: collectionView & Reusable Cell에 대한 클로저
        // 데이터 정보를 가지고 있는 cell과 collectionView를 연결
        // Dequeue를 사용한 이유: 매번 cell을 만들어서 등록하는 절차는 매우 cost가 많이 든다. 때문에 Cell을 Reuse하여 사용.(cellRegistration을 통해 구현)
        // item이 혹시 위에 reminder.title이 아닐까 함..
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        // << 6th >>
        var snapshot = Snapshot()
        // 하나의 섹션을 추가
        snapshot.appendSections([0])
        // map function을 사용하면 Reminder.sampleData 중에 title 정보만 가져올 수 있다.
        snapshot.appendItems(Reminder.sampleData.map { $0.title })
        // data source에 snapshot을 적용: 스냅샷을 적용한다는 것은 데이터의 변경 사항을 사용자의 interface에 반영한다는 의미이다.
        dataSource.apply(snapshot)
        
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

