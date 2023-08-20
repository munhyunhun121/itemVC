//
//  tableViewController.swift
//  scoendP
//
//  Created by 문현권 on 2023/07/14.
//

import UIKit

class tableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableviewmain: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //몇개?
        return 75
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //무엇?? 반복 10번? ?잉 ?
        //2가지 방법 있음
        //지금 은 1번 방법임- 임의의 셀 만들기
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "tablecelltype1")
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 30, width: 30, height: 30)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .yellow  // 버튼에 빨간색 배경을 설정합니다.
        cell.accessoryView = button
        
        
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    @objc func buttonTapped(_ sender: UIButton) {
         print("Button was tapped.")
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableviewmain.delegate = self
        tableviewmain.dataSource = self
        // 여러개의 행이 모여있는 목록 뷰
        // 정갈하게 보여줄려고.
    
        
        //1. 데이터가 무엇? 전화번호부 목록
        //2. 데이터 몇개? 100개 1000개 10000개
        //3. 옵션 데이터 행 눌렀다!. 클릭
        if let tabBarController = self.tabBarController {
            for (index, viewController) in tabBarController.viewControllers?.enumerated() ?? [].enumerated() {
                print("Tab \(index): \(type(of: viewController))")
            }
        }
        
        
    }
}
