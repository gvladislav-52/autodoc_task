//
//  Routing.swift
//  autodoc_task
//
//  Created by gvladislav-52 on 22.07.2026.
//

import Foundation

protocol Routing: AnyObject {
    func route(to route: AppRoute)
    func pop(animated: Bool)
    func dismiss(animated: Bool)
}
