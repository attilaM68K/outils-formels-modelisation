extension PredicateNet {

    /// Returns the marking graph of a bounded predicate net.
    public func markingGraph() -> PredicateMarkingNode<T>? {

      var mark_init = PredicateMarkingNode<T>(marking: self.initialMarking!, successors: [:]) // initial marking
      var mark_todo = [mark_init] // Markings to do
      var mark_visited = [mark_init] // Markings already visited
      var curr_mark: PredicateMarkingNode<T> // The marking that is currently tested
      var curr_trans: MarkingType?
      var mark_next = mark_init // The resultant marking from curr_trans
      var bind_map_next: PredicateBindingMap<T>
      var curr_bindings = [PredicateTransition<T>.Binding]()
      var if_end = true // For a single piece of code in the while loop, which should only be executed once

      while !(mark_todo.isEmpty) {
        curr_mark = mark_todo[0] // Test the first element for each iteration
        for transit in self.transitions {
          //print(transit)
          curr_bindings = transit.fireableBingings(from: curr_mark.marking)
          for binding in curr_bindings {
            curr_trans = transit.fire(from: curr_mark.marking, with: binding) // Try the transition
            if (curr_trans != nil) { // If curr_trans is not nill then...
              //print(curr_trans!)
              mark_next = PredicateMarkingNode<T>(marking: curr_trans!, successors: [:]) // ...store the resulting marking
              if (mark_visited.contains(where: { PredicateNet.greater( $0.marking, mark_next.marking) })) {
                print("Unbounded model")
                return nil
              }
              bind_map_next = PredicateBindingMap<T>(dictionaryLiteral: (binding, mark_next))
              curr_mark.successors.updateValue(bind_map_next, forKey: transit) // add marking as successor
              if !(mark_visited.contains(where: { PredicateNet.equals($0.marking, mark_next.marking) })) { // if the marking is not visited yet
                mark_todo.append(mark_next) // Add marking to the waiting list
                mark_visited.append(mark_next) // Add marking to the list of visited ones
                //print(mark_next.marking)
              }
            }
          }
        }
        if (if_end) { // Only run this part of the code ONCE
          if_end = false
          mark_init = curr_mark // Modify the mark_init to contain the successors
        }
        mark_todo.remove(at: 0) // all tests finished for curr_mark, remove it from the waiting list
      }
      return mark_init // Returning initial marking with successors
        // Write your code here ...

        // Note that I created the two static methods `equals(_:_:)` and `greater(_:_:)` to help
        // you compare predicate markings. You can use them as the following:
        //
        //     PredicateNet.equals(someMarking, someOtherMarking)
        //     PredicateNet.greater(someMarking, someOtherMarking)
        //
        // You may use these methods to check if you've already visited a marking, or if the model
        // is unbounded.
    }

    // MARK: Internals

    private static func equals(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }
        for (place, tokens) in lhs {
            guard tokens.count == rhs[place]!.count else { return false }
            for t in tokens {
                guard rhs[place]!.contains(t) else { return false }
            }
        }
        return true
    }

    private static func greater(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }

        var hasGreater = false
        for (place, tokens) in lhs {
            guard tokens.count >= rhs[place]!.count else { return false }
            hasGreater = hasGreater || (tokens.count > rhs[place]!.count)
            for t in rhs[place]! {
                guard tokens.contains(t) else { return false }
            }
        }
        return hasGreater
    }
    public func counter(MarkingGraph: PredicateMarkingNode<T>) -> Int{
      var todo_list = [MarkingGraph]
      var seen_list = [MarkingGraph]
      var element_count = 0
      while !(todo_list.isEmpty) {
        let curr_mark = todo_list[0]
        element_count+=1
        print(curr_mark.marking)
        for successor in curr_mark.successors {
          for state in successor.value {
            if !(seen_list.contains(where: { PredicateNet.equals($0.marking, state.value.marking) })) {
              todo_list.append(state.value)
              seen_list.append(state.value)
            }
          }
        }
        todo_list.remove(at: 0)
      }
      return element_count
    }
}

/// The type of nodes in the marking graph of predicate nets.
public class PredicateMarkingNode<T: Equatable>: Sequence {

    public init(
        marking   : PredicateNet<T>.MarkingType,
        successors: [PredicateTransition<T>: PredicateBindingMap<T>] = [:])
    {
        self.marking    = marking
        self.successors = successors
    }

    public func makeIterator() -> AnyIterator<PredicateMarkingNode> {
        var visited = [self]
        var toVisit = [self]

        return AnyIterator {
            guard let currentNode = toVisit.popLast() else {
                return nil
            }

            var unvisited: [PredicateMarkingNode] = []
            for (_, successorsByBinding) in currentNode.successors {
                for (_, successor) in successorsByBinding {
                    if !visited.contains(where: { $0 === successor }) {
                        unvisited.append(successor)
                    }
                }
            }

            visited.append(contentsOf: unvisited)
            toVisit.append(contentsOf: unvisited)

            return currentNode
        }
    }

    public var count: Int {
        var result = 0
        for _ in self {
            result += 1
        }
        return result
    }

    public let marking: PredicateNet<T>.MarkingType

    /// The successors of this node.
    public var successors: [PredicateTransition<T>: PredicateBindingMap<T>]

}

/// The type of the mapping `(Binding) ->  PredicateMarkingNode`.
///
/// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
///   conform to `Hashable`, and therefore can't use Swift's dictionaries to implement this
///   mapping. Hence we'll wrap this in a tuple list until then.
public struct PredicateBindingMap<T: Equatable>: Collection {

    public typealias Key     = PredicateTransition<T>.Binding
    public typealias Value   = PredicateMarkingNode<T>
    public typealias Element = (key: Key, value: Value)

    public var startIndex: Int {
        return self.storage.startIndex
    }

    public var endIndex: Int {
        return self.storage.endIndex
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public subscript(index: Int) -> Element {
        return self.storage[index]
    }

    public subscript(key: Key) -> Value? {
        get {
            return self.storage.first(where: { $0.0 == key })?.value
        }

        set {
            let index = self.storage.index(where: { $0.0 == key })
            if let value = newValue {
                if index != nil {
                    self.storage[index!] = (key, value)
                } else {
                    self.storage.append((key, value))
                }
            } else if index != nil {
                self.storage.remove(at: index!)
            }
        }
    }

    // MARK: Internals

    private var storage: [(key: Key, value: Value)]

}

extension PredicateBindingMap: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: ([Variable: T], PredicateMarkingNode<T>)...) {
        self.storage = elements
    }

}
