#Persistent

; update mouse tooltip position this often, in ms
; 10 ms looks the smoothest, but you may prefer a higher value
; if the CPU load is too high with 10 ms
MouseTipUpdateInterval := 10

; a usage example
Tip("This is an example mousetip.")

;; Summon a mouse pointer anchored tooltip.
;; tip: message to show in tooltip
;; duration: how long the tooltip should persist; omit to let Tip() decide based on length of message
Tip(tip, duration = 0)
{
  global Tooltip

  ; Show our tip immediately
  Tooltip := tip
  TurnMouseTipOn()
  ForceMouseTipUpdate()

  ; Set the duration of the tip automatically unless specified
  if (duration == 0)
    duration := 100 * StrLen(Tooltip)

  ; Hide tip after duration
  SetTimer, HideMouseTip, %duration%
}

TurnMouseTipOn()
{
  global MouseTipUpdateInterval

  ; turn mouse tip on
  SetTimer, ShowMouseTip, %MouseTipUpdateInterval%

  ; let the timer tick, so the tip gets updated
  ; right after being turned on; a successive
  ; Send could block the timer otherwise
  Sleep % MouseTipUpdateInterval * 2
}

TurnMouseTipOff()
{
  SetTimer, ShowMouseTip, Off
  SetTimer, HideMouseTip, Off
  ToolTip,
}

ForceMouseTipUpdate()
{
  ForceMouseTipUpdateDelayed()
  SetTimer, ShowMouseTip, 1 ; "undelayed"
}

ForceMouseTipUpdateDelayed()
{
  global LastMouseTipX, LastMouseTipY

  ; this forces the mouse tip to get updated next timer tick
  LastMouseTipX := LastMouseTipY := 0
}

ShowMouseTip:
  SetTimer, ShowMouseTip, %MouseTipUpdateInterval%
  CoordMode Mouse, Relative
  MouseGetPos, xpos, ypos

  if (LastMouseTipMsg != Tooltip || LastMouseTipX != xpos || LastMouseTipY != ypos)
  {
    LastMouseTipMsg := Tooltip
    LastMouseTipX := xpos
    LastMouseTipY := ypos
    tip := Tooltip
    ToolTip, %tip%, xpos + 25, ypos + 10
  }
  return

HideMouseTip:
  TurnMouseTipOff()
  Tooltip := ""
  return