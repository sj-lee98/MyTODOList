//
//  ViewController.swift
//  MyTODOList
//
//  Created by 이성주 on 2021/10/05.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var doneButton: UIBarButtonItem?
    var tasks = [Task]() {
        didSet { // 할일이 추가 될때마다 userDefaults에 할 일 저장
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks() // 저장된 할 일 불러오기
    }
    
    // selector 타입으로 전달할 메서드를 작성할때는 앞에 @objc 붙여줘야함
    @objc func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true)
    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        // 테이블뷰가 비어있음 편집모드로 들어갈 필요가 없으니 tasks 배열이 비어있지 않을때만 편집모드로 전환
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
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
    
    
    // 할 일들이 추가될 때마다 saveTasks 매서드 호출하여 할 일 저장함
    func saveTasks() {// 딕셔너리 형태로 저장
        let data = self.tasks.map { // 배열의 요소를 딕셔너리로 매핑
        [
            "title": $0.title,
            "done": $0.done
        ]
        }
        let userDefaults = UserDefaults.standard    //UserDefaults는 하나의 인스턴스에만 존재
        userDefaults.set(data, forKey: "tasks")
    }
    
    //UserDefaults load
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil}
            guard let done = $0["done"] as? Bool else { return nil }
            return Task(title: title, done: done)
        }
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
        if task.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { // 편집 모드에서 삭제 버튼을 눌렀을때 해당 셀이 어떤 셀인지 알려주는 메서드
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        if self.tasks.isEmpty { //모두 삭제 되면 편집모드에서 나오게 됨
            self.doneButtonTap()
        }
    }
    
    // 편집모드에서 할 일의 순서를 변경하는 기능 구현
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        self.tasks = tasks
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // 어떤 셀이 선택 되었는지 알려줌
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
