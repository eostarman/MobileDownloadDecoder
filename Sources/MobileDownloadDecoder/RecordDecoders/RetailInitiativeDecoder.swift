import MobileDownload

import Foundation

extension RetailInitiativeRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        fromDate = record.getDateOrNil(3)
        thruDate = record.getDateOrNil(4)
        let cusNidCount = record.getInt(5)
        for i in 0 ..< cusNidCount {
            cusNids.insert(record.getInt(6 + i))
        }
        description = record.getString(6 + cusNidCount)
        let retailInitiativeXml = record.getString(6 + cusNidCount + 1)
        retailInitiative = Self.getRetailInitiative(record: self, retailInitiativeXml: retailInitiativeXml)
    }

    private static func getRetailInitiative(record: RetailInitiativeRecord, retailInitiativeXml: String) -> RetailInitiative {
        let decoder = RetailInitiativeXMLDecoder()
        let sections = decoder.parse(xml: retailInitiativeXml)

        let retailInitiative = RetailInitiative(id: record.recNid, fromDate: record.fromDate, thruDate: record.thruDate, cusNids: record.cusNids, description: record.description)
        retailInitiative.sections = sections

        return retailInitiative
    }
}
