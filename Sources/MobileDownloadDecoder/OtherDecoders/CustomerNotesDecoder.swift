//
//  CustomerNotesService.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 8/19/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

struct CustomerNotesDecoder {
    private enum eToken: String {
        case recNid = "a"
        case cusNid = "b"
        case entryTime = "c"
        case entryEmpNid = "d"
        case isCollectionsNote = "e"
        case isServiceCallNote = "f"
        case note = "g"
    }

    static func decodeCustomerNotes(customerNotesSection: [[String]]) -> [CustomerNote] {
        let lines = customerNotesSection

        var notes: [CustomerNote] = []

        for var line in lines {
            guard let firstField = line.first else {
                continue
            }
            let activeFlag: Bool
            if firstField.hasPrefix("!!") {
                activeFlag = false
                line[0] = String(line[0].dropFirst(2))
            } else {
                activeFlag = true
            }

            var recNid = 0
            var cusNid = 0
            var entryTime = Date()
            var entryEmpNid = 0
            var isCollectionsNote = false
            var isServiceCallNote = false
            var noteText = ""

            let tokens = TokenService(line).tokens

            for field in tokens {
                let token = eToken(rawValue: field.tokenType)

                switch token {
                case .recNid: recNid = field.intValue
                case .cusNid: cusNid = field.intValue
                case .entryTime: entryTime = field.dateOrTimeValue
                case .entryEmpNid: entryEmpNid = field.intValue
                case .isCollectionsNote: isCollectionsNote = field.boolValue
                case .isServiceCallNote: isServiceCallNote = field.boolValue
                case .note: noteText = field.stringValue

                case .none:
                    break
                }
            }

            var note = CustomerNote()
            note.recNid = recNid
            note.cusNid = cusNid
            note.entryTime = entryTime
            note.entryEmpNid = entryEmpNid
            note.isCollectionsNote = isCollectionsNote
            note.isServiceCallNote = isServiceCallNote
            note.activeFlag = activeFlag
            note.note = noteText

            notes.append(note)
        }

        return notes.sorted(by: { $0.entryTime > $1.entryTime })
    }
}
