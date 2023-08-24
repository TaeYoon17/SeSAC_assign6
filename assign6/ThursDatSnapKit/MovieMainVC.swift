//
//  MovieMainVC.swift
//  assign6
//
//  Created by 김태윤 on 2023/08/24.
//

import UIKit
import SnapKit

class MovieMainVC: UIViewController{
    lazy var topView = {
        let v = UIView()
        v.backgroundColor = .orange
        lazy var menuStacks = UIStackView()
        menuStacks.addArrangedSubview({
            let btn = UIButton()
            var config = UIButton.Configuration.plain()
            config.baseForegroundColor = .white
            config.title = "TV 프로그램"
            btn.setTitle("TV 프로그램", for: .normal)
            btn.addAction(.init(handler: {[weak self] _ in
                print("건들지 마")
            }), for: .touchUpInside)
            return btn
        }())
        v.addSubview(menuStacks)
        menuStacks.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        lazy var logoBtn = UIButton()
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .white
        config.title = "N"
        logoBtn.setTitle("N", for: .normal)
        logoBtn.addAction(.init(handler: {[weak self] _ in
            print("로고입니당...")
            self?.dismiss(animated: true)
        }), for: .touchUpInside)
        v.addSubview(logoBtn)
        logoBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(8)
        }
        return v
    }()
}
//MARK: -- ViewController LifeCycle
extension MovieMainVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let imageView = UIImageView(image: .init(named: "picture_demo"))
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(52)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
