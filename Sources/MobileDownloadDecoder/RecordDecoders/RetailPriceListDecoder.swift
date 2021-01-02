import MobileDownload
import MoneyAndExchangeRates

extension RetailPriceListRecord {
    convenience init(_ record: EncodedRecord) {
        self.init()

        recNid = record.getRecNidOrZero(0)
        recKey = record.getString(1)
        recName = record.getString(2)

        retailPrices = Self.decodeItemPrices(blob: record.getString(3))
    }

    static func decodeItemPrices(blob: String) -> [Int: MoneyWithoutCurrency] {
        var prices: [Int: MoneyWithoutCurrency] = [:]

        var price: MoneyWithoutCurrency = .zero
        var n = 0

        for chr in blob {
            if let digit = chr.wholeNumberValue {
                n = n * 10 + digit
            } else {
                switch chr {
                case "p":
                    price = MoneyWithoutCurrency(scaledAmount: n, numberOfDecimals: 2)
                case "i":
                    let itemNid = n
                    prices[itemNid] = price
                case "#":
                    break
                default:
                    break
                }
                n = 0
            }
        }

        return prices
    }
}
