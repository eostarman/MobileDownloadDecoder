//
//  CusEventDecoder.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/23/20.
//

import Foundation
import MoneyAndExchangeRates
import MobileDownload

struct CusEventsDecoder {
    /// the parser for the current MobileDownload encoding. It's pretty ugly but it mimics the c# code in CusEvents.cs
    static func decodeCusEvents(eventsBlob: String, isFiveDigitEmpNids: Bool) -> [CusEvent] {
        var events: [CusEvent] = []

        if eventsBlob.isEmpty {
            return []
        }

        let chrs = Array(eventsBlob)

        var x = 0

        let chr_0 = Int(Character("0").asciiValue!)
        func minus0(_ chr: Character) -> Int {
            let diff = Int(chr.asciiValue!) - chr_0
            return diff
        }
        let chr_A = Int(Character("A").asciiValue!)
        func minusA(_ chr: Character) -> Int {
            let diff = Int(chr.asciiValue!) - chr_A
            return diff
        }

        while x < chrs.count {
            let taskCharacter = chrs[x]
            x += 1
            let taskInteger = minusA(taskCharacter) // 0=presell 1=telsell 2=offtruck 3=deliver(presold order), 4=AlternateDeliveryDriver, 5=Merchandiser, 6=Vending
            let task = CusEvent.eTask(rawValue: taskInteger)! // (eTask)(chrs[x++] - "A")

            var monday = false
            var tuesday = false
            var wednesday = false
            var thursday = false
            var friday = false
            var saturday = false
            var sunday = false
            var cycleLength = 1
            var weekOfCycle = 1
            var equipNid: Int?

            var bDoneParsingDays = false

            var empNid = 0

            // KJQ 10/23/08 ... special case for InnerMountain DB that had, due to conversion, empnids with 5 digits

            if !isFiveDigitEmpNids {
                empNid = minus0(chrs[x + 0]) * 1000 + minus0(chrs[x + 1]) * 100 + minus0(chrs[x + 2]) * 10 + minus0(chrs[x + 3])
                x += 4
            } else {
                empNid = minus0(chrs[x + 0]) * 10000 + minus0(chrs[x + 1]) * 1000 + minus0(chrs[x + 2]) * 100 + minus0(chrs[x + 3]) * 10 + minus0(chrs[x + 4])
                x += 5
            }
            ////////////////////////////////////////////////////////////////////////////////

            while x < chrs.count {
                let chr = chrs[x]
                switch chr {
                case "0":
                    sunday = true
                    x += 1
                case "1":
                    monday = true
                    x += 1
                case "2":
                    tuesday = true
                    x += 1
                case "3":
                    wednesday = true
                    x += 1
                case "4":
                    thursday = true
                    x += 1
                case "5":
                    friday = true
                    x += 1
                case "6":
                    saturday = true
                    x += 1

                case "c":
                    cycleLength = minusA(chrs[x + 1])
                    weekOfCycle = minusA(chrs[x + 2])
                    x += 3

                case "~":
                    x += 1 // eat the note: ~xxxxx~
                    while chrs[x] != "~" {
                        x += 1
                    }
                    x += 1

                case "!": // equipment Nid ... if encountered, then looks like: !2! or !123! or !3456! etc.
                    x += 1
                    equipNid = minus0(chrs[x])
                    x += 1

                    while chrs[x] != "!" {
                        equipNid = ((equipNid ?? 0) * 10) + minus0(chrs[x])
                        x += 1
                    }

                    x += 1

                default:
                    bDoneParsingDays = true
                }

                if bDoneParsingDays {
                    break
                }
            }

            let event = CusEvent(task: task, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday, sunday: sunday, cycleLength: cycleLength, weekOfCycle: weekOfCycle, empNid: empNid, equipNid: equipNid)
            events.append(event)
        }

        return events
    }
}
