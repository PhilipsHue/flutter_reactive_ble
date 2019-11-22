enum ConnectionFailure: Int {

    case unknown
    case failedToConnect
}

enum ClearGattCacheFailure: Int {

    case operationNotSupported = 1
}

enum CharacteristicValueUpdateFailure: Int {

    case unknown
}

enum WriteCharacteristicFailure: Int {

    case unknown
}

enum MaximumWriteValueLengthRetrieval: Int {

    case unknown
}

enum RequestConnectionPriorityFailure: Int {
    
    case operationNotSupported = 1
}
