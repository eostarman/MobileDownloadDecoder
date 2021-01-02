import MobileDownload

import Foundation

extension UxSurveyRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        description = record.getString(3)
        isMandatory = record.getBool(4)
        fromDate = record.getDateOrNil(5) ?? .distantPast
        thruDate = record.getDateOrNil(6)
        cusNidsBlob = record.getString(7)
        isScoreable = record.getBool(8)
        isMandatoryOneTime = record.getBool(9)
        mandatoryThresholdInDays = record.getInt(10)
        isMandatoryWeekly = record.getBool(11)
        isMandatoryBiWeekly = record.getBool(12)
        isMandatoryMonthly = record.getBool(13)
    }
}
