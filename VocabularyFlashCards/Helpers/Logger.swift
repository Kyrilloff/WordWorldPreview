//
//  Logger.swift
//  VocabularyFlashCards
//
//  Created by Konrad Schmid on 23.04.25.
//

import Foundation

enum LogLevel: String {
    case debug = "🟢 DEBUG"
    case info = "🔵 INFO"
    case warning = "🟠 WARNING"
    case error = "🔴 ERROR"
}

final class Logger: Sendable {
    
    func log(
        _ level: LogLevel,
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(level.rawValue) [\(fileName):\(line)] \(function) → \(message)")
        #endif
    }
    
    func debug(_ message: String,
               file: String = #file,
               function: String = #function,
               line: Int = #line) {
        log(.debug, message, file: file, function: function, line: line)
    }
    
    func info(_ message: String,
              file: String = #file,
              function: String = #function,
              line: Int = #line) {
        log(.info, message, file: file, function: function, line: line)
    }
    
    func warning(_ message: String,
                 file: String = #file,
                 function: String = #function,
                 line: Int = #line) {
        log(.warning, message, file: file, function: function, line: line)
    }
    
    func error(_ message: String,
               file: String = #file,
               function: String = #function,
               line: Int = #line) {
        log(.error, message, file: file, function: function, line: line)
    }
}
