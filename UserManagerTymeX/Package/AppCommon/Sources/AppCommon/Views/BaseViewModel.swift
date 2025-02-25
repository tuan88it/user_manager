//
//  BaseViewModel.swift
//  AppCommon
//
//  Created by nguyen minh tuan on 2/23/25.
//

import RxSwift
import RxCocoa
import Foundation

open class BaseViewModel: NSObject {
    
    public let disposeBag = DisposeBag()
    
    public let loading = ActivityIndicator()
    public let headerLoading = ActivityIndicator()
    public let footerLoading = ActivityIndicator()
    public let limitRequest = ActivityIndicator()
    
    public override init() {
        super.init()
        print("🔴 🔴 🔴  [inited] --> \(self.identifierString)")
    }
    public var showLoading: Observable<Bool> {
        return self.loading.asObservable()
    }
    
    public var showHeaderLoading: Observable<Bool> {
        return self.headerLoading.asObservable()
    }
    
    public var showFooterLoading: Observable<Bool> {
        return self.footerLoading.asObservable()
    }
    deinit {
        print("🟢 🟢 🟢 [deinited] \(self.identifierString)")
    }
}
