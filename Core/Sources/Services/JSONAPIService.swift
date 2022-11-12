import Foundation

public struct JSONResponse<Body: Decodable> {
    public let statusCode: Int?
    public let headers: [AnyHashable: Any]?
    public let body: Body?
}

public struct EmptyBody: Codable {
    
}

extension JSONResponse: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init(statusCode: nil, headers: nil, body: nil)
    }
}

public protocol JSONAPIServicing {
    func request<RequestBody: Encodable, ResponseBody: Decodable>(
        url: URL,
        method: String,
        headers: [String: String]?,
        body: RequestBody?,
        responseBodyType: ResponseBody.Type
    ) async throws -> JSONResponse<ResponseBody>
}

public extension JSONAPIServicing {
    func request<RequestBody: Encodable, ResponseBody: Decodable>(
        url: URL,
        method: String = "GET",
        headers: [String: String]? = nil,
        body: RequestBody? = EmptyBody?.none,
        responseBodyType: ResponseBody.Type = ResponseBody.self
    ) async throws -> JSONResponse<ResponseBody> {
        try await request(
            url: url,
            method: method,
            headers: headers,
            body: body,
            responseBodyType: responseBodyType
        )
    }
}

public final class JSONAPIService: JSONAPIServicing {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    public init(
        session: URLSession = .shared,
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
    }
    
    public func request<RequestBody: Encodable, ResponseBody: Decodable>(
        url: URL,
        method: String,
        headers: [String : String]?,
        body: RequestBody?,
        responseBodyType: ResponseBody.Type
    ) async throws -> JSONResponse<ResponseBody> {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method
        
        if let body {
            request.httpBody = try await encoder.asyncEncode(body)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, !data.isEmpty else {
            return nil
        }
        
        return try await .init(
            statusCode: httpResponse.statusCode,
            headers: httpResponse.allHeaderFields,
            body: decoder.asyncDecode(responseBodyType, from: data)
        )
    }
}
