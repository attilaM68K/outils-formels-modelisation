import PetriKit
import SmokersLib
import Foundation

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

try! model.saveAsDot(to: URL(fileURLWithPath: "map.dot"), withMarking: [r: 0, p: 1, t: 2, m: 3, s1: 4, s2: 5, s3:6, w1: 7, w2: 8, w3: 9])

public func counter_mark(from marking: MarkingGraph) -> Int {
  // On va parcourir tous les marquage pour les compter
  var mark_todo = [marking] // Liste des marquages a faire
  var mark_visited = [marking] // Liste des marquages deja visites
  var curr_mark = marking // Marquage actuel
  var counter = 1 // Compteur
  while !(mark_todo.isEmpty) { // Jusqu'a on n'a pas de marquage...
    curr_mark = mark_todo[0]
    for (_, successor) in curr_mark.successors { // (pour tous successeurs)
      if !(mark_visited.contains(where: { $0 === successor })) { // (si ca ete pas deja visite)
        mark_todo.append(successor) // (ajouter les elements aux listes)
        mark_visited.append(successor)
        counter = counter + 1 // ... compter les
      }
    }
    mark_todo.remove(at: 0) // (enlever l'element deja analyse)
  }
  return counter
}

public func search_2smokers(from marking: MarkingGraph) -> Bool {
  /* On va parcourir les marquages jusqu'a on a trouve un qui conforme les
  conditions (2 fumeurs en meme temps). Le parcour se fait dans la meme
  maniere que counter_mark, sauf qu'on s'arrete quand on a trouve une marquage
  conformante */
  var mark_todo = [marking]
  var mark_visited = [marking]
  var curr_mark = marking
  var existence = false
  while !(mark_todo.isEmpty) {
    curr_mark = mark_todo[0]
    if ((curr_mark.marking[s1] == 1 && curr_mark.marking[s2] == 1) ||
        (curr_mark.marking[s1] == 1 && curr_mark.marking[s3] == 1) ||
        (curr_mark.marking[s2] == 1 && curr_mark.marking[s3] == 1)) {
          existence = true
          break
        }
    for (_, successor) in curr_mark.successors {
      if !(mark_visited.contains(where: {$0 === successor})) {
        mark_todo.append(successor)
        mark_visited.append(successor)
      }
    }
    mark_todo.remove(at: 0)
  }
  return existence
}

public func search_2ingredients(from marking: MarkingGraph) -> Bool {
  /* On va parcourir les marquages jusqu'a on a trouve un qui conforme les
  conditions (2 de la meme ingredients en meme temps). Le parcour se fait dans
  la meme maniere que counter_mark, sauf qu'on s'arrete quand on a trouve une
  marquage conformante */
  var mark_todo = [marking]
  var mark_visited = [marking]
  var curr_mark = marking
  var existence = false
  while !(mark_todo.isEmpty) {
    curr_mark = mark_todo[0]
    if ((curr_mark.marking[p] == 2) ||
        (curr_mark.marking[t] == 2) ||
        (curr_mark.marking[m] == 2)) {
          existence = true
          break
        }
    for (_, successor) in curr_mark.successors {
      if !(mark_visited.contains(where: {$0 === successor})) {
        mark_todo.append(successor)
        mark_visited.append(successor)
      }
    }
    mark_todo.remove(at: 0)
  }
  return existence
}

// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]
let transitions = model.transitions
// Create the marking graph (if possible).
if let markingGraph = model.markingGraph(from: initialMarking) {
    // Ex4 - 1
    let mark_number = counter_mark(from: markingGraph) // Stocker le resultat dans un constant
    print("Outils Formels - Exercice 4") // Anoncer l'exercice
    print("1: Il y a ", mark_number, " etats") // Sortir le resultat...
    // Ex4 - 2
    let smoker2_exist = search_2smokers(from: markingGraph) // ...puis faire la meme chose pour les autres parties
    print("2: Est-il possible que 2 fumeur fume en meme temps? ", smoker2_exist)
    // Ex4 - 3
    let ingred2_exist = search_2ingredients(from: markingGraph)
    print("3: Est-il possible d'avoir 2 de la meme ingredient en meme temps sur la table? ", ingred2_exist)
}
