import MobileDownload

import Foundation

extension EquipmentRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        manfNid = record.getRecNidOrNil(3)
        equipModelNid = record.getRecNidOrNil(4)
        equipTypeNid = record.getRecNidOrNil(5)
        miscInfo = record.getString(6)
        vendInventoryBlob = record.getString(7)
        equipmentTransferHistoryBlob = record.getString(8)
        vendPlanogramNid = record.getRecNidOrNil(9)
        vendPlanogramFromDate = record.getDateOrNil(10)
        vendPlanogramThruDateAsInt = record.getDateOrNil(11)
        isVendingMachine = record.getBool(12)
        changeFund = record.getAmount2(13)
        lockKeyNumber = record.getString(14)
        vendSetupString = record.getString(15)
        vendServiceSkipDates = record.getString(16)
        lastFillDateAsString = record.getString(17)
        fillFrequence = record.getString(18)
        dexData = record.getString(19)
        isUnderReview = record.getBool(20)
        brandNid = record.getRecNidOrNil(21)
    }
}
