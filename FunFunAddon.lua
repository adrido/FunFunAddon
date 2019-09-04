-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
FunFunAddon = {}
 
-- This isn't strictly necessary, but we'll use this string later when registering events.
-- Better to define it in a single place rather than retyping the same string.
FunFunAddon.name = "FunFunAddon"
 
-- Next we create a function that will initialize our addon
function FunFunAddon:Initialize()
  -- ...but we don't have anything to initialize yet. We'll come back to this.
  --status ob player in kampf oder nicht
  self.inCombat = IsUnitInCombat("player")
  
    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)
	
	self.savedVariables = ZO_SavedVars:New("FunFunAddonSavedVariables", 1, nil, {})
	
	self:RestorePosition()
end
 
-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function FunFunAddon.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == FunFunAddon.name then
    FunFunAddon:Initialize()
  end
  zo_callLater(function() d("Hello Tamriel!") end, 2000)
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(FunFunAddon.name, EVENT_ADD_ON_LOADED, FunFunAddon.OnAddOnLoaded)


function FunFunAddon.OnPlayerCombatState(event, inCombat)
  -- The ~= operator is "not equal to" in Lua.
  if inCombat ~= FunFunAddon.inCombat then
    -- The player's state has changed. Update the stored state...
    FunFunAddon.inCombat = inCombat
 
    -- ...and then announce the change.
    if inCombat then
      d("Entering combat.")
    else
      d("Exiting combat.")
    end
    FunFunAddonIndicator:SetHidden(not inCombat)
  end
end

function FunFunAddon.OnIndicatorMoveStop()
  FunFunAddon.savedVariables.left = FunFunAddonIndicator:GetLeft()
  FunFunAddon.savedVariables.top = FunFunAddonIndicator:GetTop()
end

function FunFunAddon:RestorePosition()
  local left = self.savedVariables.left
  local top = self.savedVariables.top
 
  FunFunAddonIndicator:ClearAnchors()
  FunFunAddonIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end