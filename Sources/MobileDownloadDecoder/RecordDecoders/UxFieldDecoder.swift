import MobileDownload

extension UxFieldRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        part1UxFieldNid = record.getRecNidOrZero(3)
        part2UxFieldNid = record.getRecNidOrZero(4)
        part3UxFieldNid = record.getRecNidOrZero(5)
        part4UxFieldNid = record.getRecNidOrZero(6)
        part5UxFieldNid = record.getRecNidOrZero(7)
        part6UxFieldNid = record.getRecNidOrZero(8)
        part7UxFieldNid = record.getRecNidOrZero(9)
        part8UxFieldNid = record.getRecNidOrZero(10)
        part9UxFieldNid = record.getRecNidOrZero(11)
        part10UxFieldNid = record.getRecNidOrZero(12)
        part1IsRepeating = record.getBool(13)
        part2IsRepeating = record.getBool(14)
        part3IsRepeating = record.getBool(15)
        part4IsRepeating = record.getBool(16)
        part5IsRepeating = record.getBool(17)
        part6IsRepeating = record.getBool(18)
        part7IsRepeating = record.getBool(19)
        part8IsRepeating = record.getBool(20)
        part9IsRepeating = record.getBool(21)
        part10IsRepeating = record.getBool(22)
        choice1 = record.getString(23)
        choice2 = record.getString(24)
        choice3 = record.getString(25)
        choice4 = record.getString(26)
        choice5 = record.getString(27)
        choice6 = record.getString(28)
        choice7 = record.getString(29)
        choice8 = record.getString(30)
        choice9 = record.getString(31)
        choice10 = record.getString(32)
        intMinimum = record.getInt(33)
        intMaximum = record.getInt(34)
        moneyMinimum = record.getInt(35)
        moneyMaximum = record.getInt(36)
        recordName = record.getString(37)
        maxTextLength = record.getInt(38)
        digitsBeforeDecimal = record.getInt(39)
        digitsAfterDecimal = record.getInt(40)
        uxFieldType = eUxFieldType(rawValue: record.getInt(41))!
        hostRecordName = record.getString(42)
        surveyQuestionText = record.getString(43)
        singularName = record.getString(44)
        pluralName = record.getString(45)
        parts_SingularName = record.getString(46)
        parts_PluralName = record.getString(47)

        let nRecNids = record.getInt(48)

        for i in 0 ..< nRecNids {
            let recNid = record.getRecNidOrZero(49 + i)
            limitedRecNids.insert(recNid)
        }
    }
}
