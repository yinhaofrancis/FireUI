//
//  View.swift
//  FireUI
//
//  Created by hao yin on 2018/9/8.
//  Copyright © 2018 hao yin. All rights reserved.
//

import UIKit


extension UIView:hostable{
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    public var w: CGFloat {
        get {
            return self.frame.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    public var h: CGFloat {
        get {
            return self.frame.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    public var obj:Container?{
        if self.superview is StackView{
            let v = self.superview as! StackView
            return v.stack
        }else{
            return nil
        }
    }
    public var volume:CGSize{
        get{
            if let c = self.obj{
                if let it = c.subItems.filter({($0.view as? UIView) == self}).first{
                    return CGSize(width: it.width.value, height: it.height.value)
                }
            }
            return .zero
        }
        set{
            if let c = self.obj{
                if let it = c.subItems.filter({($0.view as? UIView) == self}).first{
                    it.width = .volume(newValue.width)
                    it.height = .volume(newValue.height)
                }
            }
        }
    }
    public var percent:CGSize{
        get{
            if let c = self.obj{
                if let it = c.subItems.filter({($0.view as? UIView) == self}).first{
                    return CGSize(width: it.width.value, height: it.height.value)
                }
            }
            return .zero
        }
        set{
            if let c = self.obj{
                if let it = c.subItems.filter({($0.view as? UIView) == self}).first{
                    it.width = .percent(newValue.width)
                    it.height = .percent(newValue.height)
                }
            }
        }
    }
}

public class StackView:UIView,containAble{
    public var systemLayoutFirst = false
    public var item: Item{
        return self.stack
    }
    
    public var container: Container{
        return self.stack
    }
    
    public var direction:Direction{
        get{
            return self.stack.direction
        }
        set{
            self.stack.direction = newValue
        }
    }
    public var justContent:JustContent{
        get{
            return self.stack.justContent
        }
        set{
            self.stack.justContent = newValue
        }
    }
    public var alignItem:Align{
        get{
            return self.stack.alignItem
        }
        set{
            self.stack.alignItem = newValue
        }
    }
    public var stack:StackContainer
    public override init(frame: CGRect) {
        stack = StackContainer(width: .volume(frame.width), height: .volume(frame.height))
        super.init(frame: frame)
        stack.view = self
    }
    required public init?(coder aDecoder: NSCoder) {
        stack = StackContainer(width: .volume(1), height: .volume(1))
        super.init(coder: aDecoder)
        stack.view = self
        self.systemLayoutFirst = true
    }
    public override func addSubview(_ view: UIView) {
        super.addSubview(view)
        if view is itemAble {
            let c = view as! itemAble
            self.stack.subItems.append(c.item)
        }else{
            let i = Item(width: .volume(view.frame.width), height: .volume(view.frame.height))
            i.view = view
            self.stack.subItems.append(i)
        }
    }
    public func removeSubView(view:UIView){
        var index = 0
        for i in self.stack.subItems{
            if (i.view is UIView){
                let v = i.view as! UIView
                if(v == view){
                    break
                }
            }
            index += 1
        }
        if index < self.stack.subItems.count{
            self.stack.subItems.remove(at: index)
        }
        if self.subviews.contains(view){
            view.removeFromSuperview()
        }
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        if(self.systemLayoutFirst){
            self.stack.width = .volume(self.frame.width)
            self.stack.height = .volume(self.frame.height)
        }
        self.stack.layout()
    }
}
public class ItemView:UIView,itemAble{
    public var systemLayoutFirst: Bool = false
    
    public var item:Item
    public init(width:CGFloat,height:CGFloat){
        item = Item(width: width > 1 ? .volume(width) : .percent(width),
                    height: height > 1 ? .volume(height) : .percent(height))
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        item.view = self
    }
    public var width:CGFloat{
        get{
            return self.item.width.value
        }
        set{
            self.item.width = width > 1 ? .volume(width) : .percent(width)
        }
    }
    public var height:CGFloat{
        get{
            return self.item.height.value
        }
        set{
            self.item.height = height > 1 ? .volume(height) : .percent(height)
        }
    }
    public var grow:UInt{
        get{
            return self.item.grow
        }
        set{
            self.item.grow = newValue
        }
    }
    public var shrink:UInt{
        get{
            return self.item.shrink
        }
        set{
            self.item.shrink = newValue
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        item = Item(width: .volume(1),height:.volume(1))
        super.init(coder: aDecoder)
        self.systemLayoutFirst = true
        item.view = self
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        if(self.systemLayoutFirst){
            self.item.width = .volume(self.frame.width)
            self.item.height = .volume(self.frame.height)
        }
    }
}
