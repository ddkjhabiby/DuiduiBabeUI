//
//  EmojiKeyboardLayout.swift
//  Bobo
//
//  Created by ddkj007 on 2019/9/26.
//  Copyright © 2019 duiud. All rights reserved.
//

import UIKit

class EmojiKeyboardLayout: UICollectionViewFlowLayout {
    let itemCountPerRow = 6//  一行中 cell 的个数
    let rowCount = 3//    一页显示多少行
    
    var attributeDictionary = [NSIndexPath: UICollectionViewLayoutAttributes]()

    //MARK: UICollectionViewFlowLayout
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return [] }
        var tmp = [UICollectionViewLayoutAttributes]()
        for attr in attributes {
            if let returnAtt = self.layoutAttributesForItem(at: attr.indexPath) {
                tmp.append(returnAtt)
            }
        }
        return tmp
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let item = self.originItemWithItem(indexPath.item)
        let theNewIndexPath = IndexPath.init(item: item, section: indexPath.section)
        let theNewAttr = super.layoutAttributesForItem(at: theNewIndexPath)?.copy() as? UICollectionViewLayoutAttributes
        theNewAttr?.indexPath = indexPath
        return theNewAttr;
    }
}

extension EmojiKeyboardLayout {
    // 根据偏移量计算item
    func originItemWithItem(_ item : Int) -> Int {
        let page = item / (self.itemCountPerRow * self.rowCount);
        let theX = item % self.itemCountPerRow + page * self.itemCountPerRow;
        let theY = item / self.itemCountPerRow - page * self.rowCount;
        let originItem = theX * self.rowCount + theY;
        return originItem;
    }
}
