//
//  ViewController.swift
//  MyTODOList
//
//  Created by 이성주 on 2021/10/05.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        
        
    }
    
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self]_ in //[weak self]는 강한 순환참조 방지용
//            debugPrint("\(alert.textFields?[0].text)")
            guard let title = alert.textFields?[0].text else { return }   //등록 버튼을 눌렀을때 입력된값 가져올 수 있음
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData() // tasks 배열에 할 일이 추가 될때마다 tableView 갱신
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력해주세요."
        })
        self.present(alert, animated: true, completion: nil)
        
    }
    

}

extension ViewController: UITableViewDataSource { //UITableViewDataSource Protocol 채택시 아래의 2개 매서드는 꼭 구현!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  // 각 세션에 표시할 행의 갯수
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {  // 특정세션의 N번째 row를 그리는데 필요한 cell return
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // queue를 사용해서 cell을 재사용하는 이유 : 메모리 Save
        let task = self.tasks[indexPath.row]    // 0부터 tasks 배열의 갯수
        cell.textLabel?.text = task.title
        return cell
        
    }
    
    
    
}
