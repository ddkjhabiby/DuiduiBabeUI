//
//  ChatRoomEmojiView.swift
//  Bobo
//
//  Created by ddkj007 on 2019/9/19.
//  Copyright © 2019 duiud. All rights reserved.
//

import Foundation
import ReactorKit
import RxDataSources
import RxCocoa
import SnapKit
import RxSwift

import NSObject_Rx

public protocol EmojiKeyboardViewDelegate: class {
    func input(_ string: String)
    func delete()
    func send()
}

public struct EmojiKeyboardViewConstants {
    public static let Height: CGFloat = collectionViewHeight + pageControlHeight
    public static let collectionViewHeight: CGFloat = 128
    public static let pageControlHeight: CGFloat = 37
    public static let cellHeight: CGFloat = 39
    public static let stringSize: CGFloat = 24
    public static let sectionTop: CGFloat = 8.5
    public static let sectionBottom: CGFloat = 2.5
    public static let emojiPageCount: Int = 3 * 6 - 1
}

public class EmojiKeyboardView: UIView, ViewProtocol, StoryboardView {
    
    public var disposeBag = DisposeBag()
    
    public weak var delegate: EmojiKeyboardViewDelegate?

    lazy var collectionView: UICollectionView = {
        let emojiWidth : CGFloat = 24
        let spacing = (UIScreen.width - 6 * emojiWidth)/7
        let cellWidth = emojiWidth + spacing;
        let edge = spacing - (cellWidth - emojiWidth)/2;

        let layout = EmojiKeyboardLayout.init()
        layout.itemSize = CGSize(width: cellWidth, height: EmojiKeyboardViewConstants.cellHeight)
        layout.sectionInset = UIEdgeInsets(top: EmojiKeyboardViewConstants.sectionTop, left: 0, bottom: EmojiKeyboardViewConstants.sectionBottom, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        var collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        let bundle = Bundle.init(identifier: "com.telay.WCUI")
        collectionView.register(UINib.init(nibName: EmojiKeyboardCell.className, bundle: bundle), forCellWithReuseIdentifier: EmojiKeyboardCell.className)
        return collectionView
    }()
    
    var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = BLUITheme.Color.backgroundColor
        return view
    }()
    
    var pageControl: UIPageControl = {
        var pageControl = UIPageControl.init()
        pageControl.numberOfPages = EmojiKeyboardReactor.emojiArray.count/EmojiKeyboardViewConstants.emojiPageCount
        pageControl.sizeToFit()
        pageControl.y = EmojiKeyboardViewConstants.collectionViewHeight
        pageControl.pageIndicatorTintColor = BLUITheme.Color.mainTextColor.withAlphaComponent(0.2)
        pageControl.currentPageIndicatorTintColor = BLUITheme.Color.mainTextColor
        return pageControl
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = BLUITheme.Color.mainColor
        button.setTitle(sendButtonTitle, for: .normal)
        button.titleLabel?.font = BLUITheme.Font.middleHeavy
        return button
    }()

    var sendButtonTitle = "发送"
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.reactor = EmojiKeyboardReactor()
    }
    
    public init(frame: CGRect, sendButtonTitle: String = "发送") {
        self.sendButtonTitle = sendButtonTitle
        super.init(frame: frame)
        setupUI()
        self.reactor = EmojiKeyboardReactor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.width = UIScreen.width
        self.backgroundColor = BLUITheme.Color.controllBackGroundColor
        
        addSubview(bottomView)
        addSubview(collectionView)
        bottomView.addSubview(pageControl)
        bottomView.addSubview(sendButton)
        
        let emojiWidth : CGFloat = 24
        let spacing = (UIScreen.width - 6 * emojiWidth)/7
        let cellWidth = emojiWidth + spacing;
        let edge = spacing - (cellWidth - emojiWidth)/2;
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(edge)
            make.top.equalTo(0)
            make.width.equalTo(UIScreen.width - edge * 2)
            make.height.equalTo(EmojiKeyboardViewConstants.collectionViewHeight)
        }
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(EmojiKeyboardViewConstants.pageControlHeight)
        }
        pageControl.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        sendButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(70)
        }
        
    }
}

public extension EmojiKeyboardView {
    func bind(reactor: EmojiKeyboardReactor) {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String,EmojeData>>(configureCell: {
            (dataSource, collection, indexPath, emojiData) in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: EmojiKeyboardCell.className, for: indexPath) as! EmojiKeyboardCell
            cell.refreshWithData(emojiData)
            return cell
        })
        
        reactor.state
            .map{ $0.sectionModels }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(EmojeData.self).subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            switch data {
            case .delete:
                print("删除")
                self.delegate?.delete()
            case .empty:
                return
            case .string(let string):
                self.delegate?.input(string)
            }
        }).disposed(by: rx.disposeBag)
        
        collectionView.rx.didEndDecelerating.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let pageWidth = self.collectionView.frame.width
            let contentOffsetX = self.collectionView.contentOffset.x
            let page1 = (contentOffsetX - pageWidth / 2) / pageWidth
            let page2 = Int(floor(page1) + 1)
            self.pageControl.currentPage = page2
        }).disposed(by: rx.disposeBag)
        
        sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.delegate?.send()
            }).disposed(by: rx.disposeBag)
    }
}
