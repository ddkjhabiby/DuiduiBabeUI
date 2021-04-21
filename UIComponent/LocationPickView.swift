//
//  LocationPickView.swift
//  Inlove
//
//  Created by ddkj on 2020/8/8.
//  Copyright © 2020 duiud. All rights reserved.
//

import UIKit
import HandyJSON
import RxCocoa
import RxSwift


fileprivate struct City: HandyJSON {
    var name = ""
}
fileprivate struct Province: HandyJSON {
    var name = ""
    var citys: [City] = []
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.name <-- "province"
    }
}

fileprivate let topViewHeight: CGFloat = 48.f
fileprivate let pickHeight: CGFloat = 225.f

extension Reactive where Base: LocationPickView {
    var loactionInfo: Driver<(String, String)> {
        return base.conformBtn.rx.tap.asDriver().map { (void) -> (String, String) in
            let provinceName = self.base.contents[self.base.pickerView.selectedRow(inComponent: 0)].name
            let cityName = self.base.contents[self.base.pickerView.selectedRow(inComponent: 0)].citys[self.base.pickerView.selectedRow(inComponent: 1)].name
            return (provinceName, cityName)
        }
    }
}

public class LocationPickView: UIView {
    fileprivate static let provinces = { () -> [Province] in
        let dataAsset = NSDataAsset(name: "ChinaCity")
        let jsonStr = String(data: dataAsset!.data, encoding: .utf8)
        let provinces = [Province].deserialize(from: jsonStr)
        return provinces as! [Province]
    }()

    var containerHeight: CGFloat {
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
    
    fileprivate var indexOfProvince = 0
    
    fileprivate let contents = provinces
    
    public var action: ((_ province: String, _ city: String) -> ())?
    
    public init(action: ((_ province: String, _ city: String) -> ())? = nil) {
        self.action = action
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
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

extension LocationPickView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return ScreenLayout.screenWidth / 2.f
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return contents[row].name
        } else { // component == 1
//            return contents[pickerView.selectedRow(inComponent: 0)].citys[row].name
            return contents[indexOfProvince].citys[row].name
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            indexOfProvince = row
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
    }
}

extension LocationPickView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return contents.count
        } else { // component == 1
            return contents[pickerView.selectedRow(inComponent: 0)].citys.count
        }
    }
}

extension LocationPickView {
    
    public func show() {
        CommonUIUtil.mainWindow.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.backView.alpha = 0.5
            self.containerView.frame = CGRect(x: 0, y: UIScreen.height - self.containerHeight, width: UIScreen.width, height: self.containerHeight)
        }
    }
    
    @objc public func close() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.alpha = 0
            self.containerView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: self.containerHeight)
        }) { bool in
            self.removeFromSuperview()
        }
    }
    
    @objc func conform() {
        let provinceName = contents[pickerView.selectedRow(inComponent: 0)].name
        let cityName = contents[pickerView.selectedRow(inComponent: 0)].citys[pickerView.selectedRow(inComponent: 1)].name
        action?(provinceName, cityName)
        close()
    }
}
