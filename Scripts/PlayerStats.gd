extends Node

const battleUnits = preload("res://Resources/BattleUnits.tres")

func _ready():
	battleUnits.playerStats = self

func _exit_tree():
	battleUnits.playerStats = null

#values when starting anew
var initialHp = 20
var initialAtk = 3
var initialSpd = 5
var initialDef = 3
var initialRes = 3
var initialStam = 10
#max and base values
var baseHp = initialHp setget set_baseHp
var baseAtk = initialAtk setget set_baseAtk
var baseSpd = initialSpd setget set_baseSpd
var baseDef = initialDef setget set_baseDef
var baseRes = initialRes setget set_baseRes
var baseStam = initialStam setget set_baseStam

signal baseHp_changed(value)
signal baseAtk_changed(value)
signal baseSpd_changed(value)
signal baseDef_changed(value)
signal baseRes_changed(value)
signal baseStam_changed(value)

func set_baseHp(value):
	baseHp = value
	hp = baseHp
	emit_signal("baseHp_changed", baseHp)

func set_baseAtk(value):
	baseAtk = value
	atk = baseAtk
	emit_signal("baseAtk_changed", baseAtk)

func set_baseSpd(value):
	baseSpd = value
	spd = baseSpd
	emit_signal("baseSpd_changed", baseSpd)

func set_baseDef(value):
	baseDef = value
	def = baseDef
	emit_signal("baseDef_changed", baseDef)

func set_baseRes(value):
	baseRes = value
	res = baseRes
	emit_signal("baseRes_changed", baseRes)

func set_baseStam(value):
	baseStam = value
	stam = baseStam
	emit_signal("baseStam_changed", baseStam)
#the actual values
var hp = baseHp setget set_hp
var atk = baseAtk setget set_atk
var spd = baseSpd setget set_spd
var def = baseDef setget set_def
var res = baseRes setget set_res
var stam = baseStam setget set_stam

signal hp_changed(value)
signal atk_changed(value)
signal spd_changed(value)
signal def_changed(value)
signal res_changed(value)
signal stam_changed(value)

func set_hp(value):
	hp = clamp(value, 0, baseHp)
	emit_signal("hp_changed", hp)

func set_atk(value):
	atk = value
	emit_signal("atk_changed", atk)

func set_spd(value):
	spd = value
	emit_signal("spd_changed", spd)

func set_def(value):
	def = value
	emit_signal("def_changed", def)

func set_res(value):
	res = value
	emit_signal("res_changed", res)

func set_stam(value):
	stam = clamp(value, 0, baseStam)
	emit_signal("stam_changed", stam)
#the growth rates
var hpGrowthRate = 50 setget set_hpGrowthRate
var atkGrowthRate = 50 setget set_atkGrowthRate
var spdGrowthRate = 50 setget set_spdGrowthRate
var defGrowthRate = 50 setget set_defGrowthRate
var resGrowthRate = 50 setget set_resGrowthRate
var stamGrowthRate = 50 setget set_stamGrowthRate

func set_hpGrowthRate(value):
	hpGrowthRate = value

func set_atkGrowthRate(value):
	atkGrowthRate = value

func set_spdGrowthRate(value):
	spdGrowthRate = value

func set_defGrowthRate(value):
	defGrowthRate = value

func set_resGrowthRate(value):
	resGrowthRate = value

func set_stamGrowthRate(value):
	stamGrowthRate = value 
#exp and lvl
var xp = 0 setget set_xp
var lvl = 1 setget set_lvl

signal xp_changed(value)
signal lvl_changed(value)

func set_xp(value):
	xp = value
	emit_signal("xp_changed", xp)

func set_lvl(value):
	lvl = value
	emit_signal("lvl_changed", lvl)
#all the buffs and their turns/value
var buffs = [] setget set_buffs

signal buffs_changed(value)

func set_buffs(value):
	buffs = value
	emit_signal("buffs_changed", buffs)

#the amount the buff adds
var hpGainValue = 5 setget set_hpGainValue
var atkBuffValue = 3 setget set_atkBuffValue
var spdBuffValue = 3 setget set_spdBuffValue
var defBuffValue = 3 setget set_defBuffValue
var resBuffValue = 3 setget set_resBuffValue
var stamGainValue = 5 setget set_stamGainValue

signal hpGainValue_changed(value)
signal atkBuffValue_changed(value)
signal spdBuffValue_changed(value)
signal defBuffValue_changed(value)
signal resBuffValue_changed(value)
signal stamGainValue_changed(value)

func set_hpGainValue(value):
	hpGainValue = value
	emit_signal("hpGainValue_changed", hpGainValue)

func set_atkBuffValue(value):
	atkBuffValue = value
	emit_signal("atkBuffValue_changed", atkBuffValue)

func set_spdBuffValue(value):
	spdBuffValue = value
	emit_signal("spdBuffValue_changed", spdBuffValue)

func set_defBuffValue(value):
	defBuffValue = value
	emit_signal("defBuffValue_changed", defBuffValue)

func set_resBuffValue(value):
	resBuffValue = value
	emit_signal("resBuffValue_changed", resBuffValue)

func set_stamGainValue(value):
	stamGainValue = value
	emit_signal("stamGainValue_changed", stamGainValue)
#the speed counter to make the system "balanced"
var tired = 0 setget set_tired

signal tired_changed(value)

func set_tired(value):
	tired = max(value, 0)
	emit_signal("tired_changed", tired)
#Simple recover stamina function
func recoverStamina():
	stam += (baseStam/2) 
