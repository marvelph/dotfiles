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
    local workspaces = hs.json.decode(output)
    local choices = {}
    for _, workspace in ipairs(workspaces) do
        local choice = {
            text = "workspace " .. workspace["workspace"],
            workspace = workspace["workspace"]
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
    local windows = hs.json.decode(output)
    local choices = {}
    for _, window in ipairs(windows) do
        local choice = {
            text = window["window-title"],
            subText = window["app-name"],
            image = hs.image.imageFromAppBundle(window["app-bundle-id"]),
            windowId = window["window-id"]
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
