import Combine

@propertyWrapper
public struct Property<Value> {
    public var wrappedValue: any Publisher<Value, Never> { projectedValue }
    public let projectedValue: CurrentValueSubject<Value, Never>
    
    public init(_ value: Value) {
        projectedValue = .init(value)
    }
}
