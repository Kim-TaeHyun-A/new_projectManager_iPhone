
# 💻 프로젝트 매니저

> 프로젝트 기간 2022-07-04 ~

### iPad app 
[바로가기](https://github.com/Kim-TaeHyun-A/ios-project-manager)
 

# Unit Test
추후 기능 추가 시 기존 코드는 동일한 결과를 보이는 것을 보장하기 위해서나 제대로 구현된 것인지 확인하기 위해서 Unit Test를 작성했다.

BehaviorRelay를 사용하는 메서드를 테스트하는데, 모든 구독자에게 변경 사항을 알리는 특징 때문에 원하는 부분만 테스트 진행이 불가능했다.
이를 해결하기 위해서 testDouble을 만들고 실제 타입들과의 의존성을 분리했다.
기존에 protocol을 선언하지 않은 부분을 protocol화 시키면서 Mock, Stub을 만들 수 있었다.

Stub을 사용해서 state verification을 진행한 경우 한 타입 테스트할 때 연쇄적으로 의존하는 모든 타입에 대한 testDouble을 생성하는 문제가 생겼다.
이를 해결하기 위해 Mock 객체를 만들고 behavior verification을 진행했다.

```swift
// state verification with Stub
class ProjectUsecaseTestsWithStub: XCTestCase {
    var sut: ProjectUseCaseProtocol!
    var stubPersistentManager: StubPersistentManager!
    var stubNetworkManager: StubNetworkManager!
    var stubHistoryManager: StubHistoryManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        stubPersistentManager = StubPersistentManager()
        stubNetworkManager = StubNetworkManager()
        stubHistoryManager = StubHistoryManager()
        
        sut = DefaultProjectUseCase(
            projectRepository: PersistentRepository(
                projectEntities: BehaviorRelay<[ProjectEntity]>(value: []),
                persistentManager: stubPersistentManager
            ),
            networkRepository: NetworkRepository(networkManger: stubNetworkManager),
            historyRepository: HistoryRepository(historyManager: stubHistoryManager)
        )
    }
    ...
}
```

```swift
// behavior verification with Mock
final class ProjectUsecaseTestsWithMock: XCTestCase {
    var sut: ProjectUseCaseProtocol!
    var mockPersistentRepository: MockPersistentRepository!
    var mockNetworkRepository: MockNetworkRepository!
    var mockHistoryRepository: MockHistoryRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockPersistentRepository = MockPersistentRepository()
        mockNetworkRepository = MockNetworkRepository()
        mockHistoryRepository = MockHistoryRepository()
        
        sut = DefaultProjectUseCase(
            projectRepository: mockPersistentRepository,
            networkRepository: mockNetworkRepository,
            historyRepository: mockHistoryRepository
        )
    }
    ...
}
```

```swift
// behavior verification with Mock
final class MainVCViewModelTests: XCTestCase {
    var sut: MainVCViewModelProtocol!
    var mockProjectUseCase: MockProjectUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockProjectUseCase = MockProjectUseCase()
        sut = MainVCViewModel(projectUseCase: mockProjectUseCase)
    }
 ...   
}

```

# VC 역할 분리

MVVM 패턴에서 VC는 다른 view와 동일한 역할을 한다. 다른 뷰로 할당할 수 있을 역할을 분리해서 코드량을 100줄 정도 줄이면서 기존의 VC의 역할을 간소화시켰다.

* 전
<img width="284" alt="image" src="https://user-images.githubusercontent.com/70807352/185928816-8691e22f-ac13-4cfe-85bf-e7194ccb4a82.png">

* 후
<img width="235" alt="image" src="https://user-images.githubusercontent.com/70807352/185928472-4f374118-747c-4549-93c3-7cf1ed0e675e.png">

# input & ouput protocol
MVVM에서는 view에 발생하는 Input을 viewModel에서 가공하서 내부에서 output을 만드는 형태이다. 이를 효과적으로 나타내기 위해 protocol을 사용했고, 이 덕분에 testDouble 구현이 가능했다.

```swift
protocol DetailViewModelInputProtocol {
    func read()
    func update(_ content: ProjectEntity)
}

protocol DetailViewModelOutputProtocol {
    var content: ProjectEntity { get }
    var currentProjectEntity: ProjectEntity? { get }
}

protocol DetailViewModelProtocol: DetailViewModelInputProtocol, DetailViewModelOutputProtocol { }

final class DetailViewModel: DetailViewModelProtocol {
    private let projectUseCase: ProjectUseCaseProtocol
    
    // MARK: - Output
    
    var content: ProjectEntity
    var currentProjectEntity: ProjectEntity?
    
    init(projectUseCase: ProjectUseCaseProtocol, content: ProjectEntity) {
        self.projectUseCase = projectUseCase
        self.content = content
    }
    
    private func updateHistory(by content: ProjectEntity) {
        let historyEntity = HistoryEntity(editedType: .edit,
                                          title: content.title,
                                          date: Date().timeIntervalSince1970)
        
        projectUseCase.createHistory(historyEntity: historyEntity)
    }
}

// MARK: - Input

extension DetailViewModel {
    func read() {
        currentProjectEntity = projectUseCase.read(projectEntityID: content.id)
    }
    
    func update(_ content: ProjectEntity) {
        projectUseCase.update(projectEntity: content)
        updateHistory(by: content)
    }
}

```
