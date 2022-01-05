extends Panel

onready var hpLabelSmall = $SmallStats/HPLabelSmall
onready var atkLabelSmall = $SmallStats/AtkLabelSmall
onready var stamLabelSmall = $SmallStats/StamLabelSmall
onready var atkLabelBig = $BigStats/YourStats/YourAtk
onready var spdLabelBig = $BigStats/YourStats/YourSpd
onready var defLabelBig = $BigStats/YourStats/YourDef
onready var resLabelBig = $BigStats/YourStats/YourRes
onready var tiredLabelBig = $BigStats/YourStats/YourTired
onready var stamLabelBig = $BigStats/YourStats/YourStam
onready var expLabelBig = $BigStats/YourStats/
onready var enemyStamLabel = $BigStats/EnemyStats/EnemyStam
onready var enemyTiredLabel = $BigStats/EnemyStats/EnemyTired
onready var animationPlayer = $StatsPanelAnimation
onready var congratsLabel = $CongratsLabel
onready var hpLabelLower = $"../LowerPanel/PlayerStats/HPLabel"
onready var lvlLabelLower = $"../LowerPanel/PlayerStats/LvlLabel"
onready var expLabelLower = $"../LowerPanel/PlayerStats/ExpLabel"

func _on_PlayerStats_hp_changed(value):
	hpLabelSmall.text = "HP\n"+str(value)
	hpLabelLower.text = "HP\n"+str(value)

func _on_PlayerStats_atk_changed(value):
	atkLabelSmall.text = "Atk\n"+str(value)
	atkLabelBig.text = "Atk\n"+str(value)

func _on_PlayerStats_stam_changed(value):
	stamLabelSmall.text = "Stam\n"+str(value)
	stamLabelBig.text = "Stam\n"+str(value)

func _on_PlayerStats_tired_changed(value):
	tiredLabelBig.text = "TIRED\n"+str(value)

func _on_PlayerStats_spd_changed(value):
	spdLabelBig.text = "SPD\n"+str(value)

func _on_PlayerStats_res_changed(value):
	resLabelBig.text = "RES\n"+str(value)

func _on_PlayerStats_def_changed(value):
	defLabelBig.text = "DEF\n"+str(value)

func changeEnemyStamBig(value):
	enemyStamLabel.text = "Stam\n"+str(value)

func changeEnemyTiredBig(value):
	enemyTiredLabel.text = "TIRED\n"+str(value)

func _on_PlayerStats_xp_changed(value):
	expLabelLower.text = "EXP\n"+str(value)

