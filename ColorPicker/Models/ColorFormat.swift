import Foundation

struct ColorFormat: Codable {
    let function: Function?
    let x: Value
    let y: Value?
    let z: Value?
    
    enum Function: String, Codable {
        case concat
        case round
        case lower
        case upper
        case sum
        case mul
        case div
        case strreplace
    }
    
    enum Variable: String, Codable {
        case name
        case red
        case green
        case blue
        case alpha
        case hexRed = "hex[red]"
        case hexGreen = "hex[green]"
        case hexBlue = "hex[blue]"
        case hexAlpha = "hex[alpha]"
        case hue
        case saturation
        case brightness
        case cyan
        case magenta
        case yellow
        case black
    }
    
    indirect
    enum Value: Codable {
        case string(String)
        case variable(Variable)
        case number(Double)
        case operation(ColorFormat)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let string = try? container.decode(String.self) {
                if let variable = Variable(rawValue: string) {
                    self = .variable(variable)
                } else {
                    self = .string(string)
                }
            } else if let double = try? container.decode(Double.self) {
                self = .number(double)
            } else {
                self = .operation(try container.decode(ColorFormat.self))
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            switch self {
            case let .string(stringValue):
                try container.encode(stringValue)
            case let .variable(variable):
                try container.encode(variable.rawValue)
            case let .number(intValue):
                try container.encode(intValue)
            case let .operation(operation):
                try container.encode(operation)
            }
        }
    }
}
