import Network
import Foundation

let host = NWEndpoint.Host("127.0.0.1") // change to the remote IP
let port: NWEndpoint.Port = 12345
let connection = NWConnection(host: host, port: port, using: .tcp)

connection.stateUpdateHandler = { state in
    switch state {
    case .ready:
        print("✅ Connection ready")
        
        let message = "Hello from client"
        connection.send(content: message.data(using: .utf8), completion: .contentProcessed { error in
            if let error = error {
                print("❗️Send error: \(error)")
            } else {
                print("📤 Message sent")
            }
        })
        
        connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, _, _, error in
            if let data = data, let reply = String(data: data, encoding: .utf8) {
                print("📥 Reply: \(reply)")
            } else if let error = error {
                print("❗️Receive error: \(error)")
            }
        }
        
    case .waiting(let error):
        print("⚠️ Waiting to reconnect — possible offline host: \(error)")
        
    case .failed(let error):
        print("❌ Connection failed — host may be offline: \(error)")
        
    default:
        break
    }
}
print(Persistance().getPersistance())

connection.start(queue: .main)
RunLoop.main.run()
