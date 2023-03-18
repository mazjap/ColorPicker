import SwiftUI

@main
struct ColorPickerApp: App {
    @AppStorage(Constants.recentColorKey) private var mostRecentColor: String = "#FFFFFF"
    @State private var currentNumber: String = "1"
    private let persistenceController = Persistence.shared
    
    var body: some Scene {
        WindowGroup {
            Text("ContentView not implemented")
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        
        MenuBarExtra {
            MenuBarContentView()
                .cornerRadius(5)
                .frame(maxWidth: 360, maxHeight: 200)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        } label: {
            image(forSystemName: "paintpalette.fill", with: try? NSColor(mostRecentColor))
        }
        .menuBarExtraStyle(.window)
    }
    
    private func image(forSystemName systemName: String, with color: NSColor? = nil) -> Image {
        let configuration = NSImage.SymbolConfiguration(pointSize: 16, weight: .light).applying(.init(paletteColors: [color ?? .white]))
        let image = NSImage(systemSymbolName: systemName, accessibilityDescription: nil)?.withSymbolConfiguration(configuration)
        
        return Image(nsImage: image!)
    }
}
