//
//  RemoteManager.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/19.
//

import FirebaseDatabase
import RxSwift

protocol RemoteManagerProtocol {
    func read() -> Observable<[ProjectDTO]>
    func update(projects: [ProjectDTO])
}

final class RemoteManager {
    private let networkServie: NetworkServiceProtocol
    
    init(networkServie: NetworkServiceProtocol) {
        self.networkServie = networkServie
    }
}

extension RemoteManager: RemoteManagerProtocol {
    func read() -> Observable<[ProjectDTO]> {
        return Observable.create { [weak self] emitter in
            
            let request = RequestMethod.get.urlRequest
            self?.networkServie.request(with: request) {
                switch $0 {
                case .success(let data):
                    guard let projects = try? JSONDecoder().decode([String: ProjectDTO].self, from: data) else {
                        NetworkError.decodeError.printIfDebug()
                        return
                    }
                    emitter.onNext(Array(projects.values))
                case .failure(let error):
                    error.printIfDebug()
                }
            }
            return Disposables.create()
        }
    }
    
    func update(projects: [ProjectDTO]) {
        let data = parse(from: projects)
        let request = RequestMethod.put(data: data).urlRequest
        
        networkServie.request(with: request) {
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
    private func parse(from projects: [ProjectDTO]) -> Data? {
        var value: [String: [String: String]] = [:]
        projects.forEach { value[$0.id] = ["id": $0.id,
                                           "status": $0.status,
                                           "title": $0.title,
                                           "deadline": $0.deadline,
                                           "body": $0.body] }
        
        guard let data = try? JSONEncoder().encode(value) else {
            NetworkError.encodeError.printIfDebug()
            return nil
        }
        return data
    }
}
