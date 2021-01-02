import MobileDownload

import Foundation

extension ObjectiveRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        enteredByEmpNid = record.getRecNidOrZero(3)
        entryTime = record.getString(4) // DateTime
        dueByDate = record.getString(5) // DateTime
        doneTime = record.getString(6) // DateTime
        doneSuccess = record.getInt(7)
        doneComment = record.getString(8)
        cusNid = record.getRecNidOrNil(9)
        supNid = record.getRecNidOrNil(10)
        objectiveTypeNid = record.getRecNidOrZero(11)
        hostWhseNid = record.getRecNidOrZero(12)
        empNid = record.getRecNidOrZero(13)
        description = record.getString(14)
        supplierRecName = record.getString(15)
        enteredByRecName = record.getString(16)
        tempNid = record.getRecNidOrNil(17)
        startDate = record.getDateOrNil(18) ?? .distantPast
        pkgNid = record.getRecNidOrNil(19)
        brandNid = record.getRecNidOrNil(20)
        itemNid = record.getRecNidOrNil(21)
    }
}
