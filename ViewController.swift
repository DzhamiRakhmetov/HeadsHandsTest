//
//  ViewController.swift
//  HeadsHandsTest
//
//  Created by Dzhami on 02.10.2023.
//

import UIKit

class CreatureViewController: UIViewController {
    private let name: String
    private let attack: UInt
    private let defense: UInt
    private let damageRange: ClosedRange<UInt>
    private var health: Int
    private var roundNumber = 0
    private var isAlive: Bool { health > 0 }
    
    init() {
        self.name = ""
        self.attack = 0
        self.defense = 0
        self.health = 0
        self.damageRange = 0...0
        super.init(nibName: nil, bundle: nil)
    }
    
    init(name: String, attack: UInt, defense: UInt, health: Int, damageRange: ClosedRange<UInt>) {
        self.name = name
        self.health = health
        self.damageRange = damageRange
        self.attack = {
            switch attack {
            case 1...30:
                return attack
            case 0:
                return 0
            case 30...:
                return 30
            default:
                return attack
            }
        }()
        
        self.defense = {
            switch defense {
            case 1...30:
                return defense
            case 0:
                return 0
            case 30...:
                return 30
            default:
                return defense
            }
        }()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - GameLogic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        while player.isAlive && monster.isAlive {
            roundNumber += 1
            print("\n \(roundNumber) Round")
            printCreatureStatus(player: player, monster: monster)
            
            // Игрок атакует монстра
            let playerDamage = player.calucateDamage(defence: monster.defense)
            if playerDamage > 0 {
                print("\(player.name) успешно атакует \(monster.name) и наносит \(playerDamage) урона.")
                monster.takeDamage(playerDamage)
            } else {
                print("\(player.name) не смог попасть по \(monster.name).")
            }
            
            printCreatureStatus(player: player, monster: monster)
            
            if !monster.isAlive {
                print("\(player.name) победил!")
                break
            }
            
            // Монстр атакует игрока
            let monsterDamage = monster.calucateDamage(defence: player.defense)
            if monsterDamage > 0 {
                print("\(monster.name) успешно атакует \(player.name) и наносит \(monsterDamage) урона.")
                player.takeDamage(monsterDamage)
            } else {
                print("\(monster.name) не смог попасть по \(player.name).")
            }
            
            printCreatureStatus(player: player, monster: monster)
            
            if !player.isAlive {
                print("\(monster.name) победил!")
                break
            }
        }
    }
    
    // Вывод начальных значений здоровья
    private func printCreatureStatus(player: CreatureViewController, monster: CreatureViewController) {
        print("\(player.name): Здоровье - \(player.health)")
        print("\(monster.name): Здоровье - \(monster.health)")
    }
    
    private func takeDamage(_ damage: UInt) {
        health -= Int(damage)
        if health < 0 {
            health = 0
        }
    }
    
    private func calucateDamage(defence: UInt) -> UInt {
        guard isAlive else { return 0 }
        let attackModificator = attack - defence + 1
        if attackModificator < 1 {
            let number = Int.random(in: 1...6)
            if number >= 5 {
                return UInt.random(in: damageRange)
            }
        } else {
            for _ in 1...attackModificator {
                let number = Int.random(in: 1...6)
                if number >= 5 {
                    return UInt.random(in: damageRange)
                }
            }
        }
        return 0
    }
}

// MARK: - Player
class Player: CreatureViewController {}

// MARK: - Monster
class Monster: CreatureViewController {}

let player = Player(name: "Bob", attack: 10, defense: 5, health: 50, damageRange: 1...6)
let monster = Monster(name: "Montster", attack: 11, defense: 3, health: 50, damageRange: 1...6)


