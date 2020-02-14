//
//  Tap.swift
//  Copyright (C) 2020 Nuclear Cyborg Corp
//
//  Created by Andrew Benson on 2/14/20.
//

import Foundation

/// A description of a single file descriptor tap/redirection.
public class Tap: Identifiable {
    public typealias ID = UUID

    /// Unique identifier for this TapProfile.
    public let id: ID

    /// The file descriptor of the output to tap into.  For example, use
    /// STDOUT_FILENO for stdout, and STDERR_FILENO for stderr.
    public let source: Int32

    /// A duplicate of the original destination of the file descriptor to tap.
    /// If BLAH is true, any data received from the tapped descriptor will also
    /// be forwarded to this originalDestination.
    public let originalDestination: Int32

    /// Determines how read data will be processed
    public var processingMode: ProcessingMode {
        didSet {
            reader.alsoOutputTo = processingMode == .tap ? originalDestination : nil
        }
    }

    /// Describes the way(s) data will be delivrered.
    public var dataDeliveryProfile: DataDeliveryProfile

    /// The file descriptor from which to read to receive data from the tapped
    /// file descriptor
    private let dataStream: Int32

    /// The separate thread that runs the read loop.
    private let reader: ReaderThread

    /// A temporary buffer that accumulates characters until we receive a newline
    private var buffer: String = ""

    /// Process incoming data, and distribute it to wherever it goes.
    ///
    /// - Parameters
    ///      - data: The incoming data.
    ///      - dataStream: The dataStream file descriptor from which the data was read.
    private func processData(_ data: Data, _ dataStream: Int32) {
        // Raw delivery
        dataDeliveryProfile.rawReceiver?(data, self)

        // Processed as newline-separated strings
        buffer += String(bytes: data, encoding: .nonLossyASCII) ?? ""
        if let index = buffer.firstIndex(of: "\n") {

            // Grab the single line of output
            let lineOfText = String(buffer.prefix(upTo: index))

            // Remove it from rando
            buffer.removeSubrange(buffer.startIndex ... index)

            // Post the new line of text
            dataDeliveryProfile.stringReceiver?(lineOfText, self)
            dataDeliveryProfile.binding.wrappedValue = lineOfText
        }
    }

    /// Create a new tap.
    ///
    /// - Parameters:
    ///   - outputSource: The output source to be tapped.
    ///   - processingMode: Processing mode, tap or redirect.
    ///   - dataDeliveryProfile: Delivery options for data which has been read
    ///   - id: Unique identifier
    init(_ outputSource: OutputSource,
         processingMode: ProcessingMode = .tap,
         dataDeliveryProfile: DataDeliveryProfile = DataDeliveryProfile(),
         id: ID =  ID()) {

        // Output source to be tapped
        let source = outputSource.fileno

        // Save the current stdout destination
        let originalDestination = dup(source)

        // Make our pipe
        var ourPipe = [Int32].init(repeating: 0, count: 2)
        if pipe(&ourPipe) != 0 {
            fatalError("pipe returned non-zero")
        }

        // Redirect stdout to the pipe
        dup2(ourPipe[1], source)
        close(ourPipe[1])

        self.id = id
        self.source = source
        self.originalDestination = originalDestination
        self.processingMode = processingMode
        self.dataStream = ourPipe[0]
        self.dataDeliveryProfile = dataDeliveryProfile

        let alsoOutput = processingMode == .tap ? originalDestination : nil
        self.reader = ReaderThread(source: dataStream,
                                   alsoOutputTo: alsoOutput)
        reader.dataReceiver = self.processData
    }
}
