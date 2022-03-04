import XCTest
import class Foundation.Bundle

final class CodeNameTests: XCTestCase {
    func testNoChange() throws {
        let input = "The Quick Brown Fox"
        let output = try run(withArguments: ["-o=natural", "-n=natural", input])
        let expectedOutput = input
        XCTAssertEqual(expectedOutput, output)
    }
    
    func testNaturalToCamel() throws {
        let input = "The Quick Brown Fox"
        let output = try run(withArguments: ["-o=natural", "-n=camel", input])
        let expectedOutput = "theQuickBrownFox"
        XCTAssertEqual(expectedOutput, output)
    }
    
    func testNaturalToKebab() throws {
        let input = "The Quick Brown Fox"
        let output = try run(withArguments: ["-o=natural", "-n=kebab", input])
        let expectedOutput = "The-Quick-Brown-Fox"
        XCTAssertEqual(expectedOutput, output)
    }
    
    func testNaturalToSnake() throws {
        let input = "The Quick Brown Fox"
        let output = try run(withArguments: ["-o=natural", "-n=snake", input])
        let expectedOutput = "The_Quick_Brown_Fox"
        XCTAssertEqual(expectedOutput, output)
    }
    
    func testCamelToNatural() throws {
        let input = "TheUPSSpecialPackage"
        let output = try run(withArguments: ["-o=camel", "-n=natural", input])
        let expectedOutput = "The UPS Special Package"
        XCTAssertEqual(expectedOutput, output)
    }
    
    func testSnakeToCamel() throws {
        let input = "the_UPS_special_package"
        let output = try run(withArguments: ["-o=snake", "-n=camel", input])
        let expectedOutput = "theUPSSpecialPackage"
        XCTAssertEqual(expectedOutput, output)
    }
    
    private func run(withArguments arguments: [String]) throws -> String? {
        guard #available(macOS 10.13, *) else {
            throw XCTSkip("Test requires macOS 10.13 or later")
        }
        // Mac Catalyst won't have `Process`, but it is supported for executables.
        #if !targetEnvironment(macCatalyst)
        let versionerBinary = productsDirectory.appendingPathComponent("CodeName")

        let process = Process()
        process.executableURL = versionerBinary

        let pipe = Pipe()
        process.standardOutput = pipe
        process.arguments = arguments

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
        #else
        return nil
        #endif
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
}
