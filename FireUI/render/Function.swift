//
//  Function.swift
//  FireUI
//
//  Created by Francis on 2018/9/6.
//  Copyright © 2018年 Francis. All rights reserved.
//

import simd
import OpenGLES.ES3
import OpenGLES
import Foundation
import QuartzCore

public class Function{
    public static var `default`:Function{
        let vs:String = """
        #version 300 es
        layout(location = 0)in vec4 vPosition;
        layout(location = 1)in vec2 uv;
        uniform mat4 mat;
        out vec2 pUV;
        void main(){
            pUV = uv;
            gl_Position = mat * vPosition;
        }
"""
        let fs:String = """
        #version 300 es
        precision lowp float;
        uniform vec4 backColor;
        uniform bool useColor;
        in vec2 pUV;
        out vec4 r_color;
        void main(){
            if(useColor){
                r_color = backColor;
            }else{
                r_color = vec4(1,1,0,1);
            }
        }
"""
        return Function(v: vs, f: fs)
    }
    public var vershader:GLuint = 0
    public var frashader:GLuint = 0
    public var program:GLuint = 0
    public init(v:String,f:String){
        self.vershader = self.create(string: v, type: GL_VERTEX_SHADER)
        self.frashader = self.create(string: f, type: GL_FRAGMENT_SHADER)
        self.program = self.linkProgram(vs: self.vershader, fs: self.frashader)
    }
    func convert(v:UnsafeRawPointer)->UnsafePointer<Int8>?{
        return v.assumingMemoryBound(to: Int8.self)
    }
    func create(string:String,type:Int32)->GLuint{
        let shader = glCreateShader(GLenum(type))
        var p = self.convert(v: string)
        glShaderSource(shader, 1, &p, nil)
        glCompileShader(shader)
        var compile:GLint = 0
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &compile)
        print(self.getShaderInfo(object: shader))
        if (compile == GL_FALSE){
            glDeleteShader(shader)
            return 0
        }
        return shader
    }
    func linkProgram(vs:GLuint,fs:GLuint)->GLuint{
        let program = glCreateProgram()
        glAttachShader(program, vs)
        glAttachShader(program, fs)
        glLinkProgram(program)
        var flag = GL_FALSE
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &flag)
        print(self.getLinkInfo(object: program))
        if (flag == GL_TRUE){
            return program
        }else{
            
            glDeleteProgram(program)
            return 0
        }
        
    }
    func getShaderInfo(object:GLuint)->String{
        var infoLen:Int32 = 0
        glGetShaderiv(object, GLenum(GL_INFO_LOG_LENGTH), &infoLen)
        let c:UnsafeMutablePointer<GLchar> = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(infoLen))
        glGetShaderInfoLog(object, infoLen, nil, c)
        let s = String(cString: c)
        c.deallocate()
        return s
    }
    func getLinkInfo(object:GLuint)->String{
        var infoLen:Int32 = 0
        glGetShaderiv(object, GLenum(GL_INFO_LOG_LENGTH), &infoLen)
        let c:UnsafeMutablePointer<GLchar> = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(infoLen))
        glGetProgramInfoLog(object, infoLen, nil, c)
        let s = String(cString: c)
        c.deallocate()
        return s
    }
    public func useProgram(){
        glUseProgram(program)
    }
    public func setBool(name:String,b:Bool){
        let index = glGetUniformLocation(self.program, self.convert(v: name))
        glUniform1i(index, b ? 1 : 0)
    }
    public func setFloat4(name:String,v:float4){
        let index = glGetUniformLocation(self.program, self.convert(v: name))
        glUniform4f(index, v.x, v.y, v.z, v.w)
    }
    public func setMut4(name:String,m:float4x4){
        let index = glGetUniformLocation(self.program, self.convert(v: name))
        glUniformMatrix4fv(index, 1, GLboolean(GL_TRUE),m.values)
    }
}
extension float4x4{
    public var values:[Float]{
        return self.columns.0.map{$0} + self.columns.1.map{$0} + self.columns.2.map{$0} + self.columns.3.map{$0}
    }
}
