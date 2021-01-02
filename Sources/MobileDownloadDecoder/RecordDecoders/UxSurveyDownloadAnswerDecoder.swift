import MobileDownload

import Foundation

extension UxSurveyDownloadAnswerRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        uxSurveyNid = record.getRecNidOrZero(3)
        cusNid = record.getRecNidOrZero(4)
        uxFieldNid = record.getRecNidOrZero(5)
        uxSubFieldNid = record.getRecNidOrZero(6)
        repeater_index = record.getInt(7)
        multiPart_index = record.getInt(8)
        uxFieldType = UxFieldRecord.eUxFieldType(rawValue: record.getInt(9))!
        intValue = record.getInt(10)
        recNidValue = record.getInt(11)
        decimalValue = record.getScaledDecimal(12, scale: 4)
        textValue = record.getString(13)
        bitValue = record.getBool(14)
        dateTimeValue = record.getDateTimeOrNil(15)
        base64Image = record.getString(16)
        recordName = record.getString(17)
        score = record.getInt(18)
    }
}
