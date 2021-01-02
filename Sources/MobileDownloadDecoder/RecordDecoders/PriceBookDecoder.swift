import MobileDownload
import MoneyAndExchangeRates

extension PriceBookRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        currency = Currency(currencyNid: record.getRecNidOrNil(3)) ?? Currency.USD
    }
}
