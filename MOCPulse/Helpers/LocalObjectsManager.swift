//
//  LocalObjectsManager.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit
import KeychainAccess

class LocalObjectsManager {
    
    var user : UserModel?
    
    var votes : [VoteModel]?
    
    class var sharedInstance : LocalObjectsManager {
        struct singleton {
            static let instance : LocalObjectsManager = LocalObjectsManager();
        }
        return singleton.instance
    }

    // MARK: -
    private var token : String?
    private var keychain : Keychain {
        return Keychain(service: NSBundle.mainBundle().bundleIdentifier!)
    }
    
    func removeAllCredentials() {
        setToken(nil, server: kAuthorizationServer)
        setToken(nil, server: kProductionServer)
        user = nil;
        votes = nil;
    }
    
    func setToken(_token: String?, server _server:String!) {
        
        token = _token
        keychain[_server] = _token
        
        var tokenHash: NSInteger = (_token == nil) ? 0 : _token!.hash
        NSUserDefaults.standardUserDefaults().setInteger(tokenHash, forKey: _server)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getToken(server _server: String) -> String? {
        
        if(token == nil) {
            token = keychain[_server]
        }
        
        var tokenHash: NSInteger = NSUserDefaults.standardUserDefaults().integerForKey(_server)
        return (tokenHash != 0 && token != nil && tokenHash == token!.hash) ? token : nil;
    }
    
    // MARK: Management Votes
    func getLastVote() -> VoteModel? {
        var vote : VoteModel? = votes?.filter{(vote:VoteModel) in vote.voted == false}.first
        return vote;
    }
    
    func getVoteById(id: String) -> VoteModel? {
        var vote : VoteModel? = votes?.filter{(vote:VoteModel) in vote.id! == id}.first
        return vote;
    }
    
    func sortVotesByDate() {
        self.votes = self.votes?.sorted{($0 as VoteModel).isNewerThan($1 as VoteModel)}
    }
    
    func removeVote(voteId: String) {
        for (index, vote) in enumerate(self.votes!) {
            if (vote.id == voteId) {
                self.votes?.removeAtIndex(index)
                break
            }
        }
    }
    
    func replaceVoteIfExists(vote: VoteModel) -> Bool {
        for (index, voteitr) in enumerate(self.votes!) {
            if (voteitr.id == vote.id) {
                self.votes![index] = vote
                return true
            }
        }
        
        return false
    }
    
    // MARK: Generation
    func generationVotes(count _count:Int) -> [VoteModel] {
        var votes : [VoteModel] = []
        for (var i = 0; i < _count; i++) {
            var vote: VoteModel = VoteModel(id: String(i), name: self.randomStringWithLength(Int(10 + arc4random_uniform(130))))
            
            vote.owner = self.randomStringWithLength(Int(5+arc4random_uniform(30)))
            vote.voted = (arc4random_uniform(2) != 0)
            
            vote.greenVotes = Int(arc4random_uniform(25))
            vote.redVotes = Int(arc4random_uniform(25))
            vote.yellowVotes = Int(arc4random_uniform(25))
            
            vote.create = NSDate()

            vote.voteUsers = vote.greenVotes! + vote.redVotes! + vote.yellowVotes!;
            vote.allUsers = vote.voteUsers! + Int(arc4random_uniform(25))
            
            votes.append(vote)
        }
        return votes;
    }
    
    private func randomStringWithLength (len : Int) -> String {
        
        let letters : String = "   abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : String = String()
        
        for (var i = 0; i < len; i++) {
            var length = UInt32 (count(letters))
            var rand = arc4random_uniform(length)
            let char : Character = letters[advance(letters.startIndex, Int(rand))]
            randomString.append(char)
        }
        
        return randomString
    }
}
