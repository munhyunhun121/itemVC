import UIKit

class gonggongViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
 
    
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var countCHLAbel: UILabel!
    @IBOutlet weak var countASLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var registerButton: UIButton!
   
    
    struct Customer {
        let name: String
        let phoneNumber: String
        let birthdate: String
        let checkMonth: String
    }
    
    
    var customers = [Customer]()
    
    
    //viewDidLoad 시작점
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
  
        
        // 앱 시작 시 UserDefaults에서 데이터 불러오기
        if let savedCustomers = UserDefaults.standard.array(forKey: "customersKey") as? [[String: String]] {
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
         // 첫 화면에 로드되는 카운터 라벨 함수다 여기서 바뀌면 들어가자마자 바뀌네 //
        // viewDid가 들어가자마자 설정이 호출되면서 보이는거가 맞다.//
        updateCountLabel()
        
        updateASLabel()
        updateCHLabel()
        
        
        // viewDidLoad () 함수 END
        
        
    }
          // ADD 버튼을 누르면 showRegisterAlert()가 호출된다
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        showRegisterAlert()
        
    }
    
          // back 버튼을 누르면 백텝피드가 호출되고, 업데이트 라벨12도 호출된다.)
              //업데이트12 라벨은 노티피케이션으로 커스터머 카운트를
            //다른뷰 컨트롤러에 전달한다
    @IBAction func back(_ sender: Any) {
        backButtonTapped()  // 129번에 있는 함수가 실행된다. back
        updateCountLabel2()  // 노티피케이션 함수가 실행된다 83번
    }
    
    
    // 편집 모드로 들어간다. 편집모드로 들어가고 편집이 완료되면
    // savecustomers defaults() 함수가 호출되어 저장된다.
    @IBAction func editButtonTapped(_ sender: UIButton) {
        tableView.setEditing(!tableView.isEditing, animated: true) // 편집 모드 토글
        saveCustomersToUserDefaults()
    }
    
 
    
    
    
    // 노티피케이션으로 커스터머 카운터를 다른 뷰컨트롤러로 보내서 업데이트 하는//
    // viewDidLoad에 첫화면이 호출될때 (비짓 히스토리 눌럿을떄) 호출되게 설정됨 //
    func updateCountLabel2() {
        NotificationCenter.default.post(name: Notification.Name("CustomerCountUpdated"), object: customers.count)
    }
    
     // 테이블뷰 편집 모드다.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
         //조건문이다. 사용자가 테이블 셀을 삭제하려할때 실행됨 삭제를 누를경우 해당 조건문 코드실행//
        if editingStyle == .delete {
            // 삭제할 데이터와 셀 인덱스를 구함
             // 커스터머 배열에서 셀과 연관된 데이터를 가져옴
            _ = customers[indexPath.row]
              //삭제할 셀의 인덱스를 변수에 저장함.
            let indexToDelete = indexPath.row // < 인덱스페스로우 선택된 셀의 행 번호 임
            
            // 데이터 배열에서 삭제
            customers.remove(at: indexToDelete)
            // UserDefaults에 변경된 데이터 저장
            saveCustomersToUserDefaults()
            
            // 테이블 뷰에서도 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
      // 배열이 올라가면 배열을 따오는 함수다.  커스터머에 있는 count 함수
    func updateCountLabel() {
        countLabel.text = "116C 거래처 개수: \(customers.count)"
    }
    
    
     //. AS 라밸 함수다. // 커스터머에서 컨테인으로 as라는 단어가 있으면
     // as 라벨 텍스트 카운트가 올라가는 함수다.
    func updateASLabel() {
        let numberOfAS = customers.filter { $0.name.contains("as") }.count
        countASLabel.text = " AS 개수 : \(numberOfAS)"
    }
    //.  점검 CH 라밸 함수다. // 커스터머에서 컨테인으로 점검 단어가 있으면
    // 점검 CH 라벨 텍스트 카운트가 올라가는 함수다.
    func updateCHLabel() {
        let numberOfAS2 = customers.filter { $0.name.contains("점검") }.count
        countCHLAbel.text = " 점검 개수 : \(numberOfAS2)"
    }
    
    
     //back버튼 함수다  68번 액션 버튼 함수에서 실행되고 있다.
     
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
        // 현재 뷰 컨트롤러를 dismiss하여 이전 뷰 컨트롤러로 돌아감
       	
    }
    
     //세이브 커스터머 저장 함수다
    func saveCustomersToUserDefaults() {
        
           //2차원의 배열로 구성되었고 스트링 스트링 형테
          // 딕셔너리 타입을 원소로 갖은 배열임, 스티링타입의 키와 스트링타입의 값
        var serializedCustomers = [[String: String]]()
        
       // for customer in customers: customers 배열을 순회하며 각각의 customer를 가져옵니다. customer는 Customer 타입의 객체입니다.
        for customer in customers {
            //let serializedCustomer: [String: String] = ...: serializedCustomer는 [String: String] 타입의 빈 딕셔너리입니다. 이 딕셔너리는 현재 순회 중인 customer 객체의 정보를 저장할 용도로 사용됩니다.
            let serializedCustomer: [String: String] = [
                "name": customer.name, //  키 :  값
                "phoneNumber": customer.phoneNumber,
                "birthdate": customer.birthdate,
                "checkMonth": customer.checkMonth
            ]
            serializedCustomers.append(serializedCustomer)
        }
        UserDefaults.standard.set(serializedCustomers, forKey: "customersKey")
        
      

         // UserDefaults 저장함수
        
            updateCountLabel()
        
            updateCountLabel2()
            updateASLabel()
            updateCHLabel()
    }
    
    // 거래처 정보를 등록하는 알림창 표시
    //함수가 호출될 때마다 독립적인 알림창이 생성되기 때문에, 한 번 사용하고 정보를 등록한 후에 다시 호출하면 새로운 알림창이 표시되어 새로운 거래처 정보를 등록할 수 있습니다.
    func showRegisterAlert() {
        let alert = UIAlertController(title: "거래처 등록", message: nil, preferredStyle: .alert)
        //alert.addTextField < UIAlertController에 텍스트 필드를 추가하는 메서드
        //$0.placeholder = "이름"는 텍스트 필드의 placeholder 속성을 "이름"으로 설정하는 역할을 합니다. 플레이스홀더(placeholder)는 사용자가 텍스트 필드에 아무 입력도 하지 않았을 때 보여지는 안내 메시지로, 일반적으로 입력 양식의 형식을 설명하는 용도로 사용됩니다.
        
        //이 alert.addTextField는 배열 순서대로 쭉 UIAlertController 객체의[객체가 가지고있는 속성 프로퍼티임] textFields에 저장이 됨
        
        alert.addTextField { $0.placeholder = "거래처이름" }
        alert.addTextField { $0.placeholder = "전화번호" }
        alert.addTextField { $0.placeholder = "생년월일" }
        alert.addTextField { $0.placeholder = "점검월" }
   
        
        let saveAction = UIAlertAction(title: "저장", style: .default) { [weak self] _ in
            guard let self = self,
                  // textFields에 저장된 값들을 상수에 대입해주는 코드들이다.
                  
                  let name = alert.textFields?[0].text,
                  let phoneNumber = alert.textFields?[1].text,
                  let birthdate = alert.textFields?[2].text,
                  let checkMonth = alert.textFields?[3].text else {
                return
            }
            //      각각의 textFields에 저장된 값들을 대입해주고 뉴커스터머라는 임시상수변수 에 넣어준다.
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = customers[indexPath.row].name
        return cell
    }
    
    // TableView Delegate 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = customers[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.customers[sourceIndexPath.row]
        customers.remove(at: sourceIndexPath.row)
        customers.insert(movedObject, at: destinationIndexPath.row)
    }
  
    
  
    
}
