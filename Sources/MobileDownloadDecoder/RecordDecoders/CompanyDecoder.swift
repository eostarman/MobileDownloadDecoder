import MobileDownload

extension CompanyRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        jpg = record.getString(3)
        pcx_or_grf = record.getString(4)

        let invoiceHeaderLine1 = record.getString(5)
        let invoiceHeaderLine2 = record.getString(6)
        let invoiceHeaderLine3 = record.getString(7)
        let invoiceHeaderLine4 = record.getString(8)
        let invoiceHeaderLine5 = record.getString(9)
        let invoiceHeaderLine6 = record.getString(10)
        let invoiceHeaderLine7 = record.getString(11)
        let invoiceHeaderLine8 = record.getString(12)
        let invoiceHeaderLine9 = record.getString(13)
        let invoiceHeaderLine10 = record.getString(14)
        invoiceHeader = String(fromLines: invoiceHeaderLine1, invoiceHeaderLine2, invoiceHeaderLine3, invoiceHeaderLine4, invoiceHeaderLine5,
                               invoiceHeaderLine6, invoiceHeaderLine7, invoiceHeaderLine8, invoiceHeaderLine9, invoiceHeaderLine10)
        hhInvoiceFormatOverride = record.getInt(15)
        groupScansheetsByPackage = record.getBool(16)
        dexCommID = record.getString(17)

        receivablesGroup = record.getInt(18)

        distributorDUNSNumber = record.getString(19)

        doNotAutoIncludePastDueARInDeliverStop = record.getBool(20)
        doNotAutoIncludeCreditsInDeliverStop = record.getBool(21)
        autoIncludeCreditsMaxAmount = record.getAmount2OrNil(22)

        accountingCurrencyNid = record.getRecNidOrNil(23)
    }
}
