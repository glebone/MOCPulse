//
//  PulsePacket.swift
//  MOCPulse OSX
//
//  Created by Admin on 17.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Foundation
import SwiftyJSON

class PulsePacket: NSObject {
   
    var opcode : UInt16!
    var size : UInt32!
    
    var content : JSON! {
        didSet {
            
            var raw : NSData? = nil
            if content != nil {
                do {
                    raw = try content.rawData()
                } catch _ {
                    raw = nil
                }
            }
            
            if raw != nil {
                self.size = UInt32((try! content.rawData()).length)
                if (self.size == nil) {
                    self.size = 0
                }
            } else {
                self.size = 0
            }
        }
    }
    
    override init() {
        super.init()
        self.size = 0
    }
    
    init(opcode: UInt16) {
        super.init()
        
        self.opcode = opcode
        self.size = 0
    }
    
    init(headerData: Array<UInt8>) {
        super.init()
        
        self.opcode = UInt16(headerData[0]) << 8 | UInt16(headerData[1])
        let sizePart1 = UInt32(headerData[2]) << 24 | UInt32(headerData[3]) << 16
        
        self.size = sizePart1 | UInt32(headerData[4]) << 8 | UInt32(headerData[5])
    }
    
    func toData() -> NSData {
        let header : [UInt8] = [
            UInt8((opcode >> 8) & 0xFF), UInt8(opcode & 0xFF),
            UInt8((size >> 24) & 0xFF),
            UInt8((size >> 16) & 0xFF),
            UInt8((size >> 8) & 0xFF),
            UInt8(size & 0xFF)
        ]
        
        let headerData = NSData(bytes: header, length: header.count)
        var contentData : NSData? = nil
        
        do {
            contentData = size > 0 ? try content.rawData() : nil
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let data : NSMutableData = NSMutableData(data: headerData)
        if (contentData != nil) {
            data.appendData(contentData!)
        }
        
        return data
    }
}

extension PulsePacket {
    override var description: String {
        return "Packet \(Opcode(rawValue: self.opcode)!.description). Size: \(self.size). Content: \(self.content)."
    }
}
