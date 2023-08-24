//
//  MovieLoginVC.swift
//  assign6
//
//  Created by 김태윤 on 2023/08/24.
//

import UIKit
import SnapKit
class MovieLoginVC: UIViewController{
    let label = {
        let label = UILabel()
        label.text = "FlexFlix".uppercased()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 36, weight: .heavy)
        label.textAlignment = .center
        return label
    }()
    lazy var fieldsStack = {
        let stV = UIStackView()
        ["이메일 주소 또는 전화번호","비밀번호","닉네임","유저","추천코드 입력"].forEach {
            let textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.backgroundColor = .gray
            textField.textColor = .white
            textField.delegate = self
            textField.textAlignment = .center
            textField.font = .systemFont(ofSize: 14, weight: .regular)
            textField.attributedPlaceholder = NSAttributedString(
                string: $0,
                attributes: [ NSAttributedString.Key.foregroundColor: UIColor.white ]
            )
            stV.addArrangedSubview(textField)
            textField.snp.makeConstraints { make in
                make.height.equalTo(38)
            }
        }
        stV.axis = .vertical
        stV.spacing = 16
        stV.alignment = .fill
        stV.distribution = .fill
        return stV
    }()
    lazy var bottomView = {
       let v = UIView()
        lazy var additionalBtn:UIButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.bordered()
        config.baseForegroundColor = .lightGray
        config.baseBackgroundColor = .clear
        config.attributedTitle = AttributedString("추가정보입력",attributes:.init([
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]))
        btn.configuration = config
            btn.addAction(.init(handler: {[weak self] _ in
               print("hello world")
            }), for: .touchUpInside)
        return btn
    }()
        lazy var switcher:UISwitch = {
            let s = UISwitch()
            s.onTintColor = .systemRed
            return s
        }()
        v.addSubview(additionalBtn)
        additionalBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(4)
        }
        v.addSubview(switcher)
        switcher.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
        }
        return v
    }()
    lazy var signUpStack = {
        let stV = UIStackView()
        let signUpBtn = {
            let btn = UIButton()
            var config = UIButton.Configuration.bordered()
            config.baseForegroundColor = .black
            config.baseBackgroundColor = .white
            config.attributedTitle = AttributedString("회원가입",attributes:.init([
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)
            ]))
            btn.configuration = config
            return btn
        }()
        stV.axis = .vertical
        stV.alignment = .fill
        stV.distribution = .fillProportionally
        stV.spacing = 16
        stV.addArrangedSubview(fieldsStack)
        stV.addArrangedSubview(signUpBtn)
        stV.addArrangedSubview(bottomView)
        signUpBtn.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalToSuperview()
        }
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalToSuperview()
        }
        return stV
    }()
}

extension MovieLoginVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(66)
            make.horizontalEdges.equalToSuperview()
        }
        //        view.addSubview(fieldsStack)
        //        fieldsStack.snp.makeConstraints { make in
        //            make.centerY.equalToSuperview()
        //            make.horizontalEdges.equalToSuperview().inset(40)
        //        }
        view.addSubview(signUpStack)
        signUpStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(36)
        }
    }
}
extension MovieLoginVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
        textField.textAlignment = .left
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty{ }
        else{
            textField.textAlignment = .center
        }
    }
}
