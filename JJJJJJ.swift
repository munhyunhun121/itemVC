//
//  JJJJJJ.swift
//  scoendP
//
//  Created by 문현권 on 2023/08/15.
//

//
//  mapVCViewController.swift
//  scoendP
//
//  Created by 문현권 on 2023/08/10.
//

import UIKit

class mapVCViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //각 각 동작하려면 save 아이덴티값이 달라야함, 같이 데이터를 먹는 이유가 뭐지?
    
    
    
    @IBOutlet weak var goodLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var editbutton: UIButton!
    
    //-----------------------Table 나누기-----------------------------//
    
    @IBOutlet weak var goodLabel2: UILabel!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var registerButton2: UIButton!
    @IBOutlet weak var editbutton2: UIButton!
    
    
    
    //------------------구조체 정의------------------//
    
    
    
    struct Customer {
        let name: String
        let phoneNumber: String
        let birthdate: String
        let checkMonth: String
    }
    
    
    var customers = [Customer]()  //TableView 1
    var customers2 = [Customer]() //TableView 2
    
    
    //------------------구조체 정의 끝-----------------//
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.yellow.cgColor
        tableView.layer.cornerRadius = 8.0
        
        //-----------------------나누기-----------------------------//
        
        
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        
        tableView2.layer.borderWidth = 1.0
        tableView2.layer.borderColor = UIColor.yellow.cgColor
        tableView2.layer.cornerRadius = 8.0
        
        
        
        
        
        //-----------------------savedCustomers--------------------//
        
        
        if let savedCustomers = UserDefaults.standard.array(forKey: "ideaKey") as?
            [[String: String]] {
            for savedCustomer in savedCustomers {
                if let name = savedCustomer["name"],
                   let phoneNumber = savedCustomer["phoneNumber"],
                   let birthdate = savedCustomer["birthdate"],
                   let checkMonth = savedCustomer["checkMonth"] {
                    let customer = Customer(name: name, phoneNumber: phoneNumber, birthdate: birthdate, checkMonth: checkMonth)
                    customers.append(customer)
                }
            }
        }
        
        //-----------------------나누기-----위1 아래2----------------------//
        
        if let savedCustomers2 = UserDefaults.standard.array(forKey: "ideaKey2") as? [[String: String]] {
            for savedCustomer in savedCustomers2 {
                if let name = savedCustomer["name"],
                   let phoneNumber = savedCustomer["phoneNumber"],
                   let birthdate = savedCustomer["birthdate"],
                   let checkMonth = savedCustomer["checkMonth"] {
                    let customer = Customer(name: name, phoneNumber: phoneNumber, birthdate: birthdate, checkMonth: checkMonth)
                    customers2.append(customer)
                }
            }
        }
        
    }  //-------------------viewDidLoad END------------------------//
    
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        showRegisterAlert()
    
    }
    //-----------------------나누기-----위1 아래2----------------------//
    
    @IBAction func registerButtonTapped2(_ sender: UIButton) {
        showRegisterAlert2()
        
    }
    
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        tableView.setEditing(!tableView.isEditing, animated: true) // 편집 모드 토글
        saveCustomersToUserDefaults()
    }
    
    //-----------------------나누기-----위1 아래2----------------------//
    
    @IBAction func editButtonTapped2(_ sender: UIButton) {
        tableView2.setEditing(!tableView2.isEditing, animated: true) // 편집 모드 토글
        saveCustomers2ToUserDefaults()
    }
    
    

    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            _ = customers[indexPath.row]
            let indexToDelete = indexPath.row
            customers.remove(at: indexToDelete)
            saveCustomersToUserDefaults()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //-----------------------나누기-----위1 아래2----------------------//
    
    
    func tableView2(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            _ = customers2[indexPath.row]
            let indexToDelete = indexPath.row
            customers2.remove(at: indexToDelete)
            saveCustomers2ToUserDefaults()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    
    func saveCustomersToUserDefaults() {
        var serializedCustomers = [[String: String]]()
        for cUstomer in customers {
            let serializedCustomer: [String: String] = [
                "name": cUstomer.name,
                "phoneNumber": cUstomer.phoneNumber,
                "birthdate": cUstomer.birthdate,
                "checkMonth": cUstomer.checkMonth
            ]
            serializedCustomers.append(serializedCustomer)
        }
        UserDefaults.standard.set(serializedCustomers, forKey: "ideaKey")
    }
    
    //-----------------------Table 나누기 위1 아래2 -----------------------------//
    
    
    func saveCustomers2ToUserDefaults() {
        var serializedCustomers2 = [[String: String]]()
        for customer in customers2 {
            let serializedCustomer1: [String: String] = [
                "name": customer.name,
                "phoneNumber": customer.phoneNumber,
                "birthdate": customer.birthdate,
                "checkMonth": customer.checkMonth
            ]
            serializedCustomers2.append(serializedCustomer1)
        }
        
        UserDefaults.standard.set(serializedCustomers2, forKey: "ideaKey2")
    }
    
    
    
    
    func showRegisterAlert() {
        let alert = UIAlertController(title: "거래처 등록", message: nil, preferredStyle: .alert)
        
        
        alert.addTextField { $0.placeholder = "거래처이름" }
        alert.addTextField { $0.placeholder = "전화번호" }
        alert.addTextField { $0.placeholder = "생년월일" }
        alert.addTextField { $0.placeholder = "점검월" }
        alert.addTextField { $0.placeholder = "그냥그냥 rr" }
        alert.addTextField { $0.placeholder = "그냥그냥 rr2" }
        
        let saveAction = UIAlertAction(title: "저장", style: .default) { [weak self] _ in
            guard let self = self,
                  // textFields에 저장된 값들을 상수에 대입해주는 코드들이다.
                  
                    let name = alert.textFields?[0].text,
                  let phoneNumber = alert.textFields?[1].text,
                  let birthdate = alert.textFields?[2].text,
                  let checkMonth = alert.textFields?[3].text else {
                return
            }
            //      각각의 textFields에 저장된 값들을 대입해주고 뉴커스터머라는 상수에 넣어준다.
            let newCustomer = Customer(name: name, phoneNumber: phoneNumber, birthdate: birthdate, checkMonth: checkMonth)
            
            // customers 변수 배열에 넣어준다.
            self.customers.append(newCustomer)
            
            // saveCustomers 를 호출한다.
            self.saveCustomersToUserDefaults()
            
            // 테이블뷰를 리로드 해준다.
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }

    //-----------------------나누기-----위1 아래2----------------------//
    
    func showRegisterAlert2() {
        let alert = UIAlertController(title: "거래처 등록", message: nil, preferredStyle: .alert)
        
        
        alert.addTextField { $0.placeholder = "거래처이름" }
        alert.addTextField { $0.placeholder = "전화번호" }
        alert.addTextField { $0.placeholder = "생년월일" }
        alert.addTextField { $0.placeholder = "점검월" }
        alert.addTextField { $0.placeholder = "그냥그냥 rr" }
        alert.addTextField { $0.placeholder = "그냥그냥 rr2" }
        
        let saveAction = UIAlertAction(title: "저장", style: .default) { [weak self] _ in
            guard let self = self,
                  // textFields에 저장된 값들을 상수에 대입해주는 코드들이다.
                  
                    let name = alert.textFields?[0].text,
                  let phoneNumber = alert.textFields?[1].text,
                  let birthdate = alert.textFields?[2].text,
                  let checkMonth = alert.textFields?[3].text else {
                return
            }
            //      각각의 textFields에 저장된 값들을 대입해주고 뉴커스터머라는 상수에 넣어준다.
            let newCustomer = Customer(name: name, phoneNumber: phoneNumber, birthdate: birthdate, checkMonth: checkMonth)
            
            // customers 변수 배열에 넣어준다.
            self.customers2.append(newCustomer)
            
            // saveCustomers 를 호출한다.
            self.saveCustomers2ToUserDefaults()
            
            // 테이블뷰를 리로드 해준다.
            self.tableView2.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let customer = customers[indexPath.row]
            if customer.name.contains("as") {
                cell.backgroundColor = UIColor.red
            } else if customer.name.contains("점검") {
                cell.backgroundColor = UIColor.gray
            } else {
                cell.backgroundColor = UIColor.black
            }
        }
        
        
        
    // TableView DataSource 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    func tableView2(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = customers[indexPath.row].name
        return cell
    }
    
    func tableView2(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        cell.textLabel?.text = customers2[indexPath.row].name
        return cell
    }
        
    // TableView Delegate 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = customers[indexPath.row]
        showInfoAlert(customer: customer)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView2(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = customers2[indexPath.row]
        showInfoAlert(customer: customer)
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
        // 거래처 정보를 알림창으로 표시
        func showInfoAlert(customer: Customer) {
            let alert = UIAlertController(title: "거래처 정보", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            
            let infoString = "이름: \(customer.name)\n전화번호: \(customer.phoneNumber)\n생년월일: \(customer.birthdate)\n점검월: \(customer.checkMonth)"
            alert.message = infoString
            
            present(alert, animated: true, completion: nil)
        }
        
        
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView2(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.customers[sourceIndexPath.row]
        customers.remove(at: sourceIndexPath.row)
        customers.insert(movedObject, at: destinationIndexPath.row)
    }
    func tableView2(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.customers2[sourceIndexPath.row]
        customers2.remove(at: sourceIndexPath.row)
        customers2.insert(movedObject, at: destinationIndexPath.row)
    }
        
        
        
    }
    
    
    
    
    
    
    
    

