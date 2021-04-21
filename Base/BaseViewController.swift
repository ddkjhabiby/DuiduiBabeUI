//
//  BaseViewController.swift
//  Inlove
//
//  Created by kuang on 2020/7/17.
//  Copyright © 2020 duiud. All rights reserved.
//

import UIKit
import SnapKit
import IQKeyboardManager


open class BaseViewController: UIViewController, BaseViewControllerProtocol, ScrollViewEmptyProtocol {
    
    deinit {
    }
    
    public var iqKeyboardManagerEnable: Bool = false
    {
        willSet{
            IQKeyboardManager.shared().isEnabled = newValue
        }
    }
    
    public var statusBarStyle: UIStatusBarStyle = .default
    {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    public lazy var navigationView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.statusBarHeight + 44))
        view.backgroundColor = .white
        return view
    }()
    
    public lazy var navigationViewTitleLabel = UILabel()
    
    
    
    public lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        let image = backImge()
        backBtn.setImage(image, for: .normal)
        backBtn.frame = CGRect(x: 7, y: UIScreen.statusBarHeight, width: 36, height: 44)
        backBtn.addTarget(self, action: .backAction, for: .touchUpInside)
        
        return backBtn
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNeedsStatusBarAppearanceUpdate()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = self.iqKeyboardManagerEnable
//        Logger.info("ViewController: \(self.className) viewWillAppear")
        
        //首充悬浮是否展示逻辑
//        UserInfoService.updateFirstRechargeFloatHidden(self)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        Logger.info("ViewController: \(self.className) viewDidDisappear")
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    public override var childForStatusBarHidden: UIViewController? {
        return self.children.first
    }
    
    @objc open func back() {
        if let nv = navigationController {
            nv.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
   public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension BaseViewController {
    
    open func backImge() -> UIImage?{
        return UIImage(named: "tab_bar_back_normal")?.flippedImageForRTL
    }
    
    public func setNavigationViewTitle(_ title: String, font: UIFont = BLUITheme.Font.seniorSubRegular, color: UIColor = BLUITheme.Color.mainTextColor) {
        navigationViewTitleLabel.text = title
        navigationViewTitleLabel.font = font
        navigationViewTitleLabel.textColor = color
        navigationViewTitleLabel.sizeToFit()
        navigationViewTitleLabel.center = CGPoint(x: UIScreen.width / 2, y: UIScreen.statusBarHeight + 22)
        navigationView.addSubview(navigationViewTitleLabel)
    }
    
    public func setCustomNavigationView(title: String? = nil, leftItem: UIView? = nil, rightItem: UIView? = nil) {
        navigationView.backgroundColor = .clear
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.top.equalTo(view)
            make.height.equalTo(ScreenLayout.topBarHeight)
        }
        
        let leftBtn = leftItem ?? backBtn
        navigationView.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(navigationView).offset(15)
            make.centerY.equalTo(navigationView.snp.centerY).offset(ScreenLayout.statusBarHeight / 2)
        }
        
        if let rightItem = rightItem {
            navigationView.addSubview(rightItem)
            rightItem.snp.makeConstraints { (make) in
                make.trailing.equalTo(navigationView).offset(-10)
                make.centerY.equalTo(navigationView.snp.centerY).offset(ScreenLayout.statusBarHeight / 2)
            }
        }
        if let title = title {
            setNavigationViewTitle(title)
        }
    }
}

fileprivate extension Selector {
    static let backAction: Selector = #selector(BaseViewController.back)
}

