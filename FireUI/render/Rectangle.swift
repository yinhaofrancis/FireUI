//
//  Rectangle.swift
//  FireUI
//
//  Created by Francis on 2018/9/7.
//  Copyright © 2018年 Francis. All rights reserved.
//

import UIKit
import QuartzCore
public class Rectangle:Shape{
    var frame:CGRect
    public init(frame:CGRect){
        self.frame = frame
        let w:Float = Float(frame.width * UIScreen.main.scale * 2)
        let h:Float = Float(frame.height * UIScreen.main.scale * -2)
        let x:Float = Float(frame.minX * UIScreen.main.scale * 2)
        let y:Float = Float(frame.minY * UIScreen.main.scale * -2)
        super.init(vertice: [Vertex(location: [w + x,y,0,1], uv: [1,1]),
                            Vertex(location: [w + x,h + y,0,1], uv: [1,0]),
                            Vertex(location: [x,h + y,0,1], uv: [0,0]),
                            Vertex(location: [x,y,0,1], uv: [0,1])])
        self.indecs = [0,1,2,0,2,3]
    }
}
