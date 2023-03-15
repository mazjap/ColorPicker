import SwiftUI

struct MenuBarContentView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\CDColor.dateAdded, order: .reverse)])
    private var colors: FetchedResults<CDColor>
    @AppStorage(Constants.recentColorKey) private var mostRecentColor: String = "#FFFFFF"
    @State private var colorPickerSelection = Color.white
    @Environment(\.managedObjectContext) private var context
    private let colorCellSize = 24.0
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
                            Color(color.color)
                                .frame(width: colorCellSize, height: colorCellSize)
                        }
                    }
                }
                
                Button {
                    colorSampler.show { color in
                        guard let color else { return }
                        mostRecentColor = color.hexString
                        _ = CDColor(color: color, context: context)
                        do {
                            try context.save()
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
