import Foundation

public extension JSONDecoder {
    func asyncDecode<T: Decodable>(
        _ type: T.Type,
        from data: Data
    ) async throws -> T {
        try await withUnsafeThrowingContinuation { continuation in
            do {
                try continuation.resume(returning: decode(type, from: data))
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

public extension JSONEncoder {
    func asyncEncode<T: Encodable>(_ value: T) async throws -> Data {
        try await withUnsafeThrowingContinuation { continuation in
            do {
                try continuation.resume(returning: encode(value))
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
