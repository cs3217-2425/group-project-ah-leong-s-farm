//
//  GridViewModel.swift
//  Ah Leongs Farm
//
//  Created by Jerry Leong on 4/4/25.
//

struct GridViewModel {
    let row: Int
    let column: Int
    let doesPlotExist: Bool
}

protocol GridDataProvider: AnyObject {
    func getGridViewModel(row: Int, column: Int) -> GridViewModel
}
