import Foundation
import AppKit.NSColor

struct ColorFormatProcessor {
    let format: ColorFormat
    let color: NSColor
    let name: String?

    func process() -> String {
        func processValue(_ value: ColorFormat.Value) -> String {
            switch value {
            case let .string(string):
                return string
            case let .variable(variable):
                switch variable {
                case .name:
                    return name ?? color.accessibilityName
                case .red:
                    return "\(color.redComponent)"
                case .green:
                    return "\(color.greenComponent)"
                case .blue:
                    return "\(color.blueComponent)"
                case .alpha:
                    return "\(color.alphaComponent)"
                case .hexRed:
                    return String(format: "%02X", Int(color.redComponent * 255))
                case .hexGreen:
                    return String(format: "%02X", Int(color.greenComponent * 255))
                case .hexBlue:
                    return String(format: "%02X", Int(color.blueComponent * 255))
                case .hexAlpha:
                    return String(format: "%02X", Int(color.alphaComponent * 255))
                case .hue:
                    return "\(color.hueComponent)"
                case .saturation:
                    return "\(color.saturationComponent)"
                case .brightness:
                    return "\(color.brightnessComponent)"
                case .cyan:
                    return "\(color.cyanComponent)"
                case .magenta:
                    return "\(color.magentaComponent)"
                case .yellow:
                    return "\(color.yellowComponent)"
                case .black:
                    return "\(color.blackComponent)"
                }
            case let .operation(operation):
                return processOperation(operation)
            case let .number(number):
                return "\(number)"
            }
        }

        func processOperation(_ operation: ColorFormat) -> String {
            guard let function = operation.function else {
                return ""
            }

            switch function {
            case .concat:
                return processValue(operation.x) + (operation.y.map { processValue($0) } ?? "")
            case .round:
                if let number = Double(processValue(operation.x)) {
                    let places = operation.y.map { Int(processValue($0)) ?? 0 } ?? 0
                    return String(format: "%.\(places)f", number)
                }
                return ""
            case .lower:
                return processValue(operation.x).lowercased()
            case .upper:
                return processValue(operation.x).uppercased()
            case .sum:
                if let x = Double(processValue(operation.x)), let y = Double(processValue(operation.y!)) {
                    return String(x + y)
                }
                return ""
            case .mul:
                if let x = Double(processValue(operation.x)), let y = Double(processValue(operation.y!)) {
                    return String(x * y)
                }
                return ""
            case .div:
                if let x = Double(processValue(operation.x)), let y = Double(processValue(operation.y!)) {
                    return String(x / y)
                }
                return ""
            case .strreplace:
                let target = processValue(operation.y!)
                let replacement = processValue(operation.z!)
                return processValue(operation.x).replacingOccurrences(of: target, with: replacement)
            }
        }

        return processOperation(format)
    }
}
