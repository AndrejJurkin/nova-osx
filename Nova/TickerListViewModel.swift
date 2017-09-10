//
//  Copyright 2017 Andrej Jurkin.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  TickerListViewModel.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.
//

import Foundation
import RxSwift

class TickerListViewModel {
    
    //TODO: Inject
    private let api = Api.shared
    
    // Raw unfiltered data
    private var data: [Ticker] = []
    
    // Raw data filtered with search string
    var filteredData = Variable<[Ticker]>([])
    
    // User input, filter raw data
    var searchString = Variable<String>("")
    
    var numberOfRows: Int {
        return filteredData.value.count
    }

    let disposeBag = DisposeBag()
    
    private let imageUrlFormat = "https://files.coinmarketcap.com/static/img/coins/128x128/%@.png"
    
    init() {
        api.getTopTickers(limit: 100)
            .subscribe(onNext: { tickers in
                // TODO: Set data, and update filtered data properly
                self.filteredData.value = tickers
            })
            .addDisposableTo(disposeBag)
        
        self.searchString
            .asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { searchStr in
                print(searchStr)
            })
            .addDisposableTo(disposeBag)
    }
    
    func getTicker(row: Int) -> Ticker {
        return self.filteredData.value[row]
    }
    
    func getCurrencyName(row: Int) -> String {
        return self.getTicker(row: row).name
    }
    
    func getCurrencyImageUrl(row: Int) -> URL? {
        let imageName = getTicker(row: row).name.lowercased().replacingOccurrences(of: " ", with: "-")
        let urlString = String.init(format: imageUrlFormat, imageName)
        print ("url: \(urlString)")
        return URL(string: urlString)
    }
}
