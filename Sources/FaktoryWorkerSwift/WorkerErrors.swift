import Foundation

enum FaktoryClientError : Error {
    case streamError
    case protocolError
    case internalStateError
    case communicationError
}

enum ProtocolError : Error {
    case internalError
    case badFormatError
}
