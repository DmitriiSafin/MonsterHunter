//
//  MonstersBrain.swift
//  MonsterHunter
//
//  Created by Дмитрий on 07.02.2023.
//

import UIKit

class MonstersBrain {
    
    static let shared = MonstersBrain()
    
    let defaults = UserDefaults.standard
    
    var monsters: [Monster] {
        get {
            if let data = defaults.value(forKey: "monsters") as? Data {
                return try! PropertyListDecoder().decode([Monster].self, from: data)
            } else {
                return [Monster]()
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: "monsters")
            }
        }
    }
    
    let namesMonsters = ["Grizl", "Serp", "Morder", "Slept", "Hipe", "Crown", "Pitun", "Dino", "Ridon", "Spot"]
    
    func getMonsters() -> [String] {
        var arrayMonsters: [String] = []
        for _ in 1...30 {
            arrayMonsters.append(namesMonsters.randomElement()!)
        }
        return arrayMonsters
    }
    
    func saveMonsters(name: String, level: String) {
        
        let monster = Monster(name: name, level: level)
        monsters.insert(monster, at: 0)
    }
    
    func levelMonster() -> String {
        return "\(Int.random(in: 5...20))"
    }
    
}
