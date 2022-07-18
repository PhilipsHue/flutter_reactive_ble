import CoreBluetooth


final class PeripheralManagerDelegate: NSObject, CBPeripheralManagerDelegate {
    
    typealias CharacteristicSubscribedByCentralHandler = (CBCentral, CBCharacteristic) -> Void

    private let onCharacteristicSubscribedByCentral: CharacteristicSubscribedByCentralHandler

    init(
        onCharacteristicSubscribedByCentral: @escaping CharacteristicSubscribedByCentralHandler
    ) {
        self.onCharacteristicSubscribedByCentral = onCharacteristicSubscribedByCentral
    }

    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("POWERED ON")
            //peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
        } else if peripheral.state == .poweredOff {
            print("POWERED OFF")
            //peripheralManager.stopAdvertising()
        }
    }

    // Callback addservice
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?)
    {
        print("addservice")
        if let error = error {
            print("error: \(error)")
            return
        }
        print("service: \(service)")
    }

    // Callback received read request
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest)
    {
        print("received read request")
        //TODO add characteristic from mutabletable
        /*
        if request.characteristic.UUID.isEqual(characteristic.UUID)
        {
            // Set the correspondent characteristic's value
            // to the request
            request.value = characteristic.value

            // Respond to the request
            peripheralManager.respond(to: request, withResult: .success)
        }
        */
        peripheral.respond(to: request, withResult: .success)
    }

    // Callback received write request
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest])
    {
        print("received write request")
        //for request in requests
        //{
            //TODO add characteristic from mutabletable
            /*
            if request.characteristic.UUID.isEqual(characteristic.UUID)
            {
                // Set the request's value
                // to the correspondent characteristic
                characteristic.value = request.value
            }
             */
        //}
        peripheral.respond(to: requests[0], withResult: .success)

        //TODO Add Notify
        //characteristic.value = data
        //peripheralManager.updateValue(data, forCharacteristic: characteristic, onSubscribedCentrals: nil)
    }

    // Callback received subscribe
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic)
    {
        print("peripheralManager: didSubscribeTo")
        onCharacteristicSubscribedByCentral(central, characteristic)
    }

    // Callback received unsubscribe
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic)
    {
        print("peripheralManager: didUnsubscribeFrom)")
    }
}
