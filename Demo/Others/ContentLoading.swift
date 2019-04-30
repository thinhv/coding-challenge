//
//  ContentLoading.swift
//  Demo
//
//  Created by Thinh Vo Duc on 29/04/2019.
//  Copyright © 2019 Thinh Vo. All rights reserved.
//

import Foundation

@objc enum LoadingState: Int {
    case initial
    case loading
    case loaded
    case error
}

protocol ContentLoading: NSObjectProtocol {
    var loadingState: LoadingState { get }

    func reloadData()
}
