//
//  MenuBarViewModel.swift
//  Nova
//
//  Created by Andrej Jurkin on 13/09/17.
//  Copyright © 2017 Andrej Jurkin. All rights reserved.
//

import Foundation
import RxSwift

class MenuBarViewModel {
    
    let api = Api.shared
    
    let prefs = Prefs.shared
    
    var menuBarText = Variable("N O V A")
    
    var pinnedSymbols: Variable<[String]> = Variable([])
    
    var isRefreshing = Variable<Bool>(false)
    
    var pinnedCurrencies = Variable<[String: Double]>([:])
    
    let disposeBag = DisposeBag()
    
    init() {
        
        self.subscribeForTickerUpdates(base: "OMG", refreshInterval: 30.0)
        self.subscribeForTickerUpdates(base: "BTC", refreshInterval: 30.0)

    }
    
    func refresh() {
        
    }
    
    
    
    /// Subscribe for ticker updates
    ///
    /// - parameters:
    ///    - base: The base currency symbol (1 base unit is priced at x target units)
    ///    - refreshInterval: The ticker refresh interval in seconds
    func subscribeForTickerUpdates(base: String, refreshInterval: Float) {
        Observable<Int>.interval(RxTimeInterval(refreshInterval), scheduler: MainScheduler.instance)
            .flatMap { _ -> Observable<CryptonatorTickerResponse> in
                return Api.shared.getTicker(base: base, target: self.prefs.targetCurrency)
            }
            .subscribe(onNext: { response in
                guard response.success == true, let ticker = response.ticker else {
                    return
                }
                
                self.pinnedCurrencies.value[ticker.base] = ticker.price
            })
            .addDisposableTo(disposeBag)
    }

}
