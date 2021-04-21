//
//  SheetView.swift
//  Bobo
//
//  Created by ddkj on 2019/8/31.
//  Copyright © 2019 duiud. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift



public enum SheetViewStyle {
    case white
    case dark
}

extension Reactive where Base: SheetView {
    var tap: ControlEvent<(Int, String)> {
        return ControlEvent(events: base.tableView.rx.itemSelected
            .filter{ $0.row != self.base.titles.count }
            .map{ (indexPath) -> (Int, String) in
            return (indexPath.row, self.base.titles[indexPath.row])
        })
    }
}

public class SheetView: UIView {
    private let backView: UIControl = {
        let view = UIControl(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        view.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.backgroundColor = .black
        view.alpha = 0
        
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var cancelText: String = "取消"
    
    private lazy var darkEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        
        return effectView
    }()
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    fileprivate let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(SheetViewCell.self, forCellReuseIdentifier: SheetViewCell.className)
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    var tableViewHeight: CGFloat {
        var height = 0.0
        height += 54.5 * Double(titles.count - 1)
        height += style == .white ? 62 : 54.5
        height += 54
        height += Double(ScreenLayout.bottomBarHeight)
        
        return CGFloat(height)
    }
    
    var destructiveIndexSet: Set<Int> = Set<Int>()
    var destructiveColor: UIColor?
    
    fileprivate let titles: Array<String>
    private var action: ((_ index: Int) -> ())?
    private let style: SheetViewStyle
    
    public init(style: SheetViewStyle, titles: [String], cacelActionText: String = "取消") {
        self.style = style
        self.titles = titles
        cancelText = cacelActionText
        super.init(frame: UIScreen.main.bounds)
        setupUI()
        
    }
    
    public init(style: SheetViewStyle, titles: [String], cacelActionText: String = "取消", action: @escaping (_ index: Int) -> ()) {
        self.style = style
        self.titles = titles
        self.action = action
        cancelText = cacelActionText
        super.init(frame: UIScreen.main.bounds)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        containerView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: 14 + tableViewHeight)
        topView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 20)
        tableView.frame = CGRect(x: 0, y: 14, width: UIScreen.width, height: tableViewHeight)
        
        addSubview(backView)
        addSubview(containerView)
        if style == .dark {
            darkEffectView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 14 + tableViewHeight)
            containerView.backgroundColor = .clear
            containerView.addSubview(darkEffectView)
        } else {
            containerView.backgroundColor = .white
        }
        containerView.addSubview(topView)
        containerView.addSubview(tableView)
        
        let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: UIScreen.width, height: 14 + tableViewHeight), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 14 + tableViewHeight)
        maskLayer.path = maskPath.cgPath
        containerView.layer.mask = maskLayer
    }
    
    public func show() {
        CommonUIUtil.mainWindow.addSubview(self)
        tableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.backView.alpha = 0.4
            self.containerView.frame = CGRect(x: 0, y: UIScreen.height - self.tableViewHeight - 14, width: UIScreen.width, height: 14 + self.tableViewHeight)
        }
    }
    
    @objc func close() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.alpha = 0
            self.containerView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: 14 + self.tableViewHeight)
        }) { bool in
            self.removeFromSuperview()
        }
    }
}

extension SheetView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SheetViewCell.self), for: indexPath) as! SheetViewCell
        
        cell.style = style
        if indexPath.row != titles.count {
            cell.titleLabel.text = titles[indexPath.row]
            if let destructiveColor = destructiveColor, destructiveIndexSet.contains(indexPath.row) {
                cell.titleLabel.textColor = destructiveColor
            } else {
//                cell.titleLabel.textColor = (style == .dark ? .white : mainFontColor)
            }
        } else {
            cell.titleLabel.text = cancelText
//            cell.titleLabel.font = style == .dark ? AvenirBlack(16) : AvenirHeavy(16)
//            cell.titleLabel.textColor = assistFontColorLight
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == titles.count - 1 {
            return style == .dark ? 54.5 : 62
        } else if indexPath.row == titles.count {
            return 54
        }
        return 54.5
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        close()
        
        if indexPath.row != titles.count {
            action?(indexPath.row)
        }
    }
}

class SheetViewCell: UITableViewCell {
    let containerView = UIView()
    let titleLabel = UILabel()
    let lineView = UIView()
    
    var style: SheetViewStyle = .white
    {
        willSet(value){
            if value == .dark {
                titleLabel.textColor = .white
                lineView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
            } else if value == .white {
                titleLabel.textColor = BLUITheme.Color.mainTextColor
                lineView.backgroundColor = BLUITheme.Color.sperateColor
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        titleLabel.textColor = mainFontColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if style == .dark {
            contentView.backgroundColor = .clear
        } else {
            if selected {
//                contentView.backgroundColor = separatorColorDark
            } else {
                contentView.backgroundColor = .white
            }
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if style == .dark {
            contentView.backgroundColor = .clear
        } else {
            if highlighted {
//                contentView.backgroundColor = separatorColorDark
            } else {
                contentView.backgroundColor = .white
            }
        }
    }
    
    func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        addSubview(lineView)
        backgroundColor = .clear
        
        containerView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.trailing.equalTo(self.snp.trailing)
            make.height.equalTo(54)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(containerView.snp.center)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.containerView.snp.bottom)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
