AutoEventsManager = {}
AutoEventOn = {}
AutoEventsManager.__index = AutoEventsManager

local __instance = {
    __index = AutoEventsManager,
    __type = 'CAutoEvent'
}

---@param uid string
function AutoEventsManager.New(uid)
    local self = setmetatable({}, __instance)

    self.EventUniqueId = uid
    return self
end

function AutoEventsManager:Start()
    if (self.EventUniqueId) then
        AutoEventOn[self.EventUniqueId] = true
        TOBI.EmitServer(('TOBI:autoevent:%s:start'):format(self.EventUniqueId))
    else
        IO.Debug('autoevent unique id is nil!')
    end
end

function AutoEventsManager:Stop()
    TOBI.EmitServer('TOBI:autoevent:%s:stop'):format(self.EventUniqueId)
    AutoEventOn[self.EventUniqueId] = false
end

---@param uid number
function AutoEventsManager.StopByUniqueId(uid)
    if (uid) then
        local eventName = ('TOBI:autoevent:%s:stop'):format(uid)
        TOBI.EmitServer(eventName)
        AutoEventOn[uid] = true
    end
end


function AutoEventsManager:IsOn()
    if (AutoEventOn[self.EventUniqueId] ~= nil) then
        return true
    end

    return false
end

---@param uid number
function AutoEventsManager.IsOnByUniqueId(uid)
    if (AutoEventOn[uid] ~= nil) then
        return true
    end

    return false
end

function AutoEventsManager:OnStart()
    AddEventHandler('TOBI:autoevent:%s:start'):format(self.EventUniqueId)
end

function AutoEventsManager:OnStop()
    AddEventHandler('TOBI:autoevent:%s:start'):format(self.EventUniqueId)
end

TOBI.Classes.CAutoEvent = AutoEventsManager
