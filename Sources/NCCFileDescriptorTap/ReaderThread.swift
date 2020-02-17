//
//  ReaderThread.swift
//  Copyright (C) 2020 Nuclear Cyborg Corp
//
//  Created by Andrew Benson on 2/13/20.
//

import Foundation

class ReaderThread: Thread {
    /// UNIX file descriptor to read from
    public let source: Int32

    /// File descriptor to copy data to.  Typically this would be the original destination.
    public var alsoOutputTo: Int32?

    /// Callback closure to receive read data
    public var dataReceiver: ((_ data: Data, _ source: Int32) -> Void)?

    /// Checks for cancelation periodically
    private var timer: Timer?

    /// Creates a new thread to process I/O from the descriptor
    ///
    /// - Parameters:
    ///   - source: Input file descriptor to read from.
    ///   - alsoOutputTo: Optional descriptor to write a copy of read data to
    init(source: Int32, alsoOutputTo: Int32?, sourceForThreadNaming: Int32, dataReceiver: ((_ data: Data, _ source: Int32) -> Void)? = nil) {
        self.source = source
        self.alsoOutputTo = alsoOutputTo
        self.dataReceiver = dataReceiver

        super.init()
        
        let name = OutputSource.from(sourceForThreadNaming).description
        self.name = "NCCFileDescriptorTap Reader for \(name)"
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }

    /// Thread activation point
    override func main() {
        // Watch for cancellation
        self.timer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] (_) in
            self?.shutdownIfCancelled()
        })
        RunLoop.current.add(self.timer!, forMode: .default)

        // Cancel now if needed
        shutdownIfCancelled()

        // A 1 KB buffer
        let bufferSize = 1024
        var bytes: [UInt8] = .init(repeating: 0x00, count: bufferSize)

        while true {
            // Read from our source
            let count = read(source, UnsafeMutableRawPointer(&bytes), bufferSize)
            if count == 0 {
                // End of file
                self.cancel()
                shutdownIfCancelled()
                return

            } else if count < 0 {
                // Some kind of error
                let err = String(cString: strerror(errno))
                #if DEBUG
                fatalError("\(String(describing: type(of: self))): \(#function): Read failed: errno=\(errno), \(err)")
                #else
                return
                #endif
            }

            let data = Data(bytes.prefix(count))

            // Notify the data receiver
            dataReceiver?(data, source)
            if let out = alsoOutputTo {
                // Optionally output it to another descriptor
                write(out, UnsafeMutableRawPointer(&bytes), count)
            }
        }
    }

    /// Invalidates the timer and exits execution on this thread if marked as cancelled.
    private func shutdownIfCancelled() {
        if isCancelled {
            timer?.invalidate()
            timer = nil
            Thread.exit()
        }
    }
}
