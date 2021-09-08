extends Interactable

func interact(body):
	if body != null:
		var stats_panel:StatsPanel = body.get_stats_panel()
		var current_health = stats_panel.get_health()
		
		stats_panel.set_health(current_health + 1)
