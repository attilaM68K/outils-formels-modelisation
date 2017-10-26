import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        let array_transitions = Array(transitions) // Put all transitions in an array for easier testing
        var mark_init = MarkingGraph(marking: marking, successors: [:]) // initial marking
        var mark_todo = [mark_init] // Markings to do
        var mark_visited = [mark_init] // Markings already visited
        var curr_mark = mark_init // The marking that is currently tested
        var curr_trans = array_transitions[0].fire(from: curr_mark.marking) // The currently used transition
        var mark_next = mark_init // The resultant marking from curr_trans
        var if_end = true // For a single piece of code in the while loop, which should only be executed once
        while !(mark_todo.isEmpty) {
          curr_mark = mark_todo[0] // Test the first element for each iteration
          for i in 0...(array_transitions.count-1) { // Test all possible transitions
            curr_trans = array_transitions[i].fire(from: curr_mark.marking) // Try the transition
            if (nil != curr_trans) { // If curr_trans is not nill then...
              mark_next = MarkingGraph(marking: curr_trans!, successors: [:]) // ...store the resulting marking
              if !(mark_visited.contains(where: { $0.marking == mark_next.marking})) { // if the marking is not visited yet
                curr_mark.successors.updateValue(mark_next, forKey: array_transitions[i]) // add marking as successor
                mark_todo.append(mark_next) // Add marking to the waiting list
                mark_visited.append(mark_next) // Add marking to the list of visited ones
              } else { // Otherwise...
                curr_mark.successors.updateValue(mark_next, forKey: array_transitions[i]) // ...add marking as successor
              }
            }
          }
          if (if_end) { // Only run this part of the code ONCE
            if_end = false
            mark_init = curr_mark // Modify the mark_init to contain the successors
          }
          mark_todo.remove(at: 0) // all tests finished for curr_mark, remove it from the waiting list
        }
        return mark_init // The initial marking is ideal as return value because
        // every marking found during the execution of the function is visible
        // from here
    }

}
