//
//  TcpSocket.swift
//  MOCPulse OSX
//
//  Created by admin on 17.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Foundation
import SwiftyJSON

class TcpSocket: NSObject, NSStreamDelegate {
    
    static var sharedInstance = TcpSocket()
    
    var host : String!
    var port : Int!
    
    var session : PulseSession?
    var isopen : Bool!
    
    private var input : NSInputStream?
    private var output: NSOutputStream?

    private var headerReadIndex : Int! = 0
    private var contentReadIndex : Int! = 0
    private var packet : PulsePacket? = nil
    
    private var waitingForContent : Bool!
    
    private var headerData : [UInt8]! = []
    private var contentData : [UInt8]! = []
    
    override init() {
        super.init()
        
        self.session = nil
        self.isopen = false
        
        self.waitingForContent = false
    }
    
    func connect(host: String, port: Int) {
        self.host = host
        self.port = port
        
        NSStream.getStreamsToHostWithName(host, port: port, inputStream: &(self.input), outputStream: &(self.output))
        
        self.input!.delegate  = self
        self.output!.delegate = self
        
        self.input!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.output!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.input!.open()
        self.output!.open()
    }
    
    func reconnectIfNeeded() {
        if (self.isopen == false) {
            self.connect(self.host, port: self.port)
        }
    }
    
    func close() {
        self.input?.close()
        self.output?.close()
        self.isopen = false
        
        if (session != nil) {
            session?.socketClosed()
        }
    }
    
    func send(packet: PulsePacket) {
        if (!self.isopen) {
            print("Trying to send data to closed socket.")
            return
        }
        
        let data : NSData = packet.toData()
        self.output?.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch(eventCode) {
            case NSStreamEvent.EndEncountered :
                print("EndEncountered")
                close()
            case NSStreamEvent.ErrorOccurred:
                print("Error. TcpSocket: (\(aStream.streamError!.code)) \(aStream.streamError!.localizedDescription).")
                close()
            case NSStreamEvent.HasSpaceAvailable:
                if (isopen == true) {
                    break
                }
                
                self.isopen = true
                
                if (session == nil) {
                    session = PulseSession(socket: self)
                }
            
                session?.tryAuth("123123")
            
            case NSStreamEvent.HasBytesAvailable:
                
                if self.readHeader() {
                    let newpacket = self.readContent()
                    if newpacket != nil {
                        print("packet: \(newpacket)")
                        self.handleNewPacket(newpacket!)
                        packet = nil
                    }
                }
            
            default:
                print("unk event")
        }
    }
    
    private func readHeader() -> Bool {
        let headerSize = 6
        let bytesLeft = headerSize - headerReadIndex
        
        if (bytesLeft == 0 || waitingForContent == true) {
            return true
        }
        
        let buf = NSMutableData(capacity: bytesLeft)
        let buffer = UnsafeMutablePointer<UInt8>(buf!.bytes)
        let length = self.input!.read(buffer, maxLength: bytesLeft)
        let data = length > 0 ? Array(UnsafeBufferPointer(start: buffer, count: length)) : []
        
        headerData! += data
        headerReadIndex! += length
        
        if headerReadIndex == headerSize {
            packet = PulsePacket(headerData: headerData)
            
            headerReadIndex = 0
            headerData = []
            
            waitingForContent = true
            
            return true
        }
        
        return false
    }
    
    private func readContent() -> PulsePacket? {
        let contentSize = Int(packet!.size!)
        
        if (contentSize == 0) {
            contentReadIndex = 0
            contentData = []
            
            return packet
        }
        
        let bytesLeft = contentSize - contentReadIndex
        
        let buf = NSMutableData(capacity: bytesLeft)
        let buffer = UnsafeMutablePointer<UInt8>(buf!.bytes)
        let length = self.input!.read(buffer, maxLength: bytesLeft)
        let data = length > 0 ? Array(UnsafeBufferPointer(start: buffer, count: length)) : []
        
        contentData! += data
        contentReadIndex! += length
        
        if contentReadIndex == contentSize {
            let jsonData = NSData(bytes: contentData, length: contentSize)
            let json = JSON(data: jsonData)
            if (json != nil) {
                packet?.content = json
            }
            
            contentReadIndex = 0
            contentData = []
            
            waitingForContent = false
            
            return packet
        }
        
        return nil
    }
    
    private func handleNewPacket(newpacket: PulsePacket) {
        NSNotificationCenter.defaultCenter().postNotificationName("newpacket", object: newpacket)
    }
}
