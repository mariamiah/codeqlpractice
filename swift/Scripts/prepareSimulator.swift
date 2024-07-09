import Foundation

guard CommandLine.arguments.count == 2 else {
    print("Usage: prepareSimulator.swift <simulator-udid>")
    exit(1)
}

let simulatorUDID = CommandLine.arguments[1]

let bootTask = Process()
bootTask.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
bootTask.arguments = ["simctl", "boot", simulatorUDID]

let bootPipe = Pipe()
bootTask.standardOutput = bootPipe
try! bootTask.run()
bootTask.waitUntilExit()

let installTask = Process()
installTask.executableURL = URL(fileURLWithPath: "/usr/bin/xcrun")
installTask.arguments = ["simctl", "install", simulatorUDID, "path/to/your/app"]

let installPipe = Pipe()
installTask.standardOutput = installPipe
try! installTask.run()
installTask.waitUntilExit()
