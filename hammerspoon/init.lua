WindowFilter = {}

function WindowFilter:new()
    local obj = { ids = nil }
    self.__index = self
    return setmetatable(obj, self)
end

function WindowFilter:update()
    local output = hs.execute("/opt/homebrew/bin/aerospace list-windows --workspace focused --json")
    local items = hs.json.decode(output)
    self.ids = {}
    for i, item in ipairs(items) do
        table.insert(self.ids, item["window-id"])
    end
end

function WindowFilter:getWindows(sortOrder)
    local windows = {}
    for i, id in ipairs(self.ids) do
        local window = hs.window.get(id)
        table.insert(windows, window)
    end
    return windows
end

switcher = hs.window.switcher.new()
switcher.wf = WindowFilter:new()

function nextWindow()
    switcher.wf:update()
    switcher:next()
end

function previousWindow()
    switcher.wf:update()
    switcher:previous()
end

hs.hotkey.bind({ "alt" }, "tab", nextWindow)
hs.hotkey.bind({ "alt", "shift" }, "tab", previousWindow)

function onWorkspaceChange(eventName, params)
    hs.alert.show("workspace " .. params["focused-workspace"])
end

hs.urlevent.bind("exec-on-workspace-change", onWorkspaceChange)
