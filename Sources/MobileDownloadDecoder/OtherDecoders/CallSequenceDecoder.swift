//
//  CallSequenceDecoder.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/22/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

struct CallSequenceDecoder {
    static func decodeCallSequences(scheduleSequencesSection: [[String]]) -> [CallSequence] {
        guard let blob = scheduleSequencesSection.first?.first else {
            return []
        }

        let allLines = blob.components(separatedBy: ";")
        var callSequences: [CallSequence] = []

        for line in allLines {
            let fields = line.components(separatedBy: ",")
            if fields.count >= 2 {
                let dateOrDayOfTheWeek = Int(fields[0]) ?? 0
                let cusNidsInSequence = fields[1...].map { String($0).asRecNid ?? 0 }.filter { $0 > 0 }

                callSequences.append(CallSequence(dateOrDayOfTheWeek: dateOrDayOfTheWeek, cusNidsInSequence: cusNidsInSequence))
            }
        }

        return callSequences
    }
}
