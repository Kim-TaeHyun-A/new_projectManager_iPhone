//
//  StubNetworkManager.swift
//  ProjectManagerTests
//
//  Created by Tiana, mmim on 2022/07/29.
//

@testable import ProjectManager
import RxSwift

struct DummyData {
    static private let deadline = Calendar.current.date(byAdding: .day, value: 1, to: Date())!

    static let data = ProjectDTO(
        id: UUID().uuidString,
        status: ProjectStatus.todo.string,
        title: "title111",
        deadline: String(deadline.timeIntervalSince1970),
        body: "bodyttt"
    )
}

final class StubFirebase {
    let error: Error?
    private let dummyData = DummyData.data
    var stubDatabase: [String: [String: String]] = [:]
    
    init(error: Error?) {
        self.error = error
        
        stubDatabase[dummyData.id] = ["id": dummyData.id,
                                    "status": dummyData.status,
                                    "title": dummyData.title,
                                    "deadline": dummyData.deadline,
                                    "body": dummyData.body]
    }
    
    func getData(completion: @escaping (Error?, [String: [String: String]]?) -> Void) {
        completion(error, stubDatabase)
    }
    
    func setValue(_ newData: [String: [String: String]]) {
        stubDatabase = newData
    }
}

final class StubNetworkManager {
    let stubFirebase = StubFirebase(error: nil)
}

extension StubNetworkManager: NetworkManagerProtocol {
    func read() -> Observable<[ProjectDTO]> {
        
        return Observable.create { [weak self] emitter in
            
            self?.stubFirebase.getData { error, snapshot in
                guard error == nil else {
                    return
                }
                
                guard let value = snapshot,
                      let data = try? JSONSerialization.data(withJSONObject: value.map { $1 }),
                      let projects = try? JSONDecoder().decode([ProjectDTO].self, from: data) else {
                    return
                }
                
                emitter.onNext(projects)
            }
            
            return Disposables.create()
        }
    }
    
    func update(projects: [ProjectDTO]) {
        var newData: [String: [String: String]] = [:]
        
        projects.forEach {
            newData[$0.id] = [
                "id": $0.id,
                "status": $0.status,
                "title": $0.title,
                "deadline": $0.deadline,
                "body": $0.body
            ]
        }
        
        stubFirebase.setValue(newData)
    }
}
