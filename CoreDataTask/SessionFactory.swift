//
//  SessionFactory.swift
//  CoreDataTask
//
//  Created by Лада on 22/11/2019.
//  Copyright © 2019 Лада. All rights reserved.
//

import UIKit

class SessionFactory {
    func createDefaultSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }
}
