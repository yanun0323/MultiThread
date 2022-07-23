//
//  MockData.swift
//  MultiThread
//
//  Created by YanunYang on 2022/7/21.
//

import Foundation

struct Mock {
    static var mainViewModel = MockMainViewModel()
    
}

extension Mock {
    static func MockMainViewModel() -> MainViewModel {
        let result = MainViewModel()
        return result
    }
}
