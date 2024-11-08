function workspaceChooserCompletion(choice)
    if choice then
        hs.execute("/opt/homebrew/bin/aerospace workspace " .. choice.workspace)
    end
end

workspaceChooser = hs.chooser.new(workspaceChooserCompletion)

function selectWorkspace()
    workspaceChooser:cancel()
    windowChooser:cancel()

    local output = hs.execute("/opt/homebrew/bin/aerospace list-workspaces --monitor focused --empty no --json")
    local items = hs.json.decode(output)
    local choices = {}
    for i, item in ipairs(items) do
        local choice = {
            text = "workspace " .. item["workspace"],
            workspace = item["workspace"]
        }
        table.insert(choices, choice)
    end
    workspaceChooser:choices(choices)

    workspaceChooser:show()
end

hs.hotkey.bind({ "alt", "cmd" }, "up", selectWorkspace)

function windowChooserCompletion(choice)
    if choice then
        hs.execute("/opt/homebrew/bin/aerospace focus --window-id " .. choice.windowId)
    end
end

windowChooser = hs.chooser.new(windowChooserCompletion)

function selectWindow()
    workspaceChooser:cancel()
    windowChooser:cancel()

    local output = hs.execute("/opt/homebrew/bin/aerospace list-windows --workspace focused --format %{window-id}%{window-title}%{app-bundle-id}%{app-name} --json")
    local items = hs.json.decode(output)
    local choices = {}
    for i, item in ipairs(items) do
        local choice = {
            text = item["window-title"],
            subText = item["app-name"],
            image = hs.image.imageFromAppBundle(item["app-bundle-id"]),
            windowId = item["window-id"]
        }
        table.insert(choices, choice)
    end
    windowChooser:choices(choices)

    windowChooser:show()
end

hs.hotkey.bind({ "alt", "cmd" }, "down", selectWindow)

function onWorkspaceChange(eventName, params)
    hs.alert.show("workspace " .. params["focused-workspace"])
end

hs.urlevent.bind("exec-on-workspace-change", onWorkspaceChange)
