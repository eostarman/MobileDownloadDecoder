//
//  RawReaderForEncodedMobileDownloadUsingC.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 12/30/20.
//
//  Inspired by a CSV parser written by Matthias Hochgatterer on 02/06/2017.

import Foundation

/// The encoded MobileDownload (created by eonetservice) is a flat file containing sections, where each section contains zero or more lines and each line contains one or more fields. Sections are terminated by a formfeed \f; lines are terminated by \n (not \r\n - just \n); and fields are separated from each other by a tab character (\t)
/// The fourth section contains the downloaded records (customers, items, brands, employees, trucks, ...)
/// This code is pretty slow (e.g. 10 seconds for the non-optimized code to open a large Odom mobileDownload in the simulator while the C version does the same work in about 1 second). However, it has the benefit of being all Swift, being understandable and, when optimized it takes 3 seconds to open the same database on the iPod. So, it's slower but acceptably so.
internal class MobileDownloadSectionReader {

    static func getSections(fileUrl: URL, minimumNumberOfSections: Int = 50) -> [[[String]]] {
        guard let reader = TokenReader(ByteReader(url: fileUrl)) else {
            return []
        }

        var sections: [[[String]]] = []
        var lines: [[String]] = []
        var fields: [String] = []

        while let token = reader.getToken() {
            switch token {
            case .EOF:
                break
            case .LineFeed:
                // this ugly test is to remove the empty line at the start of the records section (an empty line ends up as a line with a single empty field)
                if lines.isEmpty && (fields.count == 1 && fields.first!.isEmpty) {
                    // ignore the leading blank line in the records section
                } else {
                    lines.append(fields)
                }
                fields.removeAll()
            case .FormFeed:
                if !fields.isEmpty {
                    lines.append(fields)
                    fields.removeAll()
                }
                sections.append(lines)
                lines = []
            case .Field(let field):
                fields.append(field)
            }
        }

        while sections.count < minimumNumberOfSections {
            sections.append([])
        }

        return sections
    }
}

extension MobileDownloadSectionReader {
    enum EncodedMobileDownloadToken : Equatable {
        case EOF
        case LineFeed
        case FormFeed
        case Field(String)
    }

    internal class TokenReader {
        static let Tab = UTF8Char(9)
        static let LineFeed = UTF8Char(10)
        static let FormFeed = UTF8Char(12)
        static let emptyStringToken = EncodedMobileDownloadToken.Field("")

        private let reader: ByteReader

        private var stashedToken: EncodedMobileDownloadToken?
        private var isEOF = false

        init?(_ reader: ByteReader?) {
            guard let reader = reader else {
                return nil
            }
            self.reader = reader
        }

        func getToken() -> EncodedMobileDownloadToken? {
            if let stash = stashedToken {
                if stash == .EOF {
                    return nil
                }
                stashedToken = nil

                return stash
            }

            var fieldBuffer = [UInt8]()

            while true {
                guard let chr = reader.getc() else {
                    stashedToken = .EOF
                    break
                }

                if chr == Self.Tab {
                    //stashedToken = .Tab
                    break
                } else if chr == Self.LineFeed {
                    stashedToken = .LineFeed
                    break
                } else if chr == Self.FormFeed {
                    if fieldBuffer.count == 0 {
                        return .FormFeed
                    }
                    stashedToken = .FormFeed
                    break
                } else {
                    fieldBuffer.append(chr)
                }
            }

            if fieldBuffer.isEmpty {
                return Self.emptyStringToken
            }

            let data = Data(fieldBuffer)
            guard let string = String(data: data, encoding: .utf8) else {
                return Self.emptyStringToken
            }
            return .Field(string)
        }
    }
}
