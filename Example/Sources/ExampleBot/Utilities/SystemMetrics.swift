//
//  SystemMetrics.swift
//  rig
//
//  Created by Lakhan Lothiyi on 16/10/2024.
//
// im sorry this is sketchy as hell ai slop

import DDBKit
import DDBKitUtilities
import Foundation

#if canImport(Darwin)
	import Darwin
#elseif canImport(Glibc)
	import Glibc
#endif
#if canImport(MachO)
	import MachO
#endif

enum SystemMetrics {
	struct SystemMetricsData {
		let virtualMemoryBytes: Int
		let residentMemoryBytes: Int
		let cpuUsage: Double
	}

	static func getProcessMetrics() -> SystemMetricsData? {
		#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
			// Memory statistics (macOS implementation)
			var taskInfo = mach_task_basic_info()
			var count =
				mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
			let kerr: kern_return_t = withUnsafeMutablePointer(
				to: &taskInfo
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

			// CPU usage
			let cpu = (getCPUUsage(for: getpid()) ?? 0) / 100

			return SystemMetricsData(
				virtualMemoryBytes: virtualMemoryBytes,
				residentMemoryBytes: residentMemoryBytes,
				cpuUsage: cpu
			)
		#elseif os(Linux)
			// Linux implementation
			let pid = getpid()

			// Process memory information from /proc/[pid]/status
			guard let memory = getLinuxProcessMemory(for: pid) else {
				return nil
			}

			// CPU usage
			let cpu = (getLinuxCPUUsage(for: pid) ?? 0)

			return SystemMetricsData(
				virtualMemoryBytes: memory.virtualMemoryBytes,
				residentMemoryBytes: memory.residentMemoryBytes,
				cpuUsage: cpu
			)
		#else
			// Unsupported platform
			return nil
		#endif
	}

	#if os(Linux)
		private static func getLinuxProcessMemory(for pid: Int32) -> (
			virtualMemoryBytes: Int, residentMemoryBytes: Int
		)? {
			let statusPath = "/proc/\(pid)/status"

			guard
				let statusContent = try? String(
					contentsOfFile: statusPath,
					encoding: .utf8
				)
			else {
				return nil
			}

			let lines = statusContent.split(separator: "\n")
			var vmSize: Int?
			var vmRSS: Int?

			for line in lines {
				if line.hasPrefix("VmSize:") {
					let parts = line.split(separator: ":")
					if parts.count > 1 {
						let valueStr = parts[1].trimmingCharacters(in: .whitespaces)
						if let value = extractKilobytes(from: valueStr) {
							vmSize = value * 1024 / 10  // Convert to bytes then divide by 10 to match macOS scale
						}
					}
				} else if line.hasPrefix("VmRSS:") {
					let parts = line.split(separator: ":")
					if parts.count > 1 {
						let valueStr = parts[1].trimmingCharacters(in: .whitespaces)
						if let value = extractKilobytes(from: valueStr) {
							vmRSS = value * 1024 / 10  // Convert to bytes then divide by 10 to match macOS scale
						}
					}
				}
			}

			if let vmSize = vmSize, let vmRSS = vmRSS {
				return (vmSize, vmRSS)
			}

			return nil
		}

		private static func extractKilobytes(from string: String) -> Int? {
			let components = string.split(separator: " ")
			guard components.count >= 1, let value = Int(components[0]) else {
				return nil
			}
			return value
		}

		private static func getLinuxCPUUsage(for pid: Int32) -> Double? {
			// We'll use the same approach as the macOS version for consistency
			let process = Process()
			let pipe = Pipe()

			process.executableURL = URL(fileURLWithPath: "/usr/bin/ps")
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
	#endif

	static func getCPUUsage(for pid: Int32) -> Double? {
		#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
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
		#elseif os(Linux)
			return getLinuxCPUUsage(for: pid)
		#else
			return nil
		#endif
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
