import Foundation

public enum DataState<Data, Error: Swift.Error> {
    case loading, error(Error), data(Data)
}
