import PetriKit
import CoverabilityLib

var model = createBoundedModel()
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

let initialMarking: CoverabilityMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]
let graph = model.coverabilityGraph(from: initialMarking)

/*var model2 = createUnboundedModel()
// Retrieve places model.
guard let s0 = model2.places.first(where: { $0.name == "s0" }),
      let s1 = model2.places.first(where: { $0.name == "s1" }),
      let s2 = model2.places.first(where: { $0.name == "s2" }),
      let s3 = model2.places.first(where: { $0.name == "s3" }),
      let s4 = model2.places.first(where: { $0.name == "s4" }),
      let b  = model2.places.first(where: { $0.name == "b" })
else {
    fatalError("invalid model")
}

let initialMarking2: CoverabilityMarking = [s0: 1, s1: 0, s2: 0, s3: 0, s4: 1, b: 0]
let graph2 = model2.coverabilityGraph(from: initialMarking2)
for successor in graph2.successors {
  for successor2 in successor.value.successors {
    print("MAIN")
    print(successor2.value.marking)
    print(graph2.marking)
  }
}
*/


// This file contains the code that will be executed if you run your program from the terminal. You
// don't have to write anything in this file, but you may use it to debug your code. You can create
// instances of the provided models as the following:
//
//     let model          = createBoundedModel()
//     let unboundedModel = createUnboundedModel()
//
// Or you can creates any instance of your own models to test your code.
//
// You **are** encouraged to write tests of your own!
// You may write as many tests as you want here, or even better in `CoverabilityLibTests.swift`.
// Observe how the two existing tests are implemented to write your own.
