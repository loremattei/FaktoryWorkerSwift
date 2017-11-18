import Foundation

// TODO: Do propert error handling
extension String: Error {}

// MARK: Client for Faktory
public final class FaktoryClient : NSObject {
    // Client communication results
    public enum CommResult {
        case notConnected, communicationError, protocolVersionError, commOk
    }
    
    // Client configuration data
    public let configuration : ClientConfiguration
    
    // The version of the Faktory protocol that this client handles
    public let protocolHandledVersion = 2
    
    // Communication streams
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    
    // MARK: Initializers
    init(configuration: ClientConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: Client messages
    // Job PUSH
    public func push(job: FaktoryJob) -> CommResult {
        if (!checkIsOpen()) {
            return .notConnected
        }
        
        // Send push
        let message = MessagePush(job)
        do {
            try writeLine(message.createMessage())
        } catch {
            return .communicationError
        }
        
        // Verify OK
        guard checkOk((try? readLine()) ?? "") else {
            return .communicationError
        }
        
        return .commOk
    }
    
    public func fetch(queues: Array<String>) -> FaktoryJob? {
        // TODO:
        return nil
    }
    
    public func ack(job: FaktoryJob) {
        // TODO:
    }
    
    public func fail(job: FaktoryJob) {
        // TODO:
    }
    
    // MARK: Communication handling
    public func connect() -> CommResult {
        // Open the streams
        if (!openStreams()) {
            return .communicationError
        }
        
        // Do the actual connection sequence
        do {
            // Wait for HI
            let data = try readLine()
            let hiMessage = try MessageHi(data)
            
            // Check protocol version
            if (hiMessage.v > protocolHandledVersion) {
                return .protocolVersionError
            }
            
            // Send HELLO
            let helloMessage = try MessageHello(configuration: configuration, hiMessage: hiMessage)
            try writeLine(helloMessage.createMessage())
            
            // Verify OK
            guard checkOk(try readLine()) else {
                return .communicationError
            }
        } catch {
            return .communicationError
        }

        return .commOk
    }
    
    public func disconnect() -> CommResult {
        if (!checkIsOpen()) {
            return .commOk
        }
        
        inputStream!.close()
        outputStream!.close()
        
        inputStream = nil
        outputStream = nil
        
        return .commOk
    }
    
    // MARK: Private methods
    private func checkOk(_ message: String) -> Bool {
        return (message == "OK")
    }
    
    func readLine() throws -> String {
        // TODO: Somewhere we need to be sure that this is a whole line!
        
        if ((inputStream == nil) || (inputStream!.streamStatus == .closed)) {
            // TODO:
            throw "connection error"
        }
        
        var string : String
        do {
            let data = try readStream(inputStream!)
            string = String(bytes: data, encoding: .utf8)!
            if (!string.starts(with: "+")) {
                // TODO:
                throw "Error"
            }
            
            string.remove(at: string.startIndex)
            
            guard (String(string.suffix(1)) == "\r\n") else {
                // TODO:
                throw "Error"
            }
            
            string = String(string[..<string.index(string.endIndex, offsetBy: -1)])
            
        } catch let err {
            // TODO:
            string = ""
            print("ERROR: \(err)")
        }
        
        return string
    }
    
    func readStream(_ inputStream: InputStream) throws -> [UInt8] {
        var data : [UInt8] = []
        let bufferSize = 1024
        
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        let startTime = DispatchTime.now()
        while (inputStream.hasBytesAvailable) || ((data.count == 0) && ((DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds) < 500000000)) {
            let read = inputStream.read(buffer, maxLength: bufferSize)
            if (read > 0) {
                data.append(contentsOf: Array(UnsafeBufferPointer(start: buffer, count: read)))
            }
        }
        buffer.deallocate(capacity: bufferSize)
        
        return data
    }
    
    func writeLine(_ message: String) throws {
        if ((outputStream == nil) || (outputStream!.streamStatus == .closed)) {
            // TODO:
            throw "connection error"
        }
        
        let data = message.data(using: .ascii)!
        let dataCount = data.count
        _ = data.withUnsafeBytes { (p: UnsafePointer<UInt8>) -> Int in
            return outputStream!.write(p, maxLength: dataCount)
        }
    }
    
    private func openStreams() -> Bool {
        // Setup the streams
        Stream.getStreamsToHost(withName: configuration.serverAddress, port: configuration.port, inputStream: &inputStream, outputStream: &outputStream)
        
        // Verify stream availability
        if (inputStream == nil) {
            return false
        }
        
        if (outputStream == nil) {
            return false
        }
        
        // Unwrap for convenience
        let iStream = inputStream!
        let oStream = outputStream!
        
        // Configure and open
        iStream.schedule(in: .current, forMode: .commonModes)
        oStream.schedule(in: .current, forMode: .commonModes)
        
        oStream.open()
        iStream.open()
        
        return true
    }
    
    private func checkIsOpen() -> Bool {
        return (inputStream?.streamStatus != .closed) && (outputStream?.streamStatus != .closed);
    }
}
