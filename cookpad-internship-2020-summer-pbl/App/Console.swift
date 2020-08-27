//
//  Console.swift
//  cookpad-internship-2020-summer-pbl
//
//  Created by Ren Matsushita on 2020/08/27.
//  Copyright © 2020 Ren Matsushita. All rights reserved.
//

struct Console {
    static func log(_ body: Any? = nil, filepath: String = #file, functionName: String = #function, line: Int = #line) {
        print("Console.log 😆😆😆😆😆😆😆😆\nfilePath: \(filepath)\nfunction: \(functionName)\nline: \(line)\n\(body ?? "nil")")
    }
    
    static func warning(_ body: Any? = nil, filepath: String = #file, functionName: String = #function, line: Int = #line) {
        print("Console.warning 👀👀👀👀👀👀👀\nfilePath: \(filepath)\nfunction: \(functionName)\nline: \(line) \n\(body ?? "nil")")
    }
    
    static func error(_ body: Any? = nil, filepath: String = #file, functionName: String = #function, line: Int = #line) {
        print("Console.error 😢😢😢😢😢😢😢😢\nfilePath: \(filepath)\nfunction: \(functionName)\nline: \(line)\n\(body ?? "nil")")
    }
}
