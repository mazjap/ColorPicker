import SwiftUI

struct MenuBarContentView: View {
    @EnvironmentObject private var colorManager: ColorManager
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [SortDescriptor(\CDColor.dateAdded, order: .reverse)])
    private var colors: FetchedResults<CDColor>
    @FetchRequest(sortDescriptors: [SortDescriptor(\Palette.name, order: .reverse)])
    private var palettes: FetchedResults<Palette>
    @FetchRequest(sortDescriptors: [SortDescriptor(\ExportFormat.name, order: .reverse)])
    private var formats: FetchedResults<ExportFormat>
    @AppStorage(Constants.recentColorKey) private var mostRecentColor: String = "#FFFFFF"
    @State private var colorPickerSelection = Color.white
    
    private let colorCellSize = 24.0
    private let colorBorderSize = 1.0
    private var colorSampler: NSColorSampler { Self.colorSampler }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Recent")
                    .font(.headline)
                
                GeometryReader { proxy in
                    let columnCount = Int(proxy.size.width / colorCellSize)
                    let rowCount = Int(proxy.size.height / colorCellSize)
                    
                    LazyVGrid(columns: .init(repeating: .init(.fixed(colorCellSize), spacing: 0), count: columnCount)) {
                        ForEach(colors.prefix(rowCount * columnCount), id: \.color.hexString) { color in
                            
                            let nsColor = color.color
                            
                            Color(nsColor)
                                .frame(width: colorCellSize, height: colorCellSize)
                                .border(Color.white, width: colorBorderSize)
                                .onTapGesture {
                                    let pasteboard = NSPasteboard.general
                                    pasteboard.declareTypes([.string], owner: nil)
                                    pasteboard.setString(nsColor.hexString, forType: .string)
                                }
                        }
                    }
                }
                
                Button {
                    colorSampler.show { @MainActor color in
                        guard let color else { return }
                        mostRecentColor = color.hexString
                        do {
                            try colorManager.save(color: color, context: context)
                        } catch {
                            print(error)
                            context.reset()
                        }
                    }
                } label: {
                    Image(systemName: "eyedropper")
                }.keyboardShortcut("t")
                
                Divider()
            }
        }
    }
    
    static let colorSampler = NSColorSampler()
}

struct MenuBarContentView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBarContentView()
    }
}
