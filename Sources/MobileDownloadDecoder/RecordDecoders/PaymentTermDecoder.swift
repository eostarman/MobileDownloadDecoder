import MobileDownload

import Foundation

extension PaymentTermRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        termDiscountDays = record.getInt(3)
        termDiscountPct = record.getScaledDecimal(4, scale: 2)
        isCharge = record.getBool(5)
        paymentProcessing = ePaymentProcessing(caseName: record.getString(6))
        dayOfMonth = record.getInt(7)
        daysToPay = record.getInt(8)
        creditCalendarNid = record.getRecNidOrNil(9)
        cashOnlyNoChecks = record.getBool(10)
        remitToInfo = record.getSafeString(11)
    }
}
