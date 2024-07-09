import Foundation

let task = Process()
task.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
task.arguments = ["simctl", "list", "devices", "--json"]

let pipe = Pipe()
task.standardOutput = pipe
try! task.run()

let data = pipe.fileHandleForReading.readDataToEndOfFile()
let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
let devices = json["devices"] as! [String: Any]

let simulators = devices.keys.filter { $0.contains("iOS") }.flatMap { devices[$0] as! [[String: Any]] }
let availableSimulators = simulators.filter { $0["isAvailable"] as! Bool }
let latestSimulator = availableSimulators.max { (a, b) -> Bool in
    let aVersion = a["osVersion"] as! String
    let bVersion = b["osVersion"] as! String
    return aVersion.compare(bVersion, options: .numeric) == .orderedAscending
}

if let latestSimulator = latestSimulator {
    print(latestSimulator["udid"] as! String)
} else {
    print("No available simulators found")
    exit(1)
}
