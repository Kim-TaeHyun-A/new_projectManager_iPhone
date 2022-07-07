//
//  ProjectContent.swift
//  ProjectManager
//
//  Created by Tiana, mmim on 2022/07/06.
//

import Foundation

struct ProjectContent {
    var title: String
    var deadline: String
    var description: String
    
    init(_ item: ProjectItem) {
        self.title = item.title
        self.deadline = DateFormatter().formatted(date: item.deadline)
        self.description = item.description
    }
    
    func asProjectItem() -> ProjectItem? {
        guard let deadline = DateFormatter().formatted(string: deadline) else {
            return nil
        }
        return ProjectItem(title: title, deadline: deadline, description: description)
    }
    
    mutating func editContent(title: String? = nil,
                              deadline: Date? = nil,
                              description: String? = nil
    ) {
        if let title = title {
            self.title = title
        }
        
        if let deadline = deadline {
            self.deadline = DateFormatter().formatted(date: deadline)
        }
        
        if let description = description {
            self.description = description
        }
    }
}

fileprivate extension DateFormatter {
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .long
        dateFormatter.locale = .autoupdatingCurrent
        
        return dateFormatter
    }
    
    func formatted(string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
    
    func formatted(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
