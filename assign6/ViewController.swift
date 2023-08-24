//
//  ViewController.swift
//  assign6
//
//  Created by 김태윤 on 2023/08/22.
//

import UIKit
import SnapKit
class ViewController: UIViewController {
    let configureExBtn: (UIAction)->UIButton = { action in
        let btn = UIButton(configuration: .filled())
        btn.setTitle("Example1", for: .normal)
        btn.addAction(action, for: .touchUpInside)
        return btn
    }
    lazy var ex1Btn:UIButton = currying(num: 1)(.init(handler: {[weak self] _ in
        let vc = Example1VC()
        self?.present(vc,animated: true)
    }))
    lazy var ex2Btn:UIButton = currying(num: 2)(.init(handler: { [weak self] _ in
        let vc = Example2VC()
        self?.navigationController?.pushViewController(vc, animated: true)
    }))
    lazy var ex3Btn:UIButton = currying(num: 3)(.init(handler: { [weak self] _ in
        let vc = Example1VC()
        self?.present(vc,animated: true)
    }))
    override func viewDidLoad() {
        super.viewDidLoad()
        [ex1Btn,ex2Btn,ex3Btn]
        self.navigationItem.rightBarButtonItem = .init(image: .init(systemName: "map"), style: .plain, target: self, action: #selector(Self.goMapTapped(_:)))
        self.navigationItem.leftBarButtonItem = .init(image: .init(systemName: "popcorn"), style: .plain, target: self, action: #selector(Self.goMovies(_:)))
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func goMovies(_ sender:UIBarButtonItem){
        let alert = UIAlertController(title: "어디로 갈래?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "메인 뷰", style: .default){ [weak self] _ in
            self?.navigationController?.pushViewController(MovieMainVC(), animated: true)
        })
        alert.addAction(.init(title: "로그인 뷰", style: .default){[weak self] _ in
            self?.present(MovieLoginVC(), animated: true)
        })
        alert.addAction(.init(title: "취소", style: .cancel))
        self.present(alert,animated: true)
    }
    @objc func goMapTapped(_ sender: UIBarButtonItem){
        let vc = MapVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func currying(num:Int)->(UIAction)->UIButton{
        let configureExBtn: (UIAction)->UIButton = {[weak self] action in
            guard let self else {
                print("이상이상")
                return .init()
            }
            let btn = UIButton(configuration: .filled())
            btn.setTitle("Example\(num)", for: .normal)
            btn.addAction(action, for: .touchUpInside)
            let guide = self.view.safeAreaLayoutGuide
            self.view.addSubview(btn)
            btn.snp.makeConstraints { make in
                if num == 1{ make.top.equalTo(guide)
                }else if num == 2{ make.centerY.equalTo(guide)
                }else{ make.bottom.equalTo(guide)
                }
                make.centerX.equalToSuperview()
                make.width.equalTo(200)
                make.height.equalTo(100)
            }
            return btn
        }
        return configureExBtn
    }
}

