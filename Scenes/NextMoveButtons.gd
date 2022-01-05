extends GridContainer

onready var enemyButton = $NextMoveEnemy
onready var treasureButton = $NextMoveTreasure
onready var secretSpringButton = $NextMoveSecretSpring
onready var exchangeButton = $NextMoveExchange
onready var focusButton = $NextMoveFocus
onready var cancelButton = $NextMoveCancel
onready var forwardButton = $NextMoveForward
onready var baseButtons = $'../BaseButtons'
onready var lowerStatsPanel = $'../LowerPanel/WholePanel'
onready var battle = $'../..'
onready var enemyPosition = $'../../EnemyPosition'
onready var fadeAnimationPlayer = $'../../Fade/AnimationPlayer'
onready var UI = $'..'

func _on_NextMoveEnemy_pressed():
	if(enemyButton.pressed ):
		fadeAnimationPlayer.play("FadeBlack")
		yield(fadeAnimationPlayer, "animation_finished")
		var Enemy = battle.enemies.front()
		var enemy = Enemy.instance()
		enemyPosition.add_child(enemy)
		battle.enemy = enemy
		UI.enemy = enemy
		self.hide()
		baseButtons.show()
		UI.populateStats()

