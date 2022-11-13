import Foundation

public enum DataState<Data, Error: Swift.Error> {
    case loading, refreshing, error(Error), data(Data)
}
