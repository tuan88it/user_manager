//
//  ViewController.swift
//  UserManagerTymeX
//
//  Created by nguyen minh tuan on 2/18/25.
//

import UIKit
import Data
import LocalStorage
import RxSwift
import Domain

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    let useCase = DIContainer.shared.container.resolve(FetchUsersUseCase.self)
    let useCaseDetail = DIContainer.shared.container.resolve(FetchUserDetailUseCase.self)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        useCase?.execute(offset: 0, perPage: 20).subscribe(onNext: { [weak self] users in
            guard let self = self else { return }
            print(users)
        }).disposed(by: disposeBag)
        useCaseDetail?.execute(userName: "jvantuyl").subscribe(onNext: { userDetail in
            print(userDetail)
        }).disposed(by: disposeBag)
    }
}

