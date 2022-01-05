extends GridContainer

var buttonSelected

onready var magicButtons = $"."
onready var healHpButton = $HealHp
onready var buffAtkButton = $BuffAtk
onready var buffSpdButton = $BuffSpd
onready var buffDefButton = $BuffDef
onready var buffResButton = $BuffRes
onready var healStamButton = $HealStam
onready var applyMagicButton = $Apply
onready var cancelButton = $Cancel
onready var lowerStatsPanel = $'../LowerPanel/WholePanel'
onready var battle = $'../..'
onready var playerStats = $'../../PlayerStats'

#const battleUnits = preload("res://Resources/BattleUnits.tres")
#var playerStats = battleUnits.playerStats

func clearLowerText():
	lowerStatsPanel.text = ""

func hideAllMagicButtons():
	self.hide()

func showAllMagicButtons():
	self.show()

func unpressAllMagicButtons():
	healHpButton.pressed = false
	buffAtkButton.pressed = false
	buffSpdButton.pressed = false
	buffDefButton.pressed = false
	buffResButton.pressed = false
	healStamButton.pressed = false

func activateApplyMagicButton():
	applyMagicButton.disabled = false

func deactivateApplyMagicButton():
	applyMagicButton.disabled = true

func chooseOneMagicButton(button):
	unpressAllMagicButtons()
	button.pressed = true
	activateApplyMagicButton()

func clearButtonSelection():
	clearLowerText()
	deactivateApplyMagicButton()
	buttonSelected = ''

func addStamAndTiredString():
	return "-" + str(battle.buffsPerBattle) + " STAM / +" + str(battle.buffsPerBattle) + " TIRED"

func _on_HealHp_pressed():
	if(healHpButton.pressed == true):
		chooseOneMagicButton(healHpButton)
		lowerStatsPanel.text = "You'll recover:\n5 HP\n" + addStamAndTiredString()
		buttonSelected = 'HP'
	else:
		clearButtonSelection()

func _on_BuffAtk_pressed():
	if(buffAtkButton.pressed == true):
		chooseOneMagicButton(buffAtkButton)
		lowerStatsPanel.text = "Gain +" + str(playerStats.atkBuffValue) + " ATK\n-1 every action\n" + addStamAndTiredString()
		buttonSelected = 'ATK'
	else:
		clearButtonSelection()

func _on_BuffSpd_pressed():
	if(buffSpdButton.pressed == true):
		chooseOneMagicButton(buffSpdButton)
		lowerStatsPanel.text = "Gain +" + str(playerStats.spdBuffValue) + " SPD\n-1 every action\n" + addStamAndTiredString()
		buttonSelected = 'SPD'
	else:
		clearButtonSelection()

func _on_BuffDef_pressed():
	if(buffDefButton.pressed == true):
		chooseOneMagicButton(buffDefButton)
		lowerStatsPanel.text = "Gain +" + str(playerStats.defBuffValue) + " DEF\n-1 every action\n" + addStamAndTiredString()
		buttonSelected = 'DEF'
	else:
		clearButtonSelection()

func _on_BuffRes_pressed():
	if(buffResButton.pressed == true):
		chooseOneMagicButton(buffResButton)
		lowerStatsPanel.text = "Gain +" + str(playerStats.resBuffValue) + " RES\n-1 every action\n" + addStamAndTiredString()
		buttonSelected = 'RES'
	else:
		clearButtonSelection()

func _on_HealStam_pressed():
	if(healStamButton.pressed == true):
		chooseOneMagicButton(healStamButton)
		lowerStatsPanel.text = "You'll recover:\n5 STAM\nfor " +  str(battle.buffsPerBattle) + " TIRED"
		buttonSelected = 'STAM'
	else:
		clearButtonSelection()
