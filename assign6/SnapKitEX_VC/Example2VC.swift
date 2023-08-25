//
//  Example2VC.swift
//  assign6
//
//  Created by 김태윤 on 2023/08/22.
//

import UIKit
import SnapKit

class Example2VC:UIViewController{
    let imgView = UIImageView(image: .init(named: "picture_demo"))
    lazy var topView:UIView = {
        let view = UIView()
        lazy var closeBtn = {
            let btn = UIButton(configuration: .plain())
            btn.configuration?.contentInsets = .zero
            btn.setImage(.init(UIImage(systemName: "xmark")!), for: .normal)
            btn.addAction(.init(handler: { _ in
                print("hello world!!")
                self.navigationController?.popViewController(animated: true)
            }), for: .touchUpInside)
            btn.tintColor = .white
            return btn
        }()
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        let imageV:(String)->UIImageView = { str in
            let config = UIImage.SymbolConfiguration(scale: .large)
            let im = UIImage(systemName: str, withConfiguration: config)
            let imagev = UIImageView(image: im)
            return imagev
        }
        lazy var stackView = UIStackView(arrangedSubviews: [imageV("gift"),imageV("dice"),imageV("gear.circle")])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        return view
    }()
    static let btnCpt:(String,String)->(UIButton) = { (title,imgName) in
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 8
        let img = UIImage(systemName: imgName
                          ,withConfiguration:UIImage.SymbolConfiguration(textStyle: .headline))
        config.image = img
        config.title = title
        btn.configuration = config
        btn.tintColor = .white
//            btn.setTitle(title, for: .normal)
//            btn.setImage(img, for: .normal)
        return btn
    }
    var anchorView = {
        let btnCpt = Example2VC.btnCpt
        let chatBtn = btnCpt("나와의 채팅","bubble.left.fill")
        let editBtn = btnCpt("프로필 편집","pencil.circle")
        let storyBtn = btnCpt("키키오스토리","quote.closing")
        let v = UIStackView(arrangedSubviews: [chatBtn,editBtn,storyBtn])
        v.axis = .horizontal
        v.distribution = .fill
        v.alignment = .fill
        return v
    }()
    var profileView:UIStackView = {
        let stack = UIStackView()
        let imageView = UIImageView(image: UIImage(named: "C++"))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        let titlelabel = UILabel()
        titlelabel.text = "Check"
        titlelabel.font = .preferredFont(forTextStyle: .title3)
        titlelabel.textColor = .white
        let subLabel = UILabel()
        subLabel.text = "하이하이염"
        subLabel.font = .preferredFont(forTextStyle: .body)
        subLabel.textColor = .white
        stack.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(stack.snp.width).multipliedBy(0.3)
            
        }
        [titlelabel,subLabel].forEach{
            stack.addArrangedSubview($0)
            $0.textAlignment = .center
//            $0.backgroundColor = .blue
        }
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.distribution = .equalSpacing
        stack.layoutIfNeeded()
        return stack
    }()
    lazy var bottomView = {
        let v = UIStackView()
//        profileView.backgroundColor = .blue
//        anchorView.backgroundColor = .red
        v.axis = .vertical
//        v.spacing = 40
        [profileView,anchorView].forEach{
            v.addArrangedSubview($0)
        }
        v.alignment = .center
        v.distribution = .fillProportionally
        v.backgroundColor = .cyan
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addSubview(imgView)
        imgView.snp.makeConstraints { $0.edges.equalTo(view) }
        view.addSubview(topView)
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(32)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        view.addSubview(anchorView)
        anchorView.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.bottom.equalTo(anchorView.snp.top).offset(-40)
            make.horizontalEdges.equalTo(view)
        }
        let divider = {
            let v = UIView()
            v.backgroundColor = .lightGray
            return v
        }()
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.bottom.equalTo(anchorView.snp.top).offset(-20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1.5)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
