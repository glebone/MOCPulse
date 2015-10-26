//
//  PulseSession.swift
//  MOCPulse OSX
//
//  Created by Admin on 18.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Foundation
import SwiftyJSON

class PulseSession: NSObject {
    var isAuth : Bool!
    var socket : TcpSocket!
    
    init(socket: TcpSocket) {
        super.init()
        
        self.socket = socket
        self.isAuth = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "processPacket:", name:"newpacket", object: nil)
    }
    
    func send(packet: PulsePacket) {
        if (self.socket.isopen == true) {
            self.socket.send(packet)
        } else {
            print("Trying send packet with closed socket.")
        }
    }
    
    func processPacket(notification: NSNotification) {
        let packet : PulsePacket! = notification.object as! PulsePacket
        switch packet.opcode {
        case Opcode.SC_AUTH.rawValue:
            self.handleAuth(packet)
        case Opcode.SC_GET_VOTES_RESULT.rawValue:
            self.handleGetVotes(packet)
        case Opcode.SC_NEW_VOTE.rawValue:
            self.handleNewVote(packet)
        case Opcode.SC_UPDATE_VOTE.rawValue:
            self.handleUpdateVote(packet)
        default:
            print("Received Unk Opcode.")
        }
    }
    
    func socketClosed() {
        isAuth = false
    }
    
// MARK: Requests to server
    
    func tryAuth(token: String) {
        var packet = PulsePacket(opcode: Opcode.CS_AUTH.rawValue)
        packet.content = JSON(["token":token])
        send(packet)
    }
    
    func getVotesQuery() {
        let packet = PulsePacket(opcode: Opcode.CS_GET_VOTES.rawValue)
        send(packet)
    }
    
    func getVoteQuery(voteId: String) {
        var packet = PulsePacket(opcode: Opcode.CS_GET_VOTE.rawValue)
        packet.content = JSON(["id":voteId])
        send(packet)
    }
    
    func createVote(question: String) {
        var packet = PulsePacket(opcode: Opcode.CS_CREATE_VOTE.rawValue)
        packet.content = JSON(["name":question])
        send(packet)
    }
    
    func voteFor(voteId: String, colorId: Int) {
        var packet = PulsePacket(opcode: Opcode.CS_VOTE_FOR.rawValue)
        packet.content = JSON(["id":voteId, "color":colorId])
        send(packet)
    }
    
// MARK: Hanlers
    
    func handleAuth(packet: PulsePacket) {
        if var id = packet.content["id"].string {
            if id.isEmpty != true {
                self.isAuth = true
                
//                self.getVotesQuery()
                
                return
            }
        }
    }
    
    func handleGetVotes(packet: PulsePacket) {
        var votes = VoteModel.jsonToVotes(packet.content)
        LocalObjectsManager.sharedInstance.votes = votes
        
        LocalObjectsManager.sharedInstance.sortVotesByDate()
        
//        NSNotificationCenter.defaultCenter().postNotificationName("reloadVotes", object: nil)
    }
    
    func handleNewVote(packet: PulsePacket) {
        var vote : VoteModel = VoteModel(json: packet.content["vote"])
        if (LocalObjectsManager.sharedInstance.votes != nil) {
            LocalObjectsManager.sharedInstance.votes! = [vote] + LocalObjectsManager.sharedInstance.votes!
        } else {
            LocalObjectsManager.sharedInstance.votes! = [vote]
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("reloadVotes", object: nil)
    }
    
    func handleUpdateVote(packet: PulsePacket) {
        var vote : VoteModel = VoteModel(json: packet.content["vote"])
        
        if var oldVote = LocalObjectsManager.sharedInstance.getVoteById(vote.id!) {
            vote.voted = oldVote.voted
            LocalObjectsManager.sharedInstance.removeVote(vote.id!)
        }
        
        if (LocalObjectsManager.sharedInstance.votes != nil) {
            LocalObjectsManager.sharedInstance.votes! += [vote]
        } else {
            LocalObjectsManager.sharedInstance.votes! = [vote]
        }
        
        LocalObjectsManager.sharedInstance.sortVotesByDate()
        
        NSNotificationCenter.defaultCenter().postNotificationName("voteUpdated", object: vote)
    }
}
