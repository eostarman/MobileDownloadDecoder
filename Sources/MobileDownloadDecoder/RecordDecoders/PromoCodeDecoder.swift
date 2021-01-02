import MobileDownload
import MoneyAndExchangeRates

extension PromoCodeRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)
        promoCustomers = Set(record.getString(3).asRecNids(separatedBy: "c"))
        note = record.getString(4)
        isBuyXGetYFree = record.getBool(5)
        isQualifiedPromo = record.getBool(6)
        conditionDescription = record.getString(7)
        isContractPromo = record.getBool(8)
        triggerBasis = record.getInt(9)
        additionalFeePromo_IgnoreHistoryForReturns = record.getBool(10)
        includeInCalculationsOfSalesTax = record.getBool(11)
        currency = Currency(currencyNid: record.getRecNidOrNil(12)) ?? Currency.USD
        promoTierSeq = record.getInt(13)
        isTieredPromo = record.getBool(14)
    }
}
