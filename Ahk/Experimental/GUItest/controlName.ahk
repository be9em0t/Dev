gui, add, button, vBasRequl_a, control A
gui, add, button, vGrupoCotiz_a, control B
gui, show

loop {
  guiDisplayToggle( "BasRequl_a", i:=!i ) ; <- each toggle letter MUST be different!
  guiDisplayToggle( "GrupoCotiz_a", j:=!j )
  sleep, 1100
}

esc::exitApp ; <- press escape to exit

guiDisplayToggle( conVar, tSt ) {
  guiControl, % ( tSt ) ? "hide" : "show", % conVar
}