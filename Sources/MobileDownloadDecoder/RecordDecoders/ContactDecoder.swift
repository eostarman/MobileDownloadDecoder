import MobileDownload

extension ContactRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        cusNid = record.getRecNidOrZero(3)
        var flags = EncodedFlags(flags: record.getString(4))

        ordersFlag = flags.getFlag(0)
        paymentsFlag = flags.getFlag(1)
        decisionMakerFlag = flags.getFlag(2)
        serviceFlag = flags.getFlag(3)
        autoFaxFlag = flags.getFlag(4)
        autoEmailFlag = flags.getFlag(5)
        ownerFlag = flags.getFlag(6)
        buyerFlag = flags.getFlag(7)

        contactTitle = record.getString(5)
        contactNote = record.getString(6)
        phoneNumber = record.getString(7)
        phoneType = eContactPhoneType(rawValue: record.getInt(8))!
        phoneNumber2 = record.getString(9)
        phoneType2 = eContactPhoneType(rawValue: record.getInt(10))!
        email = record.getString(11)
        emailType = eContactEmailType(rawValue: record.getInt(12))!
        sequence = record.getInt(13)
        preferredContactMethod = ePreferredContactMethod(rawValue: record.getInt(14))!
        crmNote = record.getString(15)
    }
}
