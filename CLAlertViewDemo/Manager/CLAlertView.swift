//
//  CLAlertView.swift
//  DRUG
//
//  Created by cleven on 2020/2/6.
//  Copyright © 2020 Sheng. All rights reserved.
//

import UIKit

class CLAlertView: UIView {
    
    public var cancelClosure:(()->())?
    public var sureClosure:((String?)->())?
    
    private var titleLabel:UILabel!
    private var messageLabel: UILabel!
    private var textField: UITextField!
    private var cancelButton: UIButton!
    private var sureButton: UIButton!
    private var lineView1: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String?, message: String? ,messageFont: UIFont? = nil, cancelTitle: String = "取消", sureTitle: String = "确定") {
        super.init(frame: .zero)
        setupUI()
        showTitleAlert(title: title, message: message, messageFont: messageFont, cancelTitle: cancelTitle, sureTitle: sureTitle)
    }
    
    init(titleText: String?, text: String? = nil, placeholder: String? = nil,textFont: UIFont? = nil, cancelName: String = "取消", sureName: String = "确定") {
        super.init(frame: .zero)
        setupUI()
        showTextFieldAlert(title: titleText, text: text, placeholder: placeholder, textFont: textFont, cancelTitle: cancelName, sureTitle: sureName)
    }
    
    init(view: UIView, cancelTitle: String = "取消", sureTitle: String = "确定") {
        super.init(frame: .zero)
        setupUI()
        showAlertView(view: view, cancelTitle: cancelTitle, sureTitle: sureTitle)
    }
    
    private func showTitleAlert(title: String?, message: String?,messageFont: UIFont?, cancelTitle: String?, sureTitle: String?) {
        titleLabel.text = title
        messageLabel.text = message
        if messageFont != nil {
            messageLabel.font = messageFont
        }
        cancelButton.setTitle(cancelTitle, for: .normal)
        sureButton.setTitle(sureTitle, for: .normal)
    }
    
    public func showTextFieldAlert(title: String?, text:String?, placeholder: String?, maxLenght: Int = 10,textFont: UIFont?, cancelTitle: String = "取消", sureTitle: String = "确定") {
        titleLabel.text = title
        messageLabel.isHidden = true
        textField.isHidden = false
        textField.placeholder = placeholder
        textField.text = text
        if textFont != nil {
            textField.font = textFont
        }
        cancelButton.setTitle(cancelTitle, for: .normal)
        sureButton.setTitle(sureTitle, for: .normal)
        lineView1.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(30)
        }
    }
    
    private func showAlertView(view: UIView, cancelTitle: String = "取消", sureTitle: String = "确定"){
        titleLabel.isHidden = true
        messageLabel.isHidden = true
        textField.isHidden = true
        cancelButton.setTitle(cancelTitle, for: .normal)
        sureButton.setTitle(sureTitle, for: .normal)
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(18)
        }
        lineView1.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(30)
        }
    }
    
    private func setupUI(){
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        self.snp.makeConstraints { (make) in
            make.width.equalTo(cl_screenWidht - 54)
        }
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor(cl_hexString: "#272B34")
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(39)
        }
        
        messageLabel = UILabel()
        messageLabel.textColor = UIColor(cl_hexString: "#272B34")
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(44)
            make.trailing.equalToSuperview().offset(-44)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        textField = UITextField()
        textField.textColor = UIColor(cl_hexString: "#272B34")
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.layer.borderColor = UIColor(cl_hexString: "#BCBCBC")?.cgColor
        textField.layer.borderWidth = 0.67
        textField.layer.cornerRadius = 3
        textField.layer.masksToBounds = true
        textField.isHidden = true
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(messageLabel)
            make.height.equalTo(40)
        }
        
        cancelButton = UIButton()
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor(cl_hexString: "#7443EE"), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelButton.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(52)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        sureButton = UIButton()
        sureButton.setTitle("取消", for: .normal)
        sureButton.setTitleColor(UIColor(cl_hexString: "#7443EE"), for: .normal)
        sureButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sureButton.addTarget(self, action: #selector(clickSureButton), for: .touchUpInside)
        addSubview(sureButton)
        sureButton.snp.makeConstraints { (make) in
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(52)
            make.width.equalToSuperview().dividedBy(2)
        }
        lineView1 = createLineView()
        addSubview(lineView1)
        lineView1.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(cancelButton.snp.top)
            make.top.equalTo(messageLabel.snp.bottom).offset(30)
        }
        
        let lineView2 = createLineView()
        addSubview(lineView2)
        lineView2.snp.makeConstraints { (make) in
            make.leading.equalTo(cancelButton.snp.trailing)
            make.width.equalTo(1)
            make.bottom.equalToSuperview()
            make.top.equalTo(lineView1.snp.bottom)
        }
    }
    
    private func createLineView() -> UIView{
        let view = UIView()
        view.backgroundColor = UIColor(cl_hexString: "#E2E2E2")
        return view
    }
    
    @objc private func clickCloseButton(){
        CLAlertManager.hiddenView()
        textField.endEditing(true)
    }
    
    @objc private func clickCancelButton(){
        cancelClosure?()
        CLAlertManager.hiddenView()
        textField.endEditing(true)
    }
    
    @objc private func clickSureButton(){
        sureClosure?(textField.text)
        CLAlertManager.hiddenView()
        textField.endEditing(true)
    }
    
}

extension UIColor {
    
    public convenience init?(cl_hexString : String , alpha : CGFloat = 1){
        
        if cl_hexString.isEmpty {
            return nil
        }
        var cString = cl_hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.count == 0 {
            return nil
        }
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count < 6 && cString.count != 6 {
            return nil
        }
        
        let value = "0x\(cString)"
        
        let scanner = Scanner(string:value)
        
        var hexValue : UInt64 = 0
        //查找16进制是否存在
        if scanner.scanHexInt64(&hexValue) {
            print(hexValue)
            let redValue = CGFloat((hexValue & 0xFF0000) >> 16)/255.0
            let greenValue = CGFloat((hexValue & 0xFF00) >> 8)/255.0
            let blueValue = CGFloat(hexValue & 0xFF)/255.0
            self.init(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
        }else{
            self.init(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
}
