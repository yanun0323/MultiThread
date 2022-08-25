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
        result.Task = UserTaskCollection()
        result.Task.Emergency = [
            UserTask(title: "錢包歷史優化",
                     note: "測試一下這樣的連結會不會通 https://app.clickup.com/t/3780765/PRO-16823",
                     deadline: Date.Parse("2022.12.31","yyyy.MM.dd")),
        ]
        
        result.Task.Processing = [
            UserTask(title: "錢包歷史優化",
                     note: "https://app.clickup.com/t/3780765/PRO-16823",
                     deadline: Date.Parse("2022.12.31", "yyyy.MM.dd")),
            UserTask(title: "已下架交易對搜尋",
                     note: "https://app.clickup.com/t/3780765/PRO-13440")
        ]
        
        result.Task.Todo = [
            UserTask(title: "錢包歷史優化",
                     note: "https://app.clickup.com/t/3780765/PRO-16823",
                     deadline: Date.Parse("2022.12.31", "yyyy.MM.dd")),
            UserTask(title: "已下架交易對搜尋",
                     note: "https://app.clickup.com/t/3780765/PRO-13440"),
            UserTask(title: "錢包歷史優化",
                     note: "一些備註",
                     deadline: Date.Parse("2022.12.31", "yyyy.MM.dd")),
            UserTask(title: "已下架交易對搜尋",
                     note: "https://app.clickup.com/t/3780765/PRO-13440"),
            UserTask(title: "已下架交易對搜尋",
                     note: "https://app.clickup.com/t/3780765/PRO-13440")
        ]
        return result
    }
}
