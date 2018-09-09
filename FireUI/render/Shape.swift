//
//  Shape.swift
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
public struct Vertex{
    var location:float4
    var uv:float2
}
public class Shape {
    public var vertexBuffer:GLuint = 0
    public var indexBuffer:GLuint = 0
    public var vertice:[Vertex] = []{
        didSet{
            glDeleteBuffers(1, &self.vertexBuffer)
            vbufferCreate()
        }
    }
    public var indecs:[GLushort] = []{
        didSet{
            glDeleteBuffers(1, &self.indexBuffer)
            ibufferCreate()
        }
    }
    public init(vertice:[Vertex]) {
        self.vertice = vertice
        self.vbufferCreate()
    }
    func vbufferCreate(){
        glGenBuffers(1, &self.vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertice.count * MemoryLayout<Vertex>.stride, self.vertice, GLenum(GL_STATIC_DRAW))
    }
    func ibufferCreate(){
        glGenBuffers(1, &self.indexBuffer)
        
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), self.indexBuffer)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), vertice.count * MemoryLayout<UInt32>.stride, self.indecs, GLenum(GL_STATIC_DRAW))
    }
    public func draw(){
        
        if indexBuffer == 0{
            let index0:Int = 0
            let index1:Int = MemoryLayout<Float>.stride * 4
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.vertexBuffer)
            glEnableVertexAttribArray(0)
            glEnableVertexAttribArray(1)
            glVertexAttribPointer(0, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.stride), UnsafeRawPointer(bitPattern: index0))
            glVertexAttribPointer(1, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.stride), UnsafeRawPointer(bitPattern: index1))
            glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(self.vertice.count))
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
            
        }else{
            let index0:Int = 0
            let index1:Int = MemoryLayout<Float>.stride * 4
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), self.vertexBuffer)
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), self.indexBuffer)
            glEnableVertexAttribArray(0)
            glEnableVertexAttribArray(1)
            glVertexAttribPointer(0, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.stride), UnsafeRawPointer(bitPattern: index0))
            glVertexAttribPointer(1, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.stride), UnsafeRawPointer(bitPattern: index1))
            glDrawElements(GLenum(GL_TRIANGLES), GLsizei(self.indecs.count), GLenum(GL_UNSIGNED_SHORT),UnsafeRawPointer(bitPattern: 0))
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
        }
    }
}
public class Texture{
    public init(img:[CGImage]){
        
    }
    public init(img:CGImage){
        img.dataProvider?.data
    }
}


