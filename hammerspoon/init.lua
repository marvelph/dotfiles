function chooserCompletion(choice)
    if choice then
        if choice.workspace then
            hs.execute("/opt/homebrew/bin/aerospace workspace " .. choice.workspace)
        elseif choice.windowId then
            hs.execute("/opt/homebrew/bin/aerospace focus --window-id " .. choice.windowId)
        end
    end
end

chooser = hs.chooser.new(chooserCompletion)

function selectWorkspace()
    chooser:cancel()

    local output = hs.execute("/opt/homebrew/bin/aerospace list-workspaces --monitor focused --empty no --json")
    local workspaces = hs.json.decode(output)
    local choices = {}
    for _, workspace in ipairs(workspaces) do
        local output = hs.execute("/opt/homebrew/bin/aerospace list-windows --workspace " .. workspace["workspace"] .. " --format %{app-bundle-id}%{app-name} --json")
        local windows = hs.json.decode(output)
        local subText = nil
        local image = nil
        for _, window in ipairs(windows) do
            if not subText then
                subText = window["app-name"]
                image = hs.image.imageFromAppBundle(window["app-bundle-id"])
            else
                subText = subText .. ", " .. window["app-name"]
            end
        end
        local choice = {
            text = "workspace " .. workspace["workspace"],
            subText = subText,
            image = image,
            workspace = workspace["workspace"]
        }
        table.insert(choices, choice)
    end
    chooser:choices(choices)

    chooser:show()
end

function selectWindow()
    chooser:cancel()

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
    chooser:choices(choices)

    chooser:show()
end

function onWorkspaceChange(eventName, params)
    hs.alert.show("workspace " .. params["focused-workspace"])
end

hs.hotkey.bind({ "alt", "cmd" }, "up", selectWorkspace)
hs.hotkey.bind({ "alt", "cmd" }, "down", selectWindow)
hs.urlevent.bind("exec-on-workspace-change", onWorkspaceChange)
