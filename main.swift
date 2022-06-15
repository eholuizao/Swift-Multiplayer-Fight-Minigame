/* 
No meu challenge resolvi fazer um minigame bem básico, simulando uma luta entre dois players!

HOW TO PLAY:
No começo do jogo os dois jogadores podem escolher seus nicknames, depois será sorteado um dos players para atacar primero.

A cada rodada, o player vai sofrer um ataque e ele terá a opção de bloquear ou desviar, na rodada seguinte o outro player irá sofrer o ataque e assim por diante.

Bloquear: pode bloquear 1 a 6 de dano dependendo da sorte
Esquivar: Tem uma chance de evitar 100% do dano

Vencerá o player que conseguir zerar a vida do adversário!
*/

import Foundation

// MAIN CODE
let player1 = Player(playerName: "")
let player2 = Player(playerName: "")

var game = GameManager(playerOne: player1, playerTwo: player2)

game.setNickName(ofPlayer: game.playerOne)
game.setNickName(ofPlayer: game.playerTwo)
game.startBattle()


// CLASSE DOS PLAYERS E STRUCT DO GAME MANAGER
class Player {
  var playerName: String
  var healthPoints = 50.0
  let damage = 10.0

  init(playerName: String) {
    self.playerName = playerName
  }

  // Ataca o jogador inimigo e dá a escolha dele se defender ou esquivar
  func attack(otherPlayer enemy: Player) {
    print("\n\(enemy.playerName), você vai sofrer um golpe! \nEscolha:")
    print("[1] - Bloquear")
    print("[2] - Esquivar")

    //Roda enquanto o usuario não escolher uma das opções.
    while true {
      print("Digite sua escolha: ", terminator: "")
      let playerMoveRl = readLine()
      
      if let playerMove = playerMoveRl {
        if playerMove == "1" {
          print(enemy.block(attackFrom: self))
          break
        }
        else if playerMove == "2"{
          print(enemy.dodge(attackFrom: self))
          break
        }
        else {
          print("Escolha inválida! Tente novamente.")
        }
      }
    }
  }

  // Block: Bloqueia uma certa quantidade de dano dependendo do valor aleatorio(de 1 a 6).
  func block (attackFrom enemy: Player) -> String{
    let blockValue = Double(Int.random(in: 1...6))
    let enemyDamage = round(enemy.damage - blockValue)

    self.healthPoints -= enemyDamage
    
    return "\n\(self.playerName) bloqueou e recebeu \(enemyDamage) de dano!"
  }

  // Dodge: O player tem chance de evitar 100% do dano caso tire um valor aleatorio maior que 4
  func dodge (attackFrom enemy: Player) -> String {
    let randomValue = Int.random(in: 1...6)

    if randomValue > 4 {
      return "\n\(self.playerName) evitou o dano!"
    }
    
    self.healthPoints -= enemy.damage
    return "\n\(self.playerName) não conseguiu desviar!"
  }
}

struct GameManager {
  var playerOne: Player
  var playerTwo: Player

  mutating func setNickName(ofPlayer player: Player) {
    //Roda enquanto o usuario não digitar um valor valido para o nome.
    while true {
      print("Digite o nome do player: ", terminator: "")
      let nickNameRl = readLine()
    
      if let nickName = nickNameRl {
        //Se a string for vazia ou só com espaços é um valor inválido
        if nickName.trimmingCharacters(in: .whitespaces) == "" {
          print("Valor inválido! Tente novamente!")
          break 
        } 
        else {
          print("Nome escolhido com sucesso: \(nickName)")
          player.playerName = nickName.uppercased()
          break 
        }
      }
    }
  }
  
  // Checa a vida dos dois players, caso a vida de um dos dois seja menor ou igual a 0, irá retornar true e declarar o vencedor.
  mutating func gameHasWinner() -> Bool {
    if self.playerTwo.healthPoints <= 0 {
        print("\n\(self.playerOne.playerName) É O VENCEDOR!!!")
        return true
    }
    if self.playerOne.healthPoints <= 0 {
      print("\n\(self.playerTwo.playerName) É O VENCEDOR!!!")    
      return true
    }

    return false
  }

  // Mostra o HP dos dois jogadores
  func showPlayersHp() {
     print("\n\(self.playerOne.playerName) HP: \(self.playerOne.healthPoints)")
     print("\(self.playerTwo.playerName) HP: \(self.playerTwo.healthPoints)")
  }

  // Método que contem toda a lógica da luta
  mutating func startBattle() {
    print("\nUm dado sorteará o jogador, par para \(self.playerOne.playerName) e impar para \(self.playerTwo.playerName)!")

    let rollDice = Int.random(in:1...6)

    // Se a variavel rollDice for par, o jogador um ataca primeiro, se não a ordem é invertida.
    if rollDice.isMultiple(of: 2) {
      print("\(self.playerOne.playerName) começa!")
      self.playerOne.attack(otherPlayer: self.playerTwo)
      showPlayersHp()

      //Roda enquanto a vida de nenhum dos jogadores está zerada
      while true {   
        self.playerTwo.attack(otherPlayer: self.playerOne)
        showPlayersHp()

        //Checa se a vida de um dos jogadores é menor que zero e encerra o jogo
        if gameHasWinner() { break }
        
        self.playerOne.attack(otherPlayer: self.playerTwo)      
        showPlayersHp()
        
        if gameHasWinner() { break }
      } 
    }
    else {
      print("\(self.playerTwo.playerName) começa!")
      self.playerTwo.attack(otherPlayer: self.playerOne)
      showPlayersHp()

      //Roda enquanto a vida de nenhum dos jogadores está zerada
      while true {   
        self.playerOne.attack(otherPlayer: self.playerTwo)   
        showPlayersHp()
        
        //Checa se a vida de um dos jogadores é menor que zero
        if gameHasWinner() { break }
        
        self.playerTwo.attack(otherPlayer: self.playerOne)     
        showPlayersHp()
        
        if gameHasWinner() { break }
      } 
    }
  }
}