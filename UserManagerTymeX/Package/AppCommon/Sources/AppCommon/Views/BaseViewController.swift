//
//  BaseViewController.swift
//  AppCommon
//
//  Created by nguyen minh tuan on 2/23/25.
//

import UIKit
import RxSwift
import RxCocoa

open class BaseViewController: UIViewController {
    public let disposeBag = DisposeBag()

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        print("🔴 🔴 🔴  [inited] --> \(self.identifierString)")
        setupUI()
        setupBinding()
    }
    deinit {
        print("🟢 🟢 🟢 [deinited] \(self.identifierString)")
    }
    open func setupUI() {

    }
    open func setupBinding() {

    }
}
