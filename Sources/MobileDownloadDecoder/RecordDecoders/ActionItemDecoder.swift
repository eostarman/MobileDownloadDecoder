import MobileDownload

import Foundation

extension ActionItemRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        actionItemNumber = record.getInt(3)
        assignedToEmpNid = record.getRecNidOrNil(4)
        cusNid = record.getRecNidOrNil(5)
        actionItemTypeNid = record.getRecNidOrNil(6)
        description = record.getString(7)
        contact = record.getString(8)
        pos = record.getString(9)
        actionDateRangeFrom = record.getDateTimeOrNil(10)
        actionDateRangeThru = record.getDateTimeOrNil(11)
        customer = record.getString(12)
        actionItemType = record.getString(13)
        actionItemState = record.getInt(14)
        actionItemStateText = record.getString(15)
        enteredByEmpNid = record.getRecNidOrNil(16)
        entryTime = record.getDateTimeOrNil(17)
    }
}
