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
    init() {
        RequestMethod.url = EntryPoint.database(child: "user").url
    }
}

extension RemoteManager: RemoteManagerProtocol {
    func read() -> Observable<[ProjectDTO]> {
        return Observable.create { emitter in
            
            let request = RequestMethod.get.urlRequest
            NetworkService.shared.request(with: request) {
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
        var dic: [String: [String: String]] = [:]
        projects.forEach { dic[$0.id] = ["id": $0.id, "status": $0.status,
                                         "title": $0.title,
                                         "deadline": $0.deadline,
                                         "body": $0.body] }
        
        guard let data = try? JSONEncoder().encode(dic) else {
            NetworkError.encodeError.printIfDebug()
            return
        }
        
        let request = RequestMethod.put(data: data).urlRequest
        NetworkService.shared.request(with: request) {
            switch $0 {
            case .failure(let error):
                error.printIfDebug()
            default:
                break
            }
        }
    }
}
