//
//  DatePicker.swift
//  Bobo
//
//  Created by ddkj on 2019/9/2.
//  Copyright © 2019 duiud. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


fileprivate let topViewHeight: CGFloat = 48.f
fileprivate let datePickHeight: CGFloat = 225.f

extension Reactive where Base: DatePicker {
    var date: Driver<Date> {
        return base.conformBtn.rx.tap.asDriver().map{ self.base.datePicker.date }
    }
}

open class DatePicker: UIView {
    public var containerHeight: CGFloat {
        return topViewHeight + datePickHeight + ScreenLayout.bottomBarHeight
    }
    
    private let backView: UIControl = {
        let view = UIControl(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        view.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.alpha = 0
        
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = BLUITheme.Color.backgroundColor
        let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: UIScreen.width, height: topViewHeight + datePickHeight + ScreenLayout.bottomBarHeight), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: topViewHeight + datePickHeight + ScreenLayout.bottomBarHeight)
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
        
        return view
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    fileprivate let conformBtn: UIButton = {
        let conformBtn = UIButton(type: .custom)
        conformBtn.titleLabel?.font = BLUITheme.Font.middleHeavy
        conformBtn.setTitleColor(BLUITheme.Color.mainSubColor, for: .normal)
        conformBtn.setTitle("确定", for: .normal)
        conformBtn.addTarget(self, action: #selector(conform), for: .touchUpInside)
        
        return conformBtn
    }()
    
    fileprivate let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        #if swift(>=5.2)
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
            }
        #endif
        datePicker.tintColor = BLUITheme.Color.mainTextColor
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date(fromString: "19700101", format: "YYYYMMdd")
        datePicker.maximumDate = Date()
        
        let spareDate = Date(timeIntervalSinceNow: -3600 * 24 * 365 * 22)
        let currentDate = Date()
        let formater = DateFormatter()
        formater.dateFormat = "yyyyMMdd"
        let currentDateString = formater.string(from: currentDate)
        let yearStr = currentDateString.prefix(4)
        if let year = Int(yearStr) {
            let displayYear = year - 22
            let displayDateStr = "\(displayYear)" + currentDateString.suffix(4)
            datePicker.setDate(formater.date(from: displayDateStr) ?? spareDate, animated: true)
        } else {
            datePicker.setDate(spareDate, animated: true)
        }
        
        return datePicker
    }()
    
    public var action: ((_ date: Date) -> ())?
    
    public init(action: @escaping (_ date: Date) -> ()) {
        self.action = action
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        containerView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: containerHeight)
        topView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: topViewHeight)
        datePicker.frame = CGRect(x: 0, y: topViewHeight, width: UIScreen.width, height: datePickHeight)
        
        containerView.addSubview(topView)
        topView.addSubview(conformBtn)
        containerView.addSubview(datePicker)
        addSubview(backView)
        addSubview(containerView)
        
        conformBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(topView.snp.trailing).offset(-20)
            make.centerY.equalTo(topView.snp.centerY)
        }
    }
}

public extension DatePicker {
    func show() {
        CommonUIUtil.mainWindow.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.backView.alpha = 0.5
            self.containerView.frame = CGRect(x: 0, y: UIScreen.height - self.containerHeight, width: UIScreen.width, height: self.containerHeight)
        }
    }
    
    func setDate(date: String) {
        datePicker.setDate(Date(), animated: true)
    }
    
    @objc func close() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.alpha = 0
            self.containerView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: self.containerHeight)
        }) { bool in
            self.removeFromSuperview()
        }
    }
    
    @objc  func conform() {
        action?(datePicker.date)
        close()
    }
}
