# blombino-tracker
 A tracker that allows you to track players' movements and activities.


ox inventory item:


	['tracker'] = {
		label = 'GPS sėkiklis',
		weight = 300,
		stack = true,
		close = true,
		description = 'GPS sėkiklis skirtas matyti savo bendradarbius, draugus naudojančius tapatį sėkimo dažnį.',
		client = { 
			export = 'blombino-tracker.openTracker',
			remove = function(count)
				if count <= 0 then
					exports['blombino-tracker']:trackerRemoved()
				end
			end,
		}
	},
