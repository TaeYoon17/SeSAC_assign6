//
//  Example1VC.swift
//  assign6
//
//  Created by 김태윤 on 2023/08/22.
//

import UIKit
import SnapKit

class Example1VC: UIViewController{
    let placeholderTextField = { (placeholder:String) in
        let v = UITextField()
        v.borderStyle = .line
        v.textAlignment = .center
        v.placeholder = placeholder
        return v
    }
    lazy var dateTextField = placeholderTextField("날짜를 입력하여 주세요")
    lazy var titleTextField = placeholderTextField("제목을 입력하여주세요")
    //
    lazy var topView = {
        let v = UIView()
        v.backgroundColor = .gray
        return v
    }()
    lazy var textView = {
        let v = UITextView()
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.black.cgColor
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(topView)
        self.view.addSubview(textView)
        self.view.addSubview(dateTextField)
        self.view.addSubview(titleTextField)

        textView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
//                .width.centerY
            make.height.equalTo(self.view.snp.width).multipliedBy(0.85)
        }
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
//                .width.centerY
            make.height.equalTo(self.view.snp.width).multipliedBy(0.666)
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(self.topView.snp.bottom)
//            make.width.centerY.equalToSuperview()
            make.height.equalTo(self.dateTextField)
            make.bottom.equalTo(dateTextField.snp.top)
        }
        dateTextField.snp.makeConstraints { make in
            make.bottom.equalTo(self.textView.snp.top)
//            make.width.centerY.equalToSuperview()
            make.top.equalTo(self.titleTextField.snp.bottom)
            make.height.equalTo(self.titleTextField)
        }
        [topView,textView,titleTextField,dateTextField].forEach { v in
            v.snp.makeConstraints { make in
                make.trailingMargin.equalTo(-20)
                make.leadingMargin.equalTo(20)
            }
        }
    }
}
