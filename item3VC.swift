//
//  item3VC.swift
//  scoendP
//
//  Created by 문현권 on 2023/07/05.
//

import UIKit

class item3VC: UIViewController,UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource {
 
    
    struct Customer {
        let name: String
        let phoneNumber: String
        let birthdate: String
        let checkMonth: String
    }
    
   
    var customers = [Customer]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var textField2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
     
        tableView.layer.borderWidth = 1.0 // 테두리 두께
        tableView.layer.borderColor = UIColor.yellow.cgColor
        tableView.layer.cornerRadius = 8.0
        
        
        textField2.delegate = self
        
        if let savedCustomers = UserDefaults.standard.array(forKey: "item3Key") as? [[String: String]] {
            print(UserDefaults.standard.dictionaryRepresentation())
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
  
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
      tableView.setEditing(!tableView.isEditing, animated: true) // 편집 모드 토글
     
    }
    
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
    //세이브 커스터머 저장 함수다
    func saveCustomersToUserDefaults() {
      
         //2차원의 배열로 구성되었고 스트링 스트링 형테
        // 딕셔너리 타입을 원소로 갖은 배열임, 스티링타입의 키와 스트링타입의 값
      var serializedCustomers = [[String: String]]()
      
     // for customer in customers: customers 배열을 순회하며 각각의 customer를 가져옵니다. customer는 Customer 타입의 객체입니다.
      for cUstomer in customers {
          //let serializedCustomer: [String: String] = ...: serializedCustomer는 [String: String] 타입의 빈 딕셔너리입니다. 이 딕셔너리는 현재 순회 중인 customer 객체의 정보를 저장할 용도로 사용됩니다.
          let serializedCustomer: [String: String] = [
            
            "name": cUstomer.name,      // name은 키  cUstomer.name 은 값
              "phoneNumber": cUstomer.phoneNumber,
              "birthdate": cUstomer.birthdate,
              "checkMonth": cUstomer.checkMonth
          ]
          serializedCustomers.append(serializedCustomer)
      }
        
      UserDefaults.standard.set(serializedCustomers, forKey: "item3Key")
      


       // UserDefaults 저장함수
      
      
      
     
   
         
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
      showRegisterAlert()
      
    }
   
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
    
    
 //ui텍스트필드 딜레게이트 지정해주고 셀프 지정해주고 함수지정해주고
    //아웃랫 연결해주면 텍스트 리턴 누르면 키보드라인 없어짐 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField2.resignFirstResponder()
        return true
    }
    

}
