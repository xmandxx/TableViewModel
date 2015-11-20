import Foundation
import UIKit

public class TableRow {
    private let nibName: String
    private var bundle: NSBundle?
    private var cell: UITableViewCell?
    private var configureClosure: ((cell:UITableViewCell) -> ())?
    private var didSelectCellClosure: (() -> ())?
    private var heightOfCellFromNib: CGFloat?

    public var shouldDeselectAfterSelection: Bool

    public init(nibName: String, inBundle bundle: NSBundle? = nil) {
        self.nibName = nibName
        self.bundle = bundle

        shouldDeselectAfterSelection = true
    }

    public func cellForTableView(tableView: UITableView) -> UITableViewCell? {
        if cell == nil {
            cell = loadCellForTableView(tableView)
        }

        if let unwrappedCell = cell {
            heightOfCellFromNib = unwrappedCell.frame.height

            if let configure = configureClosure {
                configure(cell: unwrappedCell)
            }
        }

        return cell
    }

    internal func cellHeight() -> CGFloat {
        if let height = self.heightOfCellFromNib {
            return height
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
        guard let cell = self.cell else {
            return
        }
        closure(cell: cell)
    }

    public func didSelectCell(closure: () -> ()) {
        didSelectCellClosure = closure
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