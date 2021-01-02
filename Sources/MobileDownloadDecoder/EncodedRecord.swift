import Foundation
import MoneyAndExchangeRates


/// A downloaded record has a collection of fields separated by \t (in csharp, this is called the FieldScanner.cs)
public final class EncodedRecord {
    let showWarnings = false

    let name: String
    let fields: [String]
    var indexOfNextFieldToRead: Int

    init(name: String, _ fields: [String]) {
        self.name = name
        self.fields = fields
        indexOfNextFieldToRead = 0
    }

    deinit {
        if showWarnings, indexOfNextFieldToRead < fields.count, fields.count != 0 {
            print("WARNING \(debuggingIdentifier): Expected to read all \(fields.count) fields rather than the first \(indexOfNextFieldToRead) fields")
        }
    }

    var hasField: Bool { indexOfNextFieldToRead < fields.count }

    func getSafeString() -> String? {
        MobileDownloadDecoderService.decodeSafeMobileString(safeString: getString())
    }

    func getSafeString(_ i: Int) -> String? {
        MobileDownloadDecoderService.decodeSafeMobileString(safeString: getString(i))
    }

    func getString() -> String {
        return getString(indexOfNextFieldToRead)
    }

    func skipOneField() {
        _ = getString() // indexOfNextFieldToRead += 1 // this won't do the debugging tests in getString()
    }

    func skip(numberOfFields: Int) {
        for _ in 0 ..< numberOfFields {
            _ = getString()
        }
        // indexOfNextFieldToRead += numberOfFields // this won't do the debugging tests in getString()
    }

    var debuggingIdentifier: String {
        var firstThreeFields: [String] = []
        for i in 0 ..< 3 {
            if i < fields.count {
                firstThreeFields.append(fields[i])
            }
        }
        let first = firstThreeFields.joined(separator: "\\t") + " ..."
        let msg = "decoding MobileDownload record \(name) - \"\(first)\""
        return msg
    }

    func getString(_ i: Int) -> String {
        if fields.count == 0 {
            return ""
        }

        // this is debugging code - I want to be sure we don't skip any fields or double-up on a field
        if i != indexOfNextFieldToRead {
            print("ERROR   \(debuggingIdentifier): Expected to read field[\(indexOfNextFieldToRead)] rather than field[\(i)]")
        }
        if showWarnings, i == fields.count { // only show this message once
            print("WARNING \(debuggingIdentifier): reading field[\(i)] which is after the number of fields: \(fields.count)")
        }

        let value = i < fields.count ? fields[i] : ""
        indexOfNextFieldToRead = i + 1

        return value
    }

    func getIntOrNil(_ i: Int) -> Int? {
        let value = getString(i)
        if value.isEmpty { return nil }
        let intValue = Int(value)
        if intValue == nil {
            print("ERROR    \(debuggingIdentifier): BAD Integer in field \(i): '\(value)'")
            return nil
        }
        return intValue!
    }

    func getInt(_ i: Int) -> Int {
        getIntOrNil(i) ?? 0
    }

    func getCompanyNid(_ i: Int) -> Int {
        getRecNidOrNil(i) ?? 1
    }

    func getWhseNid(_ i: Int) -> Int {
        getRecNidOrNil(i) ?? 1
    }

    func getRecNidOrZero(_ i: Int) -> Int {
        getRecNidOrNil(i) ?? 0
    }

    func getRecNidOrNil(_ i: Int) -> Int? {
        let recNid = getIntOrNil(i)
        if recNid == 0 {
            return nil
        }
        return recNid
    }

    func getScaledDouble(_ i: Int, scale: Int) -> Double { Double(getInt(i)) / Double(scale) }
    func getScaledDecimal(_ i: Int, scale: Int) -> Decimal { Decimal(Double(getInt(i)) / Double(scale)) }

