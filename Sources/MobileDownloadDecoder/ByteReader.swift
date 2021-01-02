//
//  ByteReader.swift
//  MobileBench (iOS)
//
//  Created by Michael Rutherford on 1/1/21.
//

import Foundation

internal class ByteReader {
    let inputStream: InputStream
    static let bufferSize = 1024
    var buffer: [UInt8]
    var bufferCount = 0
    var bufferIndex = 0
    var stashedCharacter: UInt8?

    /// - Parameter url: A url referencing an encoed MobileDownload file.
    public convenience init?(url: URL) {
        guard let inputStream = InputStream(url: url) else {
            return nil
        }

        self.init(inputStream: inputStream)
    }

    /// - Parameter string: A CSV string.
    public convenience init(string: String) {
        self.init(data: string.data(using: .utf8)!)
    }

    /// Initializes the parser with data.
    ///
    /// - Parameter data: Data represeting CSV content.
    public convenience init(data: Data) {
        self.init(inputStream: InputStream(data: data))
    }

    init(inputStream: InputStream) {
        if inputStream.streamStatus == .notOpen {
            inputStream.open()
        }

        self.inputStream = inputStream
        self.buffer = [UInt8](repeating: 0, count: Self.bufferSize)

        fillBuffer()
    }

    deinit {
        inputStream.close()
    }

    func stash(chr: UInt8) {
        if stashedCharacter != nil {
            fatalError("Cannot stash but one character")
        }
        stashedCharacter = chr
    }

    /// - returns: The next character and removes it from the stream after it has been returned, or nil if the stream is at the end.
    func getc() -> UInt8? {
        if let chr = stashedCharacter {
            stashedCharacter = nil
            return chr
        }

        if bufferIndex == bufferCount {
            if bufferCount == 0 {
                return nil
            }
            fillBuffer()
            if bufferCount == 0 {
                return nil
            }
        }

        let chr = buffer[bufferIndex]
        bufferIndex += 1
        return chr
    }

    private func fillBuffer() {
        bufferCount = inputStream.read(&buffer, maxLength: Self.bufferSize)
        if bufferCount < 0 {
            bufferCount = 0
        }
        bufferIndex = 0
    }
}
