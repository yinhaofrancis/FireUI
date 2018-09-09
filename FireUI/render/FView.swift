//
//  FWindow.swift
//  FireUI
//
//  Created by Francis on 2018/9/5.
//  Copyright © 2018年 Francis. All rights reserved.
//

import UIKit
import simd
public class FView: UIView {
    
    private var frameBuffer:GLuint = 0
    private var renderBuffer:GLuint = 0
    private var renderBufferWidth:Int32 = 0
    private var renderBufferHeight:Int32 = 0
    private var context:EAGLContext?
    private var link:CADisplayLink?

    public var object:Object?
    public override init(frame:CGRect) {
        super.init(frame: frame)
        self.config()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self .config()
    }
}
extension FView{
    public static func orthoMatrix(left:Float,right:Float,top:Float,bottom:Float,near:Float,far:Float)->float4x4{
        let a = 2 / (right - left)
        let b = 2 / (top - bottom)
        let c = 1 / (far - near)
        let d1 = -(right + left) / (right - left)
        let d2 = -(top + bottom) / (top - bottom)
        let d3 = -near / (far - near)
        return self.translate(x: left, y: top, z: 0) * float4x4([[a ,0  ,0  ,0],
                                                                 [0 ,b  ,0  ,0],
                                                                 [0 ,0  ,c  ,0],
                                                                 [d1,d2 ,d3 ,1]])
    }
    public static func translate(x:Float,y:Float,z:Float)->float4x4{
        return float4x4([[1 ,0  ,0  ,x],
                         [0 ,1  ,0  ,y],
                         [0 ,0  ,1  ,z],
                         [0 ,0  ,0 ,1]])
    }
    public var ortho:float4x4{
        return FView.orthoMatrix(left: -Float(self.renderBufferWidth), right:Float(self.renderBufferWidth), top: Float(self.renderBufferHeight), bottom: -Float(self.renderBufferHeight), near: 0, far: 10000)
    }
    public static var context:EAGLContext? = {
        if let current = EAGLContext.current(){
            if(current.api == .openGLES3){
                return current
            }else{
                let c = EAGLContext.init(api: .openGLES3, sharegroup: current.sharegroup)
                EAGLContext.setCurrent(c);
                return c
            }
        }else{
            let c = EAGLContext.init(api: .openGLES3)
            
            EAGLContext.setCurrent(c);
            return c
        }
    }()
    public override class var layerClass:AnyClass {
        return CAEAGLLayer.self
    }
    public var glLayer:CAEAGLLayer{
        return self.layer as! CAEAGLLayer
    }
    
    func config(){
        self.context = FView.context
        link = CADisplayLink(target: self, selector: #selector(render))
        self.layer.contentsScale = UIScreen.main.scale;
        self.layer.rasterizationScale = UIScreen.main.scale
        self.glLayer.drawableProperties = [kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8,
                                           kEAGLDrawablePropertyRetainedBacking:false]
        configFrameBuffer()
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    func configFrameBuffer(){
        
        glGenRenderbuffers(1, &self.renderBuffer);
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), self.renderBuffer);
        self.context?.renderbufferStorage(Int(GL_RENDERBUFFER), from: self.glLayer)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &self.renderBufferWidth)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &self.renderBufferHeight)
        glGenBuffers(1, &self.frameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), self.frameBuffer)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), self.renderBuffer)
        
    }
    public override func didMoveToWindow() {
        if self.superview == nil{
            self.link?.remove(from: RunLoop.main, forMode: .commonModes)
        }else{
            self.link?.add(to: RunLoop.main, forMode: .commonModes)
        }
    }
    public override func setNeedsDisplay() {
        super.setNeedsDisplay()
        self.render()
    }
    @objc public func render(){
        glViewport(0, 0, self.renderBufferWidth, self.renderBufferHeight)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        if let d = self.object{
            d.draw(view: self)
        }
        self.context?.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }
}
