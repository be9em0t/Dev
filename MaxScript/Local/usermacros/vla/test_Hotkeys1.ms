
rollout exampleRollout "Example"
(
	label note "Let's see..."
/*	timer watcher active:true interval:100 -- ie 10 times per sec.
 
	on watcher tick do
	(
		if not keyboard.controlPressed do
			destroyDialog exampleRollout
	)
	*/
	
		timer theTimer interval:100 active:true
	local con = dotNetClass "system.windows.forms.control"
		on theTimer tick do 
		(
			print con.modifierkeys

			if con.MouseButtons==con.MouseButtons.middle do
			(
			   print "mmb"
			)
			
			if con.modifierKeys!=con.modifierKeys.none do
			(
			   print "key"
			)
				
		)
)
createDialog exampleRollout