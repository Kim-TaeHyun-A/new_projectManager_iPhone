//
//  RemoteManager.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/19.
//

import FirebaseDatabase
import RxSwift

protocol RemoteManagerProtocol {
    func read() -> Single<[ProjectDTO]>
    func update(projects: [ProjectDTO])
}

final class RemoteManager {
    private let networkServie: NetworkServiceProtocol
    
    init(networkServie: NetworkServiceProtocol) {
        self.networkServie = networkServie
    }
}

extension RemoteManager: RemoteManagerProtocol {
    func read() -> Single<[ProjectDTO]> {
        return Single.create { [weak self] single in
            self?.networkServie.request(with: EndPoint.database(child: "user").url, method: .get) {
                switch $0 {
                case .success(let data):
                    guard let projects = try? JSONDecoder().decode([String: ProjectDTO].self, from: data) else {
                        NetworkError.decodeError.printIfDebug()
                        return
                    }
                    single(.success(Array(projects.values)))
                case .failure(let error):
                    error.printIfDebug()
                }
            }
            return Disposables.create()
        }
    }
    
    func update(projects: [ProjectDTO]) {
        let data = parse(from: projects)
        networkServie.request(with: EndPoint.database(child: "user").url, method: .put(data: data)) {
            switch $0 {
            case .failure(let error):
                error.printIfDebug()
            default:
                break
            }
        }
    }
}

extension RemoteManager {
    private func parse(from projects: [ProjectDTO]) -> [String: [String: String]] {
        var value: [String: [String: String]] = [:]
        projects.forEach { value[$0.id] = ["id": $0.id,
                                           "status": $0.status,
                                           "title": $0.title,
                                           "deadline": $0.deadline,
                                           "body": $0.body] }
        
        return value
    }
}
