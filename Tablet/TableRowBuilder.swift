//
//    Copyright (c) 2015 Max Sokolov https://twitter.com/max_sokolov
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

/**
 Responsible for building configurable cells of given type and passing items to them.
 */
public class TableRowBuilder<DataType, CellType: ConfigurableCell where CellType.T == DataType, CellType: UITableViewCell> : TableBaseRowBuilder<DataType, CellType> {
    
    private var heightStrategy: HeightStrategy?
    
    public init(item: DataType) {
        super.init(item: item, id: CellType.reusableIdentifier())
    }
    
    public init(items: [DataType]? = nil) {
        super.init(items: items, id: CellType.reusableIdentifier())
    }
    
    public override func willUpdateDirector(director: TableDirector?) {
        super.willUpdateDirector(director)
        
        heightStrategy = PrototypeHeightStrategy()
        heightStrategy?.tableView = director?.tableView
    }
    
    public override func invoke(action action: ActionType, cell: UITableViewCell?, indexPath: NSIndexPath, itemIndex: Int, userInfo: [NSObject: AnyObject]?) -> AnyObject? {
        
        if case .configure = action {
            (cell as? CellType)?.configure(item(index: itemIndex))
        }
        return super.invoke(action: action, cell: cell, indexPath: indexPath, itemIndex: itemIndex, userInfo: userInfo)
    }
    
    // MARK: - RowHeightCalculatable -
    
    public override func rowHeight(index: Int, indexPath: NSIndexPath) -> CGFloat {
        return heightStrategy?.height(item(index: index), indexPath: indexPath, cell: CellType.self) ?? 0
    }

    public override func estimatedRowHeight(index: Int, indexPath: NSIndexPath) -> CGFloat {
        return CellType.estimatedHeight()
    }
}