//
//  Stack.swift
//  FireUI
//
//  Created by hao yin on 2018/9/6.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import QuartzCore
import Foundation
public class StackContainer:Container{
    
    public var direction:Direction = .vertical
    public var justContent:JustContent = .start
    public var alignItem:Align = .stretch
    public override func layout() {
        if (parent == nil){
            self.calcSize()
        }
        
        var start = CGPoint.zero
        var sum:CGFloat = 0
        var fixSum:CGFloat = 0
        var g:UInt = 0
        var s:UInt = 0
        for i in self.subItems {
            i.calcSize()
            g += i.grow
            s += i.shrink
            switch direction {
            case .horizontal:
                sum += i.resultW
            case .vertical:
                sum += i.resultH
            }
        }
        for i in subItems {
            switch direction {
            case .horizontal:
                let extra = self.resultW - sum
                i.fixSize(extraSize: extra, direction: self.direction,growsum: g,shrinksum: s);
                fixSum += i.resultW
            case .vertical:
                let extra = self.resultH - sum
                i.fixSize(extraSize: extra, direction: self.direction,growsum: g,shrinksum: s);
                fixSum += i.resultH
            }
        }
        var axis:CGFloat = 0
        var offset:CGFloat = 0
        switch direction {
        case .vertical:
            fixSum = self.resultH - fixSum
        case .horizontal:
            fixSum = self.resultW - fixSum
        }
        switch self.justContent {
        case .start:
            axis = 0
            offset = 0
            break
        case .center:
            axis = CGFloat(fixSum) / 2
            offset = 0
            break
        case .end:
            axis = CGFloat(fixSum)
            offset = 0
            break
        case .around:
            axis = CGFloat(fixSum) / CGFloat(self.subItems.count) / 2
            offset = CGFloat(fixSum) / CGFloat(self.subItems.count)
            break
        case .between:
            axis = 0
            if self.subItems.count > 1{
                offset = CGFloat(fixSum) / CGFloat(self.subItems.count - 1)
            }else{
                offset = 0
            }
        case .evenly:
            axis = CGFloat(fixSum) / CGFloat(self.subItems.count  + 1)
            offset = CGFloat(fixSum) / CGFloat(self.subItems.count  + 1)
            break
        }
        switch direction {
        case .horizontal:
            start.x = axis
        case .vertical:
            start.y = axis
            
        }
        for i in subItems {
            switch direction {
            case .horizontal:
                i.resultX = start.x
                start.x += i.resultW + offset
                switch self.alignItem{
                case .stretch:
                    i.resultH = self.resultH
                    i.resultY = 0
                    break
                case .start:
                    i.resultY = 0
                    break
                case .center:
                    i.resultY = (self.resultH - i.resultH) / 2
                    break
                case .end:
                    i.resultY = self.resultH - i.resultH
                    break
                }
                break
            case .vertical:
                i.resultY = start.y
                start.y += i.resultH + offset
                switch self.alignItem{
                case .start:
                    i.resultX = 0
                    break
                case .center:
                    i.resultX = (self.resultW - i.resultW) / 2
                    break
                case .end:
                    i.resultX = (self.resultW - i.resultW)
                    break
                case .stretch:
                    i.resultW = self.resultW
                    i.resultX = 0
                    break
                }
                break
            }
            i.layout()
        }
    }
}
