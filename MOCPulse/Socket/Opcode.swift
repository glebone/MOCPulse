//
//  Opcode.swift
//  MOCPulse OSX
//
//  Created by Admin on 17.07.15.
//  Copyright (c) 2015 Master of Code. All rights reserved.
//

import Foundation

enum Opcode:UInt16 {
    case
    CS_AUTH = 0,
    SC_AUTH,
    CS_GET_VOTES,
    SC_GET_VOTES_RESULT,
    CS_GET_VOTE,
    SC_GET_VOTE_RESULT,
    CS_VOTE_FOR,
    SC_UPDATE_VOTE,
    CS_CREATE_VOTE,
    SC_NEW_VOTE
    
    var description: String {
        switch self {
        case CS_AUTH: return "CS_AUTH"
        case SC_AUTH: return "SC_AUTH"
        case CS_GET_VOTES: return "SC_AUTH"
        case SC_GET_VOTES_RESULT: return "SC_GET_VOTES_RESULT"
        case CS_GET_VOTE: return "CS_GET_VOTE"
        case SC_GET_VOTE_RESULT: return "SC_GET_VOTE_RESULT"
        case CS_VOTE_FOR: return "CS_VOTE_FOR"
        case SC_UPDATE_VOTE: return "SC_UPDATE_VOTE"
        case CS_CREATE_VOTE: return "CS_CREATE_VOTE"
        case SC_NEW_VOTE: return "SC_NEW_VOTE"
        }

    }
}

