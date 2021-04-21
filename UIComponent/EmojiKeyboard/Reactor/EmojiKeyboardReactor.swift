//
//  ChatRoomEmojiReactor.swift
//  Bobo
//
//  Created by ddkj007 on 2019/9/19.
//  Copyright © 2019 duiud. All rights reserved.
//

import Foundation
import ReactorKit
import RxDataSources
import RxSwift

enum EmojeData {
    case string(_ string: String)
    case delete
    case empty
    
    init(_ string: String) {
        if string == "d" {
            self = .delete
        } else if string == "" {
            self = .empty
        } else {
            self = .string(string)
        }
    }
}

public class EmojiKeyboardReactor: Reactor {
    
    static var emojiArray: Array<EmojeData> {
        var array = ["😀", "😁", "😂", "🤣", "😃", "😄", "😅", "😆", "😉", "😊", "😋", "😎", "😍", "😘", "😗", "😙", "😚", "☺️", "🙂", "🤗", "🤔", "😐", "😑", "😶", "🙄", "😏", "😣", "😥", "😮", "🤐", "😯", "😪", "😫", "😴", "😌", "😛", "😜", "😝", "🤤", "😒", "😓", "😔", "😕", "🙃", "🤑", "😲", "☹️", "🙁", "😖", "😞", "😟", "😤", "😢", "😭", "😦", "😧", "😨", "😩", "😬", "😰", "😱", "😳", "😵", "😡", "😠", "😷", "🤒", "🤕", "🤢", "🤧", "😇", "🤠", "🤡", "🤥", "🤓", "😈", "👿", "👹", "👺", "💀", "👻", "👽", "🤖", "💩", "😺", "😸", "😹", "😻", "😼", "😽", "🙀", "😿", "😾", "👐", "🙌", "👏", "🤝", "👍", "👎", "👊", "✊", "🤛", "🤜", "🤞", "✌️", "🤘", "👌", "👈", "👉", "👆", "👇", "☝️", "✋", "🤚", "🖐", "🖖", "👋", "🤙", "💪", "🖕", "✍️", "🙏"]
        let floorPage = Int(floor(Double(array.count)/Double(EmojiKeyboardViewConstants.emojiPageCount)))
        for i in 0 ..< floorPage {
            array.insert("d", at: (i + 1) * EmojiKeyboardViewConstants.emojiPageCount + i)
        }
        let ceilPage = Int(ceil(Double(array.count)/Double(EmojiKeyboardViewConstants.emojiPageCount)))
        let allCount = (EmojiKeyboardViewConstants.emojiPageCount + 1) * ceilPage
        while array.count != allCount  {
            array.append("")
        }
        array.replaceSubrange(allCount-1...allCount-1, with: repeatElement("d", count: 1))
        
        let emojiArray = array.map({ (string) -> EmojeData in
            return EmojeData(string)
        })
        return emojiArray
    }
    
    public enum Action {

    }
    
    public enum Mutation {

    }
    
    public struct State {
        var sectionModels: [SectionModel<String, EmojeData>]
    }
    
    public let initialState: State
    
    init() {
        let sectionModels = [SectionModel(model: "", items: EmojiKeyboardReactor.emojiArray)]
        self.initialState = State(sectionModels:sectionModels)
    }
}
