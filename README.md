# MyTODOList
uiTableView를 활용한 간단한 TODO List

1. UITableView : 데이터를 목록형태로 보여 줄 수 있는 가장 기본적인 UI컴포넌트. 여러개의 셀을 가지고 있고 하나의 열과 여러줄의 행을 지니고 있으며 수직으로만 스크롤 가능.

      테이블 뷰를 구현 할 때, UITableViewDataSourse와 UITableViewDelegate 프로토콜을 채택하여 구현을 진행함.
      
      DataSourse는 데이터를 받아 뷰를 그려주는 역할, Delegate는 TableView의 동작과 외관을 담당.
      
      그래서 UITableViewDataSourse에 정의 되어있는 메서드들을 이용해 TableView에 할 일 목록을 표시하고 삭제 할 수 있도록 구현.
      
      또 순서가 변경되게 구현 함. 할 일 목록에서 할 일을 선택 하였을 때에는 UITableViewDelegate에 정의되어있는 DidSelectRowAt메서드를 이용하여 할 일들이 선택되었을때 체크마크가 표시되게 구현.


2. UIAlertViewController : 알럿창 구성.

      UIAlertViewControllerPresent에서 알럿 띄우도록 구현
      
    
3. UserDefaults : 런타임 환경에서 동작을 하면서 앱이 실행되는 동안 기본 저장소에 접근해 데이터를 기록하고 가져오는 역할을 하는 인터페이스

      UserDefaults를 이용해서 Local에 등록한 할 일을 저장하고 앱을 재실행 했을때 Local에 저장한 할 일들을 불러오는 기능 
