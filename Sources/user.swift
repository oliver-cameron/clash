//
//  user.swift
//  clash
//
//  Created by Oliver Cameron on 20/4/2025.
//

import Foundation
func getLocalIPv4Address() -> String? {
    var address: String?
    
    var ifaddr: UnsafeMutablePointer<ifaddrs>?
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }
            
            guard let interface = ptr?.pointee else { continue }
            let addrFamily = interface.ifa_addr.pointee.sa_family
            
            if addrFamily == UInt8(AF_INET), // IPv4 only
               let name = String(validatingUTF8: interface.ifa_name),
               name != "lo0" { // ignore loopback (127.0.0.1)
                
                var addr = interface.ifa_addr.pointee
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                
                getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                
                address = String(cString: hostname)
                break
            }
        }
        freeifaddrs(ifaddr)
    }
    
    return address
}
class user: Identifiable {
    var id: UUID
    var name: String
    var ip: [String]
    init(id: UUID, name: String, ip: [String]) {
        self.id = id
        self.name = name
        self.ip = ip
    }
    var setupString: String {
        // add a \ before quotes ("), spaces ( ) and backslashes (\) to escape them (in the name)
        name = name.split(separator: "").map{["\"", " ", "\\"].contains($0) ? "\\" : "" + String($0)}.joined(separator: "")
        return "\(id.uuidString) \(name) \(ip)"
    }
    var fromSetupString: user? {
        let split = setupString.split(separator: " ")
        let name: String = split.dropLast(2).dropFirst().joined(separator: " ")
        let ip: [String] = split.last!.split(separator: ",").map(String.init)
        return user(id: UUID(uuidString: String(split[0]))!, name: name, ip: ip)
    }
}
