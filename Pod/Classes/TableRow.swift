import Foundation
import UIKit

public class TableRow {
    private let nibName: String
    private var bundle: NSBundle?
    internal var cell: UITableViewCell?
    private var configureClosure: ((cell:UITableViewCell) -> ())?
    private var didSelectCellClosure: (() -> ())?
    public var height: Float?
    public var shouldDeselectAfterSelection: Bool

    public init(nibName: String, inBundle bundle: NSBundle? = nil) {
        self.nibName = nibName
        self.bundle = bundle

        shouldDeselectAfterSelection = true
    }

    public func cellForTableView(tableView: UITableView) -> UITableViewCell? {
        if self.cell == nil {
            self.cell = loadCellForTableView(tableView)
        }

        callConfigureCellClosure()

        guard let cell = self.cell else {
            return nil
        }

        if self.height == nil {
            self.height = Float(cell.frame.height)
        }

        return cell
    }

    internal func cellHeight() -> CGFloat {
        if let height = self.height {
            return CGFloat(height)
        }

        return 44
    }

    internal func selected() {
        if let closure = didSelectCellClosure {
            closure()
        }
    }

    public func configureCell(closure: (cell:UITableViewCell) -> ()) {
        configureClosure = closure
        callConfigureCellClosure()
    }

    public func didSelectCell(closure: () -> ()) {
        didSelectCellClosure = closure
    }

    internal func callConfigureCellClosure() {
        guard let closure = self.configureClosure else {
            return
        }

        guard let cell = self.cell else {
            return
        }

        closure(cell: cell)
    }

    private func loadCellForTableView(tableView: UITableView) -> UITableViewCell? {
        let dequeued = tableView.dequeueReusableCellWithIdentifier(nibName)
        if dequeued != nil {
            return dequeued
        } else {
            let nib: UINib = UINib(nibName: nibName, bundle: bundle)
            tableView.registerNib(nib, forCellReuseIdentifier: nibName)
            let cell = tableView.dequeueReusableCellWithIdentifier(nibName)
            return cell
        }
    }
}
