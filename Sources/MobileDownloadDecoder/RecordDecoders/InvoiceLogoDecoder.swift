import MobileDownload

extension InvoiceLogoRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        jpg = record.getString(3)
        pcx_or_grf = record.getString(4)
    }
}
