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
    
    var menuBarText = Variable("")
    
    let disposeBag = DisposeBag()
    
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
                    // TODO: notify error
                    return
                }
                
                print("Ticker updated")
                self.menuBarText.value = String(format: "%@ $%.2f", base, ticker.price)
            })
            .addDisposableTo(disposeBag)
    }

}
