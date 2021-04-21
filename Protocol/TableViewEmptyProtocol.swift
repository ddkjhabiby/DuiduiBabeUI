//
//  ScrollViewEmptyProtocol.swift
//  Inlove
//
//  Created by kuang on 2020/8/20.
//  Copyright © 2020 duiud. All rights reserved.
//
import EmptyDataSet_Swift
import Foundation


public protocol ScrollViewEmptyProtocol: EmptyDataSetSource, EmptyDataSetDelegate {
    
}

public extension ScrollViewEmptyProtocol {

    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
//        let title = NSMutableAttributedString.init(string: "nothing_to_load".L())
        let titleString = "refresh_and_see".L()
        let title = NSMutableAttributedString.init(string: titleString)
        title.addAttribute(NSAttributedString.Key.font, value:BLUITheme.Font.middleSubRegular, range: NSRangeFromString(titleString))
        title.addAttribute(NSAttributedString.Key.foregroundColor, value: BLUITheme.Color.mainSubColor, range: NSRangeFromString(titleString))

        return title
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage.init(named: "empty_normal")
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 0 //-(UIImage.init(named: "empty_normal")!.size.height/2)
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldBeForcedToDisplay(_ scrollView: UIScrollView) -> Bool {
        return false
    }

    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 11
    }

    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return false
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
    }

    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return nil
    }

    func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        return nil
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        return nil
    }
}
