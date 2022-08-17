//
//  ProjectUsecaseTests.swift
//  ProjectManagerTests
//
//  Created by Tiana, mmim on 2022/07/29.
//

@testable import ProjectManager
import XCTest
import RxRelay

class ProjectUsecaseTests: XCTestCase {
    
    var sut: ProjectUseCaseProtocol!
    var stubPersistentManager: StubPersistentManager!
    var stubNetworkManager: StubNetworkManager!
    var stubHistory: StubHistoryManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        stubPersistentManager = StubPersistentManager()
        stubNetworkManager = StubNetworkManager()
        stubHistory = StubHistoryManager()
        
        sut = DefaultProjectUseCase(
            projectRepository: PersistentRepository(
                projectEntities: BehaviorRelay<[ProjectEntity]>(value: []),
                persistentManager: stubPersistentManager
            ),
            networkRepository: NetworkRepository(networkManger: stubNetworkManager),
            historyRepository: HistoryRepository(historyManager: stubHistory)
        )
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_create_데이터넣으면_locaolDB에_저장되는지() {
        // given
        let data = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        
        // when
        sut.create(projectEntity: data)
        
        // then
        XCTAssertEqual(stubPersistentManager.stubCoreData.projects.first!.id, data.id.uuidString)
    }
    
    func test_read_하면_locaolDB의_전체_데이터가_나오는지() {
        // given
        let dataToCreate = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        sut.create(projectEntity: dataToCreate)
        
        // when
        let data = sut.read()
        
        // then
        XCTAssertEqual(data.value.count, 1)
        XCTAssertEqual(data.value.first!.id, dataToCreate.id)
    }
    
    func test_read_id로_읽으면_해당_데이터가_나오는지() {
        // given
        let dataToCreate = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        sut.create(projectEntity: dataToCreate)
        
        // when
        let data = sut.read(projectEntityID: dataToCreate.id)
        
        // then
        XCTAssertEqual(data!.title, dataToCreate.title)
    }
    
    func test_update_데이터넣으면_locaolDB에서_해당_데이터가_수정되는지() {
        // given
        let dataToCreate = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        sut.create(projectEntity: dataToCreate)
        
        // when
        let dataToUpdate = ProjectEntity(id: dataToCreate.id, title: "upateTest", deadline: Date(), body: "test_body")
        sut.update(projectEntity: dataToUpdate)
        
        // then
        XCTAssertEqual(stubPersistentManager.stubCoreData.projects.first!.title, dataToUpdate.title)
        XCTAssertEqual(stubPersistentManager.stubCoreData.projects.first!.body, dataToUpdate.body)
    }
    
    func test_delete_ID넣으면_locaolDB에서_해당_데이터가_제거되는지() {
        // given
        let firstDataToCreate = ProjectEntity(title: "test1", deadline: Date(), body: "test_body1")
        let secondDataToCreate = ProjectEntity(title: "test2", deadline: Date(), body: "test_body2")
        sut.create(projectEntity: firstDataToCreate)
        sut.create(projectEntity: secondDataToCreate)
        
        // when
        sut.delete(projectEntityID: firstDataToCreate.id)
        
        // then
        XCTAssertEqual(stubPersistentManager.stubCoreData.projects.count, 1)
        XCTAssertEqual(stubPersistentManager.stubCoreData.projects.first!.id, secondDataToCreate.id.uuidString)
    }
    
    func test_load_하면_remoetDB의_전체_데이터가_localDB에_저장되는지() {
        // when
        _ = sut.load()
        
        // then
        XCTAssertEqual(stubPersistentManager.stubCoreData.projects.first!.title, "title111")
    }
    
    func test_backUp_하면_localDB의_데이터가_remoteDB에_저장되는지() {
        // given
        let dataToCreate = ProjectEntity(title: "test", deadline: Date(), body: "test_body")
        sut.create(projectEntity: dataToCreate)
        
        // when
        sut.backUp()
        
        // then
        let data = stubNetworkManager.stubFirebase.stubDatabase[dataToCreate.id.uuidString]
        
        XCTAssertEqual(stubNetworkManager.stubFirebase.stubDatabase.count, 1)
        XCTAssertEqual(data!["title"], "test")
    }
    
    func test_createHistory_HistoryEntity_넣으면_hitory가_저장되는지() {
        // given
        _ = sut.load()
        let data = sut.read().value.first
        
        sut.update(
            projectEntity: ProjectEntity(
                id: data!.id,
                status: ProjectStatus.doing,
                title: data!.title,
                deadline: DateFormatter().formatted(string: data!.deadline)!,
                body: data!.body
            )
        )
        
        // when
        sut.createHistory(
            historyEntity: HistoryEntity(
                editedType: EditedType.move,
                title: data!.title,
                date: DateFormatter().formatted(string: data!.deadline)!.timeIntervalSince1970
            )
        )
        
        // then
        let history = stubHistory.stubHistoryEntities
        XCTAssertEqual(history.value.count, 1)
    }
    
    func test_readHistory_하면_hitory의_데이터가_나오는지() {
        // given
        _ = sut.load()
        let data = sut.read().value.first
        
        sut.update(
            projectEntity: ProjectEntity(
                id: data!.id,
                status: ProjectStatus.doing,
                title: data!.title,
                deadline: DateFormatter().formatted(string: data!.deadline)!,
                body: data!.body
            )
        )
        
        sut.createHistory(
            historyEntity: HistoryEntity(
                editedType: EditedType.move,
                title: data!.title,
                date: DateFormatter().formatted(string: data!.deadline)!.timeIntervalSince1970
            )
        )
        
        sut.update(
            projectEntity: ProjectEntity(
                id: data!.id,
                status: ProjectStatus.doing,
                title: "changed",
                deadline: DateFormatter().formatted(string: data!.deadline)!,
                body: data!.body
            )
        )
        
        sut.createHistory(
            historyEntity: HistoryEntity(
                editedType: EditedType.edit,
                title: data!.title,
                date: DateFormatter().formatted(string: data!.deadline)!.timeIntervalSince1970
            )
        )
        
        // when
        _ = sut.readHistory()
        
        // then
        let history = stubHistory.stubHistoryEntities
        XCTAssertEqual(history.value.count, 2)
    }
}
