import UIKit

struct Customer3 {
    var name: String
    var hasVisited: Bool
}

protocol CustomerDelegate: AnyObject {
    func didLongPressCustomer(name: String)
}

class ASVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var customers3: [Customer3] = []
    weak var delegate: CustomerDelegate?
  
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCustomers()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ASVC3")
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
                tableView.addGestureRecognizer(longPressRecognizer)
        
        
        
    }
    

    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                let touchPoint = gesture.location(in: tableView)
                if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                    let alert = UIAlertController(title: "Register", message: "Would you like to register this customer?", preferredStyle: .alert)
                    let registerAction = UIAlertAction(title: "Register", style: .default) { [weak self] _ in
                        self?.delegate?.didLongPressCustomer(name: self?.customers3[indexPath.row].name ?? "")
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    alert.addAction(registerAction)
                    alert.addAction(cancelAction)
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    
    
    
    
    func loadCustomers() {
        let defaults = UserDefaults.standard
        if let savedCustomers = defaults.object(forKey: "savedCustomers") as? [[String: Any]] {
            self.customers3 = savedCustomers.map { Customer3(name: $0["name"] as? String ?? "", hasVisited: $0["hasVisited"] as? Bool ?? false) }
        }
    }
    
   
    
    func saveCustomers() {
        let defaults = UserDefaults.standard
        let customerData = self.customers3.map { ["name": $0.name, "hasVisited": $0.hasVisited] }
        defaults.set(customerData, forKey: "savedCustomers")
    }
    
    // MARK: - TableView Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers3.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ASVC3", for: indexPath)
        
        cell.textLabel?.text = customers3[indexPath.row].name
        
        if customers3[indexPath.row].hasVisited {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        customers3[indexPath.row].hasVisited = !customers3[indexPath.row].hasVisited
        saveCustomers()
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            customers3.remove(at: indexPath.row)
            saveCustomers()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    
    @IBAction func addCustomerButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "거래처 등록", message: " ", preferredStyle: .alert)
        alert.addTextField {
            (textField) in
            textField.placeholder = "안전관리자이름"
        }
        alert.addTextField {
            (textField) in
            textField.placeholder = "전화번호"
        }
        alert.addTextField {
            (textField) in
            textField.placeholder = "생년월일"
        }
        
        let addAction = UIAlertAction(title: "등록하기", style: .default) { (_) in
            guard let name = alert.textFields?[0].text else { return }
            let newCustomer = Customer3(name: name, hasVisited: false)
            self.customers3.append(newCustomer)
            self.saveCustomers()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "취소하기", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
