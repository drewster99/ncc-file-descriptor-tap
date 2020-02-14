import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(NCCFileDescriptorTapTests.allTests),
    ]
}
#endif
