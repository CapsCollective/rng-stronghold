extends Control

var initialised = false
var negation_label_scene = preload("res://scenes/update_label.tscn")

onready var game_manager = $"../../"
onready var label_fields = {
	$GrainLabel: ["Grain: ", "grain"],
	$WaterLabel: ["Water: ", "water"],
	$InfluenceLabel: ["Inf: ", "influence"],
	$WeaponsLabel: ["Arms: ", "arms"],
	$WallsLabel: ["Walls:\n", "walls"],
	$DiceLabel: ["Dice: ", "dice"],
}

func _ready():
	$TurnButton.connect("pressed", self, "advance_turn")

func update_labels():
	$TurnLabel.text = "Turn: " + str(game_manager.turn)
	$EnemiesLabel.text = "Enemies: " + str(game_manager.enemies)
	
	for label in label_fields.keys():
		var old_value = int(label.text)
		var new_value = game_manager.get(label_fields[label][1])
		if label == $DiceLabel:
			old_value = int(label.text.right(label.text.find ("/")))
			$DiceLabel.text = "Dice: " + str(game_manager.turn_dice) + "/" + str(game_manager.dice)
		else:
			label.text = label_fields[label][0] + str(new_value)
		var difference = new_value - old_value
		if difference != 0 and initialised:
			display_label(label, str(difference))
	initialised = true

func display_label(resource_label, amount):
	var negation_label = negation_label_scene.instance()
	if !amount.begins_with("-"):
		amount = "+" + amount
		negation_label.modulate = Color(0.0980392, 1, 0.0235294, 1)
	negation_label.set_text(amount)
	negation_label.position = resource_label.get_global_transform().get_origin() + resource_label.get_size()/2
	$"../".add_child(negation_label)

func advance_turn():
	game_manager.advance_turn()
