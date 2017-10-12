import PetriKit
import Foundation

public func createTaskManager() -> PTNet {
    // Places
    let taskPool    = PTPlace(named: "taskPool")
    let processPool = PTPlace(named: "processPool")
    let inProgress  = PTPlace(named: "inProgress")

    // Transitions
    let create      = PTTransition(
        named          : "create",
        preconditions  : [],
        postconditions : [PTArc(place: taskPool)])
    let spawn       = PTTransition(
        named          : "spawn",
        preconditions  : [],
        postconditions : [PTArc(place: processPool)])
    let success     = PTTransition(
        named          : "success",
        preconditions  : [PTArc(place: taskPool), PTArc(place: inProgress)],
        postconditions : [])
    let exec       = PTTransition(
        named          : "exec",
        preconditions  : [PTArc(place: taskPool), PTArc(place: processPool)],
        postconditions : [PTArc(place: taskPool), PTArc(place: inProgress)])
    let fail        = PTTransition(
        named          : "fail",
        preconditions  : [PTArc(place: inProgress)],
        postconditions : [])

    // P/T-net
    let net = PTNet(
        places: [taskPool, processPool, inProgress],
        transitions: [create, spawn, success, exec, fail])

    try! net.saveAsDot(to: URL(fileURLWithPath: "original.dot"), withMarking: [taskPool: 1, processPool: 2, inProgress: 3])

    return net
}


public func createCorrectTaskManager() -> PTNet {
    // Places
    let taskPool    = PTPlace(named: "taskPool")
    let processPool = PTPlace(named: "processPool")
    let inProgress  = PTPlace(named: "inProgress")
    let finishTask = PTPlace(named: "finishTask") // A new place which indicates whether the task is finished
    // Transitions
    let create      = PTTransition(
        named          : "create",
        preconditions  : [],
        postconditions : [PTArc(place: taskPool)])
    let spawn       = PTTransition(
        named          : "spawn",
        preconditions  : [PTArc(place: finishTask)], // We make spawn depend from the task being finished
        postconditions : [PTArc(place: processPool)])
    let success     = PTTransition(
        named          : "success",
        preconditions  : [PTArc(place: taskPool), PTArc(place: inProgress)],
        postconditions : [PTArc(place: finishTask)]) // We indicated that the process has finished
    let exec       = PTTransition(
        named          : "exec",
        preconditions  : [PTArc(place: taskPool), PTArc(place: processPool)],
        postconditions : [PTArc(place: taskPool), PTArc(place: inProgress)])
    let fail        = PTTransition(
        named          : "fail",
        preconditions  : [PTArc(place: inProgress)],
        postconditions : [PTArc(place: finishTask)]) // The same as with success

    // P/T-net
    let net = PTNet(
        places: [taskPool, processPool, inProgress, finishTask],
      transitions: [create, spawn, success, exec, fail])

    try! net.saveAsDot(to: URL(fileURLWithPath: "modified.dot"), withMarking: [taskPool: 1, processPool: 2, inProgress: 3, finishTask: 4])

    return net
}
