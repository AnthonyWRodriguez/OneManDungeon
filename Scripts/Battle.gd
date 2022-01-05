extends Node

var statsOpen = false
var sword
var enemyWeapon
var buffsPerBattle = 1
var consecutiveRests = 1
var consecutiveDefends = 1

export(Array, PackedScene) var enemies = []

onready var swordStats = $SwordStats
onready var UI = $UI
onready var MagicButtons = $UI/MagicButtons
onready var enemy = $EnemyPosition/Enemy
onready var playerStats = $PlayerStats

const battleUnits = preload("res://Resources/BattleUnits.tres")

signal updateStats()
signal checkifEnemyAttacks()
signal enemyAttacked()

func enemyDealsDamage():
	UI.hideAllBaseButtons()
	if enemy_is_not_dead():
		UI.populateLowerPanel(enemy.name, enemyWeapon)
		enemy.attack(enemyWeapon)
		yield(enemy, "activate_buttons")
		emit_signal("enemyAttacked")

func enemyHits():
	if (enemy.stam > 0):
		enemyDealsDamage()
	else:
		recoverEnemyStam()

func enemy_attack():
	enemyDealsDamage()
	yield(self, "enemyAttacked")
	decide_who_attacks()

func player_attack():
	UI.hideAllBaseButtons()
	if enemy_is_not_dead():
		UI.populateLowerPanel("You", sword)
		enemy.take_damage(max((playerStats.atk + sword.atk - enemy.def),0))
		yield(enemy, "activate_buttons")
		PlayerLessStamMoreTired(sword.weight)
		calculateBuffs()
		backToBattle()

func PlayerLessStamMoreTired(amount):
	playerStats.stam -= amount
	playerStats.tired += amount

func backToBattle():
	UI.showAllBaseButtons()
	UI.clearLowerText()

func decide_who_attacks():
	#both player and enemy have 0 or negatove stamina
	if(playerStats.stam <= 0 && enemy.stam <= 0):
		recoverPlayerStam()
		recoverEnemyStam()
	else: 
		#player has positive stamina but enemy has negative
		if(playerStats.stam > 0 && enemy.stam <= 0):
			player_attack()
			#if player can attack again
			if(playerStats.stam > 0):
				yield(enemy, "activate_buttons")
				player_attack()
				recoverEnemyStam()
			else:
				enemyHits()
				recoverPlayerStam()
		else:
			#player has negative stam but enemy has positive
			if(playerStats.stam <= 0 && enemy.stam > 0):
				enemyDealsDamage()
				#if enemy can attack again
				if(enemy.stam > 0):
					yield(enemy, "activate_buttons")
					enemyDealsDamage()
					recoverPlayerStam()
				else:
					recoverPlayerStam()
			else:
				#player and enemy have positive stamina
				var playerSpd = playerStats.spd - sword.weight - playerStats.tired
				var enemySpd = enemy.spd - enemyWeapon.weight - enemy.tired
				if(playerSpd > enemySpd):
						player_attack()
				else:
					if(playerSpd < enemySpd):
						enemy_attack()
					else:
						if(playerStats.stam >= enemy.stam):
							player_attack()
						else:
							enemy_attack()
							
func enemy_decides_weapon():
	enemyWeapon = enemy.enemyWeaponStats.weapon

func enemy_is_not_dead():
	return enemy != null

func resetBattleCounters():
	buffsPerBattle = 1
	consecutiveRests = 1
	consecutiveDefends = 1
	playerStats.buffs = []

func _on_Enemy_died():
	UI.enemy_died()
	resetBattleCounters()
	var potentialExp = int((enemy.lvl * 100) / playerStats.lvl )
	playerStats.xp += clamp(potentialExp, 0, 100)
	UI.congrats.text = "Congratulations\nYou won " + str(potentialExp) + " exp"
	if(playerStats.xp >= 100):
		playerStats.xp -= 100
		playerStats.lvl += 1
	else:
		yield(get_tree().create_timer(2), "timeout")
		UI.congrats.text = "Now what's next?"
		UI.nextMoveButtons.show()

