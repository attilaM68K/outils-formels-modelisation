import PetriKit
import PhilosophersLib
/*
do {
    enum C: CustomStringConvertible {
        case b, v, o

        var description: String {
            switch self {
            case .b: return "b"
            case .v: return "v"
            case .o: return "o"
            }
        }
    }

    func g(binding: PredicateTransition<C>.Binding) -> C {
        switch binding["x"]! {
        case .b: return .v
        case .v: return .b
        case .o: return .o
        }
    }

    let t1 = PredicateTransition<C>(
        preconditions: [
            PredicateArc(place: "p1", label: [.variable("x")]),
        ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]),
        ])

    let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
    guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
        fatalError("Failed to fire.")
    }
    print(m1)
    guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
        fatalError("Failed to fire.")
    }
    print(m2)
}
*/
print()

do {
    print("Ex1 - Philosophes 5, Non Bloquable")
    let philosophers = lockFreePhilosophers(n: 5)
    // let philosophers = lockablePhilosophers(n: 3)
    /*for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)
    }*/
    let phil_mark_graph = philosophers.markingGraph()
    print(philosophers.counter(MarkingGraph: phil_mark_graph!))
    /*for mouving in phil_mark_graph!.makeIterator() {
      print(mouving.marking)
    }*/

    print("Ex2 - Philosophes 5, Bloquable")
    let philosophers2 = lockablePhilosophers(n: 5)
    let phil_mark_graph2 = philosophers2.markingGraph()
    print(philosophers.counter(MarkingGraph: phil_mark_graph2!))
    /*for mouving in phil_mark_graph2!.makeIterator() {
      print(mouving.marking)
    }*/

    print("Ex3 - Exemple d'etat bloque")
    for mouving in phil_mark_graph2!.makeIterator() {
      if(mouving.successors.isEmpty) {
        print(mouving.marking)
        //break
      }
    }
}
