import PetriKit

public extension PTNet {

    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
        // Write here the implementation of the coverability graph generation.


        let array_transitions = Array(transitions) // Put all transitions in an array for easier testing
        var mark_init = CoverabilityGraph(marking: marking, successors: [:]) // initial marking
        var mark_todo = [mark_init] // Markings to do
        var mark_visited = [mark_init] // Markings already visited
        var curr_mark = mark_init // The marking that is currently tested
        var curr_trans: CoverabilityMarking?
        var mark_next = mark_init // The resultant marking from curr_trans
        var if_end = true // For a single piece of code in the while loop, which should only be executed once

        while !(mark_todo.isEmpty) {
          curr_mark = mark_todo[0] // Test the first element for each iteration
          for transit in self.transitions {
            curr_trans = transit.fireCover(from: curr_mark.marking) // Try the transition
            if (nil != curr_trans) { // If curr_trans is not nill then...
              if (curr_trans! > mark_init.marking) { // If the marking is bigger then...
                for place_check in self.places { // Go through each PTPlace
                  if curr_trans![place_check]! > mark_init.marking[place_check]! { // If there's a bigger place then we replace it with omega
                    curr_trans![place_check] = .omega
                  }
                }
              }
              mark_next = CoverabilityGraph(marking: curr_trans!, successors: [:]) // ...store the resulting marking
              if !(mark_visited.contains(where: { $0.marking == mark_next.marking})) { // if the marking is not visited yet
                curr_mark.successors.updateValue(mark_next, forKey: transit) // add marking as successor
                mark_todo.append(mark_next) // Add marking to the waiting list
                mark_visited.append(mark_next) // Add marking to the list of visited ones
              } else { // Otherwise...
                curr_mark.successors.updateValue(mark_next, forKey: transit) // ...add marking as successor
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


        // Note that CoverabilityMarking implements both `==` and `>` operators, meaning that you
        // may write `M > N` (with M and N instances of CoverabilityMarking) to check whether `M`
        // is a greater marking than `N`.

        // IMPORTANT: Your function MUST return a valid instance of CoverabilityGraph! The optional
        // print debug information you'll write in that function will NOT be taken into account to
        // evaluate your homework.

    }
}

public extension PTTransition {
  public func isFireableCover(from marking: CoverabilityMarking) -> Bool {
      for arc in self.preconditions {
          if marking[arc.place]! < Token.some(arc.tokens) {
              return false
          }
      }

      return true
  }

  public func fireCover(from marking: CoverabilityMarking) -> CoverabilityMarking? {
      guard self.isFireableCover(from: marking) else {
          return nil
      }

      var result = marking
      for arc in self.preconditions {
        switch result[arc.place] {
        case .some(.some(let x)):
          result[arc.place]! = .some(x-arc.tokens)
        default:
          break
        }
      }
      for arc in self.postconditions {
        switch (result[arc.place]){
        case .some(.some(let x)):
          result[arc.place]! = .some(x+arc.tokens)
        default:
          break
        }
      }

      return result
  }
}
