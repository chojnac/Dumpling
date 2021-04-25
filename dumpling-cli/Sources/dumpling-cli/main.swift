//
//  File.swift
//  
//
//  Created by Wojciech Chojnacki on 22/04/2021.
//

import Foundation
import ArgumentParser
import Dumpling

enum OutputFormat: String, ExpressibleByArgument {
    case html
}

struct DumplingCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
         commandName: "dumpling-cli",
         abstract: "Markdown parser"        
       )

    @Option(name: .shortAndLong, help: "The output format.")
    var output: OutputFormat = .html

    @Argument(help: "Input markdown file")
    var filePath: String

    mutating func run() throws {

        let fileURL: URL

        if filePath.hasPrefix("/") {
            fileURL = URL(fileURLWithPath: filePath, isDirectory: false)
        } else {
            let directory = FileManager.default.currentDirectoryPath
            let directoryURL = URL(fileURLWithPath: directory, isDirectory: true)
            fileURL = directoryURL.appendingPathComponent(filePath)
        }

        let string: String

        let data = try Data(contentsOf: fileURL)
        string = String(decoding: data, as: UTF8.self)


        let parser = Markdown()
        let ast = parser.parse(string)

        switch output {
        case .html:
            let result = ast.renderHTML()
            FileHandle.standardOutput.write(result)
            FileHandle.standardOutput.write("\n")
        }
    }
}

DumplingCommand.main()
