//
//  Object.swift
//  FireUI
//
//  Created by hao yin on 2018/9/7.
//  Copyright © 2018年 hao yin. All rights reserved.
//

import Foundation
import simd
public class Object{
    public let shape:Shape
    public var texture:Texture?
    public var drawFunc:Function = Function.default
    public init(shape:Shape,texture:Texture? = nil) {
        self.shape = shape
        self.texture = texture
    }
    public func draw(view:FView){
        self.drawFunc.setMut4(name: "mat", m: view.ortho)
        self.drawFunc.setBool(name: "useColor", b: true)
        self.drawFunc.setFloat4(name: "backColor", v: [0,1,0,1]);
        self.drawFunc.useProgram()
        self.shape.draw()
    }
}
