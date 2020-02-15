import XCTest
@testable import NCCFileDescriptorTap

final class NCCFileDescriptorTapTests: XCTestCase {
    func testOutputRedirect() {
        let manager = NCCFileDescriptorTap()

        var success = false

        var buffer = Data([ 1, 27, 125, 205, 219 ])
        let count = buffer.count
        print("About to send \(count) bytes")

        func receiver(_ data: Data, _ tap: Tap) {
            print("Receiver got some data \(data.count) bytes")
            success = data == buffer
            print("Success? \(success ? "YES" : "no")")
        }

        // Create some FDs for us to use
        var fds = [Int32].init(repeating: 0, count: 2)
        let pipeResult = pipe(&fds)
        XCTAssert(pipeResult == 0, "Pipe failure")

        print("Pipe -- fd[0] (read side) is \(fds[0]), fd[1] is \(fds[1]) (write side)")
        // Tap in
        let tap = Tap(.other(fileno: fds[0]),
                      processingMode: .tap,
                      dataDeliveryProfile: DataDeliveryProfile(rawReceiver: receiver))
        manager.add(tap)

        // end our data
        print("Sending it")
        DispatchQueue.global(qos: .userInteractive).async {
            let res = write(fds[1], UnsafeMutableRawPointer(&buffer), count)
            close(fds[1])
        }
        sleep(3)
        XCTAssert(success, "Redirect test failed")
    }

    static var allTests = [
        ("testOutputRedirect", testOutputRedirect),
    ]
}
