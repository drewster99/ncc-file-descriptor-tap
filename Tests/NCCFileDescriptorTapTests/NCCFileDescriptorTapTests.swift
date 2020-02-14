import XCTest
@testable import NCCFileDescriptorTap

final class NCCFileDescriptorTapTests: XCTestCase {
    func testOutputRedirect() {
//        let manager = NCCFileDescriptorTap()
//
//        var success = false
//        var messageToSend = "This is our test message\n"
//        let count = messageToSend.count
//
//        var buffer = [UInt8].init(repeating: 0x00, count: count)
//        var zero: Int = 0
//        var remaining = Range<String.Index>.init(uncheckedBounds: (lower: messageToSend.startIndex, upper: messageToSend.endIndex))
//
//        messageToSend.getBytes(&buffer,
//                               maxLength: count,
//                               usedLength: &zero,
//                               encoding: String.Encoding.utf8,
//                               options: [.allowLossy],
//                               range: 0 ..< count,
//                               remaining: UnsafeMutablePointer(&remaining))
//
//        func receiver(_ text: String, _ tap: Tap) {
//            success = text == messageToSend
//        }
//
//        var fds = [Int32].init(repeating: 0, count: 2)
//        pipe(&fds)
//
//        let tap = Tap(.other(fileno: fds[0]),
//                      processingMode: .tap,
//                      dataDeliveryProfile: DataDeliveryProfile(stringReceiver: receiver))
//        manager.add(tap)
//
//        let res = write(fds[1], UnsafeMutableRawPointer(&buffer), count)
//        XCTAssert(success, "Redirect test failed")
        
    }

    static var allTests = [
        ("testOutputRedirect", testOutputRedirect),
    ]
}
