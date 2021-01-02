import MobileDownload

/// Orders downloaded for delivery by the driver are "blobbed" (encoded) and sent down in these records

extension DeliveryRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        order = MobileDownloadDecoderService.decodeMobileOrder(blob: record.getString(3))
    }
}
