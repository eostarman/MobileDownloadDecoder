import MobileDownload

extension CompanyGroupRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        companyNids = MobileDownloadDecoderService.decodeRecNidSet(blob: record.getString(3))
    }
}