    func getAmount2OrNil(_ i: Int) -> MoneyWithoutCurrency? { getAmountOrNil(i, numberOfDecimals: 2) }
    func getAmount4OrNil(_ i: Int) -> MoneyWithoutCurrency? { getAmountOrNil(i, numberOfDecimals: 4) }
    func getAmount2(_ i: Int) -> MoneyWithoutCurrency { getAmountOrNil(i, numberOfDecimals: 2) ?? .zero }
    func getAmount4(_ i: Int) -> MoneyWithoutCurrency { getAmountOrNil(i, numberOfDecimals: 4) ?? .zero }

    final func getAmountOrNil(_ i: Int, numberOfDecimals _: Int) -> MoneyWithoutCurrency? {
        guard let int = getIntOrNil(i) else {
            return nil
        }
        return MoneyWithoutCurrency(scaledAmount: int, numberOfDecimals: 2)
    }

    // before c# had nullable types, we had to use a price of (-1) to represent nil vs (0) for "free" (not sure why an empty-string wouldn't do it)
    func getAmount4OrNilIfNegativeOne(_ i: Int) -> MoneyWithoutCurrency? {
        guard let rawPrice = getIntOrNil(i) else {
            return nil
        }

        if rawPrice == -1 {
            return nil
        }

        let amount = MoneyWithoutCurrency(scaledAmount: rawPrice, numberOfDecimals: 4)
        return amount
    }

    func getDateTimeOrNil(_ i: Int) -> Date? {
        let value = getString(i)
        if value.isEmpty { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd:HH:mm:ss" // "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: value)
        return date
    }

    static var dateCache: [String: Date] = [:]

    func getDateOrNil(_ i: Int) -> Date? {
        let value = getString(i)
        if value.isEmpty { return nil }

        if let cachedDate = Self.dateCache[value] {
            return cachedDate
        }

        guard let yyyyMMdd = Int(value) else {
            return nil
        }

        var components = DateComponents()
        components.year = yyyyMMdd / 10000
        components.month = (yyyyMMdd / 100) % 100
        components.day = yyyyMMdd % 100

        let date = Calendar.current.date(from: components)

        // let date = Date.yyyyMMdd.date(from: value)
        Self.dateCache[value] = date
        return date
    }

    func getBool(_ i: Int) -> Bool { getString(i) == "1" }

    func getCompanyNid() -> Int {
        getRecNidOrNil() ?? 1
    }

    func getWhseNid() -> Int {
        getRecNidOrNil() ?? 1
    }

    func getInt() -> Int {
        let value = getString()
        if value.isEmpty { return 0 }
        let intValue = Int(value)
        if intValue == nil {
            print("ERROR    \(debuggingIdentifier): BAD Integer in field \(indexOfNextFieldToRead - 1): '\(value)'")
            return 0
        }
        return intValue!
    }

    func getRecNidOrZero() -> Int {
        getRecNidOrNil() ?? 0
    }

    func getRecNidOrNil() -> Int? {
        let value = getString()
        if value.isEmpty { return nil }
        let intValue = Int(value)
        if intValue == nil {
            print("ERROR    \(debuggingIdentifier): BAD Integer in field \(indexOfNextFieldToRead - 1): '\(value)'")
            return nil
        }
        return intValue!
    }

    func getAmount2() -> MoneyWithoutCurrency { MoneyWithoutCurrency(scaledAmount: getInt(), numberOfDecimals: 2) }
    func getAmount4() -> MoneyWithoutCurrency { MoneyWithoutCurrency(scaledAmount: getInt(), numberOfDecimals: 4) }
    func getBool() -> Bool { getString() == "1" }

    func getDouble() -> Double {
        let value = getString()
        if value.isEmpty { return 0.0 }

        let formatter = NumberFormatter() // https://stackoverflow.com/questions/24031621/swift-how-to-convert-string-to-double
        // let usLocale = Locale(identifier: "en_US")
        formatter.locale = nil // Locale.current // USA: Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        let number = formatter.number(from: value)
        if number == nil { return 0.0 }
        let double = Double(truncating: number!)
        return double
    }

    func getDoubleOrNil(_ i: Int) -> Double? {
        let string = getString(i)
        if string.isEmpty { return nil }
        return Double(string)
    }

    func getDateOrNil() -> Date? {
        let string = getString()
        if string.isEmpty { return nil }
        return Date.fromyyyyMMdd(string)
    }
}
