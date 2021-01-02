import MobileDownload

extension UxSurveyLineRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        uxSurveyNid = record.getRecNidOrZero(3)
        uxFieldNid = record.getRecNidOrZero(4)
        lineNumber = record.getInt(5)
        triggerUxFieldNid = record.getRecNidOrZero(6)
        triggerValue = record.getString(7)
        maxScore = record.getInt(8)
        isBlind = record.getBool(9)
        isRequired = record.getBool(10)
    }
}
