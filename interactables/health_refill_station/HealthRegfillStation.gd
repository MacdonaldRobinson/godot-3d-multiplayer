extends Interactable

func interact(body):
	if body != null:
		var stats_panel:StatsPanel = body.get_stats_panel()
		var current_energy = stats_panel.get_energy()
		
		stats_panel.set_energy(current_energy + 1)
