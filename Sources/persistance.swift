//
//  persistance.swift
//  clash
//
//  Created by Oliver Cameron on 20/4/2025.
//

import Foundation

func runZshCommand(_ command: String) -> String? {
    let process = Process()
    let pipe = Pipe()

    process.executableURL = URL(fileURLWithPath: "/bin/zsh")
    process.arguments = ["-c", command]
    process.standardOutput = pipe
    process.standardError = pipe  // Optional: also capture stderr

    do {
        try process.run()
    } catch {
        print("❌ Failed to run command: \(error)")
        return nil
    }

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
}

struct Persistance {
    func getPersistance() -> String? {
        return runZshCommand("touch ./clashPersistance.bin && cat ./clashPersistance.bom")
    }
}
