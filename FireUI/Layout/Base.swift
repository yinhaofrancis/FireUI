//
//  Base.swift
//  FireUI
//
//  Created by hao yin on 2018/9/6.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import Foundation
import QuartzCore

public protocol hostable:class{
    var x:CGFloat {get set}
    var y:CGFloat {get set}
    var w:CGFloat {get set}
    var h:CGFloat {get set}
}

public protocol itemAble:class{
    var item:Item {get}
    var systemLayoutFirst:Bool {get}
}

public protocol containAble:itemAble{
    var container:Container {get}
}


public enum Direction:UInt{
    case horizontal
    case vertical
}
public enum JustContent:UInt{
    case start
    case center
    case end
    case between
    case around
    case evenly
}
public enum Align:UInt{
    case start
    case center
    case end
    case stretch
}

public enum Value{
    case volume(CGFloat)
    case percent(CGFloat)
    public var value:CGFloat{
        switch self {
        case .volume(let v):
            return v
        case .percent(let v):
            return v
        }
    }
    public func calc(space:CGFloat)->CGFloat{
        switch self {
        case .volume(let v):
            return v
        case .percent(let v):
            return space * v
        }
    }
}

public class Item{
    public var width: Value = .volume(0)
    public var height: Value = .volume(0)
    public var resultH: CGFloat = 0{
        didSet{
            self.view?.h = resultH
        }
    }
    public var resultW: CGFloat = 0{
        didSet{
            self.view?.w = resultW
        }
    }
    public var resultX: CGFloat = 0{
        didSet{
            self.view?.x = resultX
        }
    }
    public var resultY: CGFloat = 0{
        didSet{
            self.view?.y = resultY
        }
    }
    public var grow:UInt = 0
    public var shrink:UInt = 0
    public weak var parent: Container?
    public func calcSize(){
        if (self.needAutoSize){
            autoSize()
        }
        if let p = parent{
            resultW = self.width.calc(space: p.resultW)
            resultH = self.height.calc(space: p.resultH)
        }else{
            resultW = self.width.value
            resultH = self.height.value
        }
    }
    public func fixSize(extraSize:CGFloat,direction:Direction,growsum:UInt,shrinksum:UInt){
        let weight = extraSize > 0 ? self.grow : extraSize < 0 ? self.shrink : 0
        let sum = extraSize > 0 ? growsum : extraSize < 0 ? shrinksum : 0
        if sum == 0{
            return
        }
        let s = extraSize * CGFloat(weight) / CGFloat(sum)
        switch direction {
        case .horizontal:
            self.resultW += s
            break
        case .vertical:
            self.resultH += s
            break
        }
    }
    public var needAutoSize:Bool{
        return false
    }
    public func autoSize(){}
    public var constantSize:CGSize{
        return CGSize(width: self.width.value, height: self.height.value)
    }
    public func layout() {
        
    }
    
    public init(width: Value = .volume(0),height: Value = .volume(0)) {
        self.width = width
        self.height = height
    }
    public var frame:CGRect{
        return CGRect(x: self.resultX, y: self.resultY, width: self.resultW, height: self.resultH)
    }
    public weak var view:hostable?
}
public class Container:Item{
    public var subItems: [Item] = []{
        didSet{
            subItems.forEach { (i) in
                i.parent = self
            }
        }
    }
    
}
