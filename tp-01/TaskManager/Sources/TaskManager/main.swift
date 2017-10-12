import TaskManagerLib

let taskManager = createTaskManager()
// Show here an example of sequence that leads to the described problem.
// For instance:
//     let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
//     let m2 = spawn.fire(from: m1!)
//     ...

// extracting places
let taskPool = taskManager.places.first { $0.name == "taskPool" }!
let processPool = taskManager.places.first { $0.name == "processPool" }!
let inProgress = taskManager.places.first { $0.name == "inProgress" }!

// extracting transitions
let create = taskManager.transitions.first { $0.name == "create" }!
let spawn = taskManager.transitions.first { $0.name == "spawn" }!
let success = taskManager.transitions.first { $0.name == "success" }!
let exec = taskManager.transitions.first { $0.name == "exec" }!
let fail = taskManager.transitions.first { $0.name == "fail" }!

print("Original Task Manager:")
// We can have the same process run again, even when the process is still running
let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
print(m1!)
let m2 = spawn.fire(from: m1!)
print(m2!)
let m3 = spawn.fire(from: m2!) // This should not be permitted
print(m3!)
let m4 = exec.fire(from: m3!)
print(m4!)
let m5 = exec.fire(from: m4!) // We have run twice the same process
print(m5!)
let m6 = success.fire(from: m5!) // We are stuck
print(m6!)
// If we try to do another fire with success to take out the other process
// it will fail... we are stuck
// end of original task manager

// start of corrected task manager
let correctTaskManager = createCorrectTaskManager()

// Show here that you corrected the problem.
// For instance:
//     let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
//     let m2 = spawn.fire(from: m1!)
//     ...

// extracting places
let taskPoolC = correctTaskManager.places.first { $0.name == "taskPool"}!
let processPoolC = correctTaskManager.places.first { $0.name == "processPool"}!
let inProgressC = correctTaskManager.places.first { $0.name == "inProgress"}!
let finishTask = correctTaskManager.places.first { $0.name == "finishTask"}!

// extracting transitions
let createC = correctTaskManager.transitions.first { $0.name == "create"}!
let spawnC = correctTaskManager.transitions.first { $0.name == "spawn"}!
let successC = correctTaskManager.transitions.first { $0.name == "success"}!
let execC = correctTaskManager.transitions.first { $0.name == "exec"}!
let failC = correctTaskManager.transitions.first { $0.name == "fail"}!

print("Corrected Task Manager:")
//trying to do more than one spawn before terminating process is not possible anymore
let mc1 = createC.fire(from: [taskPoolC: 0, processPoolC: 0, inProgressC:0, finishTask: 1])
print(mc1!)
let mc2 = spawnC.fire(from: mc1!)
print(mc2!)
let mc3 = spawnC.fire(from: mc2!)
// print(mc3!) /* if this line is uncommented, the appllication is rebuilt */
               /* and run, it will give out an error because mc3 does not */
               /* contain a proper value, so we have prevented the same task */
               /* from running twice */
print(mc2!) // Just to show that the previous step was corrrect
let mc3_5 = execC.fire(from: mc2!) // If we don't make that mistake
print(mc3_5!)
let mc4 = successC.fire(from: mc3_5!)
print(mc4!) // We have finished a cycle
