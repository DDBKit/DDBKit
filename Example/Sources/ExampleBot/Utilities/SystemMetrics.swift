//
//  SystemMetrics.swift
//  rig
//
//  Created by Lakhan Lothiyi on 16/10/2024.
//
// im sorry this is sketchy as hell ai slop

import DDBKit
import DDBKitUtilities
import Darwin
import Foundation
import MachO

enum SystemMetrics {
	struct SystemMetricsData {
		let virtualMemoryBytes: Int
		let residentMemoryBytes: Int
		let cpuUsage: Double
	}

	static func getProcessMetrics() -> SystemMetricsData? {
		// Memory statistics
		var taskInfo = mach_task_basic_info()
		var count =
			mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
		let kerr: kern_return_t = withUnsafeMutablePointer(
			to:
				&taskInfo
		) {
			$0.withMemoryRebound(to: integer_t.self, capacity: 1) {
				task_info(
					mach_task_self_,
					task_flavor_t(MACH_TASK_BASIC_INFO),
					$0,
					&count
				)
			}
		}

		guard kerr == KERN_SUCCESS else {
			return nil
		}

		let residentMemoryBytes = Int(taskInfo.resident_size) / 10
		let virtualMemoryBytes = Int(taskInfo.virtual_size) / 10

		guard kerr == KERN_SUCCESS else {
			return nil
		}

		// CPU usage
		let cpu = (getCPUUsage(for: getpid()) ?? 0) / 100

		return SystemMetricsData(
			virtualMemoryBytes: virtualMemoryBytes,
			residentMemoryBytes: residentMemoryBytes,
			cpuUsage: cpu
		)
	}

	static func getCPUUsage(for pid: Int32) -> Double? {
		let process = Process()
		let pipe = Pipe()

		process.executableURL = URL(fileURLWithPath: "/bin/ps")
		process.arguments = ["-p", "\(pid)", "-o", "%cpu"]
		process.standardOutput = pipe

		do {
			try process.run()
			process.waitUntilExit()

			let data = pipe.fileHandleForReading.readDataToEndOfFile()
			if let output = String(data: data, encoding: .utf8) {
				let lines = output.split(separator: "\n")
				if lines.count > 1 {
					let cpuString = lines[1].trimmingCharacters(
						in: .whitespacesAndNewlines
					)
					return Double(cpuString)
				}
			}
		} catch {
			print("Error running ps command: \(error)")
		}

		return nil
	}

	static func swiftVersion() -> String {
		#if swift(>=6.6)
			return "Swift 6.6"
		#elseif swift(>=6.5)
			return "Swift 6.5"
		#elseif swift(>=6.4)
			return "Swift 6.4"
		#elseif swift(>=6.3)
			return "Swift 6.3"
		#elseif swift(>=6.2)
			return "Swift 6.2"
		#elseif swift(>=6.1)
			return "Swift 6.1"
		#elseif swift(>=6.0.1)
			return "Swift 6.0.1"
		#elseif swift(>=6.0)
			return "Swift 6.0"
		#elseif swift(>=5.10)
			return "Swift 5.10"
		#elseif swift(>=5.9)
			return "Swift 5.9"
		#elseif swift(>=5.8)
			return "Swift 5.8"
		#elseif swift(>=5.7)
			return "Swift 5.7"
		#elseif swift(>=5.6)
			return "Swift 5.6"
		#elseif swift(>=5.5)
			return "Swift 5.5"
		#elseif swift(>=5.4)
			return "Swift 5.4"
		#elseif swift(>=5.3)
			return "Swift 5.3"
		#elseif swift(>=5.2)
			return "Swift 5.2"
		#elseif swift(>=5.1)
			return "Swift 5.1"
		#elseif swift(>=5.0)
			return "Swift 5.0"
		#else
			return "Swift version earlier than 5.0"
		#endif
	}
}
