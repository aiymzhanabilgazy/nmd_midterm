import Foundation

enum Priority: Int {
    case low = 1
    case medium = 2
    case high = 3
}

enum Status {
    case todo
    case inProgress
    case done
}

protocol TaskProtocol {
    var title: String { get }
    var description: String { get }
    var priority: Priority { get }
    var status: Status { get }
}

class Task: TaskProtocol {
    var title: String
    var description: String
    var priority: Priority
    var status: Status
    
    init(title: String, description: String, priority: Priority) {
        self.title = title
        self.description = description
        self.priority = priority
        self.status = .todo
    }
}

class TaskManager {
    private var tasks: [Task] = []
    
    //СRUD Operations
    
    //create a new task 
    func addTask(title: String, description: String, priority: Priority) {
        if title.isEmpty {
            print("The title cannot be empty")
            return
        }
        
        if tasks.contains(where: { $0.title.lowercased() == title.lowercased() }) {
            print("A task with this title already exists")
            return
        }
        
        let task = Task(title: title, description: description, priority: priority)
        tasks.append(task)
        print("Task added")
    }
    
    //display task with full details
    func showAllTasks() {
        if tasks.isEmpty {
            print("No tasks")
            return
        }
        
        for task in tasks {
            print("Title: \(task.title), Description: \(task.description), Priority: \(task.priority), Status: \(task.status)")
        }
    }
    
    //update task by status
    func updateStatus(title: String, newStatus: Status) {
        if let task = tasks.first(where: { $0.title.lowercased() == title.lowercased() }) {
            task.status = newStatus
            print("Status updated")
        } else {
            print("Task not found")
        }
    }
    
    //delete task by title
    func deleteTask(title: String) {
        let countBefore = tasks.count
        tasks.removeAll { $0.title.lowercased() == title.lowercased() }
        
        if tasks.count < countBefore {
            print("Task deleted")
        } else {
            print("Task not found")
        }
    }
    
    //filter(closure)
    func filterTasks(filterRule: (Task) -> Bool) -> [Task] {
        return tasks.filter(filterRule)
    }
    //sort(closure)
    func sortTasks(sortRule: (Task, Task) -> Bool) -> [Task] {
        tasks.sorted(by: sortRule)
    }
}

//main program
func main() {
    let manager = TaskManager()
    
    while true {
        print("""
        --- TASK TRACKER ---
        1. Add task
        2. Show all tasks
        3. Update status
        4. Delete task
        5. Filter by priority
        6. Sort by priority
        7. Exit
        """)
        
        print("Choose option:", terminator: " ")
        guard let input = readLine(), let option = Int(input) else {
            print("Enter number")
            continue
        }
        
        switch option {
        case 1:
            print("Title:", terminator: " ")
            let title = readLine() ?? ""
            
            print("Description:", terminator: " ")
            let desc = readLine() ?? ""
            
            print("Priority (1=Low, 2=Medium, 3=High):", terminator: " ")
            if let p = readLine(), let pv = Int(p), let priority = Priority(rawValue: pv) {
                manager.addTask(title: title, description: desc, priority: priority)
            }
            
        case 2:
            manager.showAllTasks()
            
        case 3:
            print("Task title:", terminator: " ")
            let title = readLine() ?? ""
            
            print("New status (1=Todo, 2=InProgress, 3=Done):", terminator: " ")
            let s = readLine()
            
            let status: Status
            switch s {
            case "1": status = .todo
            case "2": status = .inProgress
            case "3": status = .done
            default:
                print("Invalid status")
                continue
            }
            
            manager.updateStatus(title: title, newStatus: status)
            
        case 4:
            print("Task title to delete:", terminator: " ")
            let title = readLine() ?? ""
            manager.deleteTask(title: title)
            
        case 5:
            print("Priority (1=Low, 2=Medium, 3=High):", terminator: " ")
            if let p = readLine(), let pv = Int(p), let priority = Priority(rawValue: pv) {
                let filtered = manager.filterTasks { $0.priority == priority }
                filtered.forEach { print("Title: \($0.title)") }
            }
            
        case 6:
            let sorted = manager.sortTasks {
                $0.priority.rawValue > $1.priority.rawValue
            }
            sorted.forEach { print("Title: \($0.title)") }
            
        case 7:
            exit(0)
            
        default:
            print("Invalid option.Please choose 1-7!")
        }
    }
}


main()