func recoverPlayerStam():
	playerStats.recoverStamina()

func recoverEnemyStam():
	enemy.recoverStamina()

func applyMagic(stat):
	if(stat == 'HP'):
		playerStats.hp += playerStats.hpGainValue
	if(stat == 'STAM'):
		playerStats.stam += playerStats.stamGainValue
	if(stat != ''):
		PlayerLessStamMoreTired(buffsPerBattle)
		buffsPerBattle += 1
	backToBattle()
	emit_signal("updateStats")

func _on_SimpleSword_pressed():
	sword = swordStats.simpleSword
	UI.pressSimpleSwordButton(sword)
	consecutiveRests = 1

func _on_Attack_pressed():
	UI.hideSwordButtons()
	UI.clearLowerText()
	UI.unpressAttackButtons()
	enemy_decides_weapon()
	decide_who_attacks()
	consecutiveRests = 1

func _on_Apply_pressed():
	var selected = MagicButtons.buttonSelected
	if(selected != ''):
		UI.unpressAllMagicButtons()
		UI.hideMagicButtons()
		UI.clearLowerText()
		addNewBuff(selected)
		applyMagic(selected)

func cleanStats():
	playerStats.atk = playerStats.baseAtk
	playerStats.spd = playerStats.baseSpd
	playerStats.def = playerStats.baseDef
	playerStats.res = playerStats.baseRes

func addNewBuff(selected):
	var buffs = playerStats.buffs
	#1 is added to compensate for the updateStats happening afterwards
	if(selected == 'ATK'):
		buffs += [{'Stat':'ATK', 'value': playerStats.atkBuffValue+1}]
	if(selected == 'SPD'):
		buffs += [{'Stat':'SPD', 'value': playerStats.spdBuffValue+1}]
	if(selected == 'DEF'):
		buffs += [{'Stat':'DEF', 'value': playerStats.defBuffValue+1}]
	if(selected == 'RES'):
		buffs += [{'Stat':'RES', 'value': playerStats.resBuffValue+1}]
	playerStats.buffs = buffs

func calculateBuffs():
	var buffs = playerStats.buffs
	cleanStats()
	for buff in buffs:
		buff.value -= 1
		if (buff.value > 0):
			if (buff.Stat == 'ATK'):
				playerStats.atk += buff.value
			if (buff.Stat == 'SPD'):
				playerStats.spd += buff.value
			if (buff.Stat == 'DEF'):
				playerStats.def += buff.value
			if (buff.Stat == 'RES'):
				playerStats.res += buff.value
		if (buff.value < 0):
			buffs.erase(buff)

func _on_Battle_updateStats():
	calculateBuffs()
	emit_signal("checkifEnemyAttacks")

func _on_Battle_checkifEnemyAttacks():
	enemy_decides_weapon()
	if (playerStats.stam < enemy.stam):
		enemyHits()
	else:
		var enemySpd = enemy.spd - enemyWeapon.weight - enemy.tired
		var playerSpd = playerStats.spd - playerStats.tired
		if (playerSpd <= enemySpd):
			enemyHits()

func _on_Rest_pressed():
	UI.hideCongrats()
	UI.showSmallStats()
	UI.contractStatsPanel()
	UI.hideRestButtons()
	enemy_decides_weapon()
	enemyHits()
	playerStats.tired -= 5
	cleanStats()
	calculateBuffs()
	playerStats.atk += consecutiveRests
	playerStats.spd += consecutiveRests
	playerStats.def -= consecutiveRests
	playerStats.res -= consecutiveRests
	consecutiveRests += 1
	backToBattle()

func _on_Defend_pressed():
	UI.hideCongrats()
	UI.showSmallStats()
	UI.contractStatsPanel()
	UI.hideDefendButtons()
	enemy_decides_weapon()
	enemyHits()
	playerStats.tired -= 2
	cleanStats()
	calculateBuffs()
	playerStats.def += consecutiveDefends
	playerStats.res += consecutiveDefends
	playerStats.atk -= consecutiveDefends
	playerStats.spd -= consecutiveDefends
	consecutiveDefends += 1
	backToBattle()

