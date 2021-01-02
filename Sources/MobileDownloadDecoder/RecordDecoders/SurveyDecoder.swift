import MobileDownload

import Foundation

// mpr: no longer used (this is the old nevron flow-chart based surveys (replaced by UxSurveys)
extension SurveyRecord {
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
        base64ZippedXmlSurvey = record.getString(8)
        isForPresellersOnly = record.getBool(9)
    }
}
