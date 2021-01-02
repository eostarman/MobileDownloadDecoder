import MobileDownload

extension WebLinkAudienceRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        webLinkAudience = eWebLinkAudience(rawValue: record.getInt(3))!
    }
}
