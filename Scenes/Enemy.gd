extends Node2D

onready var hpLabel = $HPLabel
onready var nameLabel = $NameLabel	
onready var animationPlayer = $AnimationPlayer
onready var statsAnimations = $StatsAnimations
onready var enemyWeapon = $EnemyWeaponStats
onready var enemyHpLostLabel = $EnemyHpLost
onready var playerHpLostLabel = $PlayerHpLost
onready var enemyWeaponStats = $EnemyWeaponStats
onready var battle = $"../.."


const battleUnits = preload("res://Resources/BattleUnits.tres")

func _ready():
	battleUnits.enemy = self

func _exit_tree():
	battleUnits.enemy = null

signal died
signal activate_buttons

#Enemy stats
export (int) var max_stam = 5

export (int) var hp = 20 setget set_hp
export (int) var atk = 3
export (int) var spd = 3
export (int) var def = 1
export (int) var res = 1
var stam = max_stam setget set_stam
export (int) var tired = 0 setget set_tired
export (int) var lvl = 1 setget set_lvl

func set_hp(value):
	hp = value

func set_stam(value):
	stam = value

func set_tired(value):
	tired = value

func set_lvl(value):
	lvl = value

func recoverStamina():
	stam += (max_stam/2)

#Enemy actions
var damage = 0

func attack(weapon):
	stam -= weapon.weight
	tired += weapon.weight
	damage = atk + weapon.atk - battleUnits.playerStats.def
	yield(get_tree().create_timer(0.4), "timeout")
	animationPlayer.play("Attack")
	yield(animationPlayer, "animation_finished")
	battleUnits.playerStats.hp -= damage
	yield(get_tree().create_timer(0.4), "timeout")
	emit_signal("activate_buttons")

func dealDamage():
	playerHpLostLabel.text = str(damage)
	statsAnimations.play("PlayerLoseHp")
	yield(statsAnimations, "animation_finished")
	playerHpLostLabel.text = ''

func take_damage(amount):
	if(amount >= 0):
		yield(get_tree().create_timer(0.4), "timeout")
		enemyHpLostLabel.text = str(amount)
		animationPlayer.play("Shake")
		statsAnimations.play("EnemyLoseHp")
		yield(animationPlayer, "animation_finished")
		yield(statsAnimations, "animation_finished")
		enemyHpLostLabel.text = ''
		hp -= amount
		hpLabel.text = str(hp)+'hp'
		yield(get_tree().create_timer(0.4), "timeout")
		if is_dead():
			battle._on_Enemy_died()
			queue_free()
		else:
			emit_signal("activate_buttons")

func is_dead():
	return hp <= 0
