AutoEventsManager = {}
AutoEventOn = {}
AutoEventsManager.__index = AutoEventsManager

local __instance = {
    __index = AutoEventsManager,
    __type = 'AutoEventsManager'
}

local eventNames = {
    'colis',
    'eliminations'
}

---@param uid string
function AutoEventsManager.New(uid)
    local eventExists = false

    for i = 1, #eventNames do
        if eventNames[i] == uid then
            eventExists = true
            break
        end
    end

    if (eventExists) then
        local self = {}

        setmetatable(self, __instance);

        self.EventUniqueId = uid
        return self
    end

    local error = CFG.Errors['autoevent:error:eventDoesNotExist']
    print(error)
end

function AutoEventsManager:Start()
    if not self.EventUniqueId then
        print('autoevent unique id is nil!')
        return
    end

    AutoEventOn[self.EventUniqueId] = true
    TriggerEvent(('TOBI:%s:onStart'):format(self.EventUniqueId))
    TriggerServerEvent(('TOBI:autoevent:%s:start'):format(self.EventUniqueId))
end

function AutoEventsManager:Stop()
    TriggerEvent('TOBI:%s:onStop'):format(self.EventUniqueId)
    TriggerServerEvent('TOBI:autoevent:%s:stop'):format(self.EventUniqueId)
    AutoEventOn[self.EventUniqueId] = false
end

---@param uid number
function AutoEventsManager.StopByUniqueId(uid)
    if (uid) then
        TriggerEvent('TOBI:colis:onStop')
        local eventName = ('TOBI:autoevent:%s:stop'):format(uid)
        TriggerServerEvent(eventName)
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

function AutoEventsManager:OnStart(cb)
    AddEventHandler('TOBI:%s:onStart', cb()):format(self.EventUniqueId)
end

function AutoEventsManager:OnStop(cb)
    AddEventHandler('TOBI:%s:onStop', cb()):format(self.EventUniqueId)
end
