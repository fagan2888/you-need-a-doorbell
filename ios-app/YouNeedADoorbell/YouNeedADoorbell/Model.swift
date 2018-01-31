//
//  Model.swift
//  YouNeedADoorbell
//
//  Created by Micah Smith on 1/29/18.
//  Copyright © 2018 Micah Smith. All rights reserved.
//

import Foundation
import SwiftDate
import AVFoundation

class Gathering {
    static let DEFAULT_DETAIL = "555-555-1234"
    
    var title: String?
    var detail: String?
    var start: Date?
    var end: Date?
    
    // MARK: - doorbell configuration
    var assignHosts: Bool
    var assignRandomly: Bool
    var doorbell: Doorbell
    
    // MARK: - customizing guest list
    // TODO - consider changing to CNContact
    var hosts: [String] = []
    var approvedGuestList: [String] = []
    var blockedList: [String] = []
    
    // MARK: - computed properties
    var starts_in: String? {
        get {
            let now = DateInRegion()
            let (colloquial, _) = try! start!.colloquial(to: now.absoluteDate)
            return colloquial
        }
    }
    
    public init(title: String?,
                detail: String?,
                startDate: Date?,
                endDate: Date?,
                assignHosts: Bool = true,
                assignRandomly: Bool = false,
                doorbell: Doorbell? = nil) {
        self.title = title
        self.detail = detail ?? Gathering.DEFAULT_DETAIL
        self.start = startDate
        self.end = endDate
        
        self.assignHosts = assignHosts
        self.assignRandomly = assignRandomly
        
        if let doorbell = doorbell {
            self.doorbell = doorbell
        } else {
            self.doorbell = Doorbell()
        }
    }
}

class Doorbell {
    // todo get from somewhere else
    static let DEFAULT_DOORBELL_TEXT = "DING DONG!"
    static let DEFAULT_ARRIVAL_MESSAGE = "Guest {} has arrived to the party."
    static let DEFAULT_ASSIGNMENT_MESSAGE = "Please, {}, open the door."
    
    
    var doorbellText: String
    var voice: AVSpeechSynthesisVoice
    var arrivalMessage: String
    var assignmentMessage: String
    
    public convenience init() {
        self.init(doorbellText: nil, voiceIdentifier: nil, arrivalMessage: nil, assignmentMessage: nil)
    }
    
    public init(doorbellText: String?, voiceIdentifier: String?, arrivalMessage: String?, assignmentMessage: String?) {
        self.doorbellText = doorbellText ?? Doorbell.DEFAULT_DOORBELL_TEXT
        
        // careful with missings
        if let voiceIdentifier = voiceIdentifier {
            self.voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier)!
        } else {
            self.voice = AVSpeechSynthesisVoice()
        }
        
        self.arrivalMessage = arrivalMessage ?? Doorbell.DEFAULT_ARRIVAL_MESSAGE
        self.assignmentMessage = assignmentMessage ?? Doorbell.DEFAULT_ASSIGNMENT_MESSAGE
    }
    
    func announceArrival(guest: String?) {
        // pass
    }
}

extension AVSpeechSynthesisVoice {
    var colloquialIdentifier: String {
        get {
            return "\(self.name) (\(self.language))"
        }
    }
    
    static func fromColloquialIdentifier(identifier: String) -> AVSpeechSynthesisVoice? {
        guard let firstLeftParenthesisIndex = identifier.index(of: "(") else {
            // error
            return nil
        }
        let endOfNameIndex = identifier.index(firstLeftParenthesisIndex, offsetBy: -2)
        let beginningOfLanguageIndex = identifier.index(firstLeftParenthesisIndex, offsetBy: 1)
        let endOfLanguageEnd = identifier.index(identifier.endIndex, offsetBy: -1)
        let name = identifier[...endOfNameIndex]
        let language = identifier[beginningOfLanguageIndex...endOfLanguageEnd]

        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if voice.name == name && voice.language == language {
                return voice
            }
        }
        return nil
    }
}
