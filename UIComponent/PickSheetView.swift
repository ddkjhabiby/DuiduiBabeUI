//
//  PickSheetView.swift
//  Inlove
//
//  Created by ddkj on 2020/7/29.
//  Copyright © 2020 duiud. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


fileprivate let topViewHeight: CGFloat = 48.f
fileprivate let pickHeight: CGFloat = 225.f

extension Reactive where Base: PickSheetView {
    var pickDriver: Driver<PickSheetModel> {
        return base.conformBtn.rx.tap.asDriver().map{ self.base.selectedModel! }
    }
}

public struct PickSheetModel {
    public let value: String
    public let description: String
}

open class PickSheetView: UIView {
    public var containerHeight: CGFloat {
        return topViewHeight + pickHeight + ScreenLayout.bottomBarHeight
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
        let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: UIScreen.width, height: topViewHeight + pickHeight + ScreenLayout.bottomBarHeight), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: topViewHeight + pickHeight + ScreenLayout.bottomBarHeight)
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
    
    fileprivate let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    fileprivate var selectedModel: PickSheetModel? {
        return contents?[pickerView.selectedRow(inComponent: 0)]
    }
    
    public var action: ((_ content: PickSheetModel) -> ())?
    var contents: Array<PickSheetModel>?
    
    public init(action: ((_ content: PickSheetModel) -> ())? = nil, contents: Array<PickSheetModel>? = nil) {
        self.action = action
        self.contents = contents
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        containerView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: containerHeight)
        topView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: topViewHeight)
        pickerView.frame = CGRect(x: 0, y: topViewHeight, width: UIScreen.width, height: pickHeight)
        
        containerView.addSubview(topView)
        topView.addSubview(conformBtn)
        containerView.addSubview(pickerView)
        addSubview(backView)
        addSubview(containerView)
        
        conformBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(topView.snp.trailing).offset(-20)
            make.centerY.equalTo(topView.snp.centerY)
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
}

extension PickSheetView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return ScreenLayout.screenWidth
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return contents![row].description
    }
}

extension PickSheetView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contents?.count ?? 0
    }
}

public extension PickSheetView {
    func setContents(with array: Array<String>) {
        guard array.count > 0 else {
//            Logger.debug("arrar's count == 0")
            return
        }
        
        var contents: Array<PickSheetModel> = []
        for (index, item) in array.enumerated() {
            let pickSheetModel = PickSheetModel(value: String(describing: index), description: item)
            contents.append(pickSheetModel)
        }
        self.contents = contents
        pickerView.reloadAllComponents()
    }
    
    func show() {
        guard contents != nil && contents?.count != 0 else {
            return
        }
        
        pickerView.selectRow(contents!.count / 2 - 1, inComponent: 0, animated: true)
        CommonUIUtil.mainWindow.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.backView.alpha = 0.5
            self.containerView.frame = CGRect(x: 0, y: UIScreen.height - self.containerHeight, width: UIScreen.width, height: self.containerHeight)
        }
    }
    
    @objc func close() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.alpha = 0
            self.containerView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: self.containerHeight)
        }) { bool in
            self.removeFromSuperview()
        }
    }
    
    @objc func conform() {
        action?(selectedModel!)
        close()
    }
}
