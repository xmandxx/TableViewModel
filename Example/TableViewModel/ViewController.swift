import UIKit
import TableViewModel

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var tableViewModel: TableViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewModel = TableViewModel(tableView: tableView)

        let tableSection = TableSection()
        tableViewModel.addSection(tableSection)

        let row1 = TableRow(nibName: "TestCell1")
        tableSection.addRow(row1)

        let dynamicHeightRow = DynamicHeightRow()
        tableSection.addRow(dynamicHeightRow)

        for var i = 0; i < 40; i++ {
            let index = i
            let row = TableRow(nibName: "TestCell2")
            row.configureCell {
                cell in
                let testCell = cell as! TestCell2
                testCell.button.setTitle("Button \(index)", forState: UIControlState.Normal)
            }
            row.height = Float(50 + (index * 3))
            tableSection.addRow(row)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

