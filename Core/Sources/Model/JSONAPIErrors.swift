import Foundation

public struct UnexpectedResponseCode: Error {
    public let got: Int?
    public let expected: Int
    
    public init(
        got: Int?,
        expected: Int
    ) {
        self.got = got
        self.expected = expected
    }
}

public struct NoBody: Error {
    public init() { }
}
