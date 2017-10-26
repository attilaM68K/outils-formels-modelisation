import PetriKit
import SmokersLib

// Instantiate the model.
let model = createModel()

// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
      let p  = model.places.first(where: { $0.name == "p" }),
      let t  = model.places.first(where: { $0.name == "t" }),
      let m  = model.places.first(where: { $0.name == "m" }),
      let w1 = model.places.first(where: { $0.name == "w1" }),
      let s1 = model.places.first(where: { $0.name == "s1" }),
      let w2 = model.places.first(where: { $0.name == "w2" }),
      let s2 = model.places.first(where: { $0.name == "s2" }),
      let w3 = model.places.first(where: { $0.name == "w3" }),
      let s3 = model.places.first(where: { $0.name == "s3" })
else {
    fatalError("invalid model")
}

public func counter_mark(from marking: MarkingGraph) -> Int {
  var mark_todo = [marking]
  var mark_visited = [marking]
  var curr_mark = marking
  var counter = 1
  while !(mark_todo.isEmpty) {
    curr_mark = mark_todo[0]
    for (_, successor) in curr_mark.successors {
      if !(mark_visited.contains(where: { $0 === successor })) {
        mark_todo.append(successor)
        mark_visited.append(successor)
        counter = counter + 1
      }
    }
    mark_todo.remove(at: 0)
  }
  print(mark_visited.count)
  return counter
}

// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]
let transitions = model.transitions
// Create the marking graph (if possible).
if let markingGraph = model.markingGraph(from: initialMarking) {
    //for (_, successor) in markingGraph.successors {
    //  print(successor.marking)
    //}
    let mark_number = counter_mark(from: markingGraph)
    print("Outils Formels - Exercice 4")
    print("Question 1: Il y a ", mark_number, " etats")
}
