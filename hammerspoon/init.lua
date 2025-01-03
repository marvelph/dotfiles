function chooserCompletion(choice)
    if choice then
        if choice.workspaceName then
            hs.execute("/opt/homebrew/bin/aerospace workspace " .. choice.workspaceName)
        elseif choice.windowId then
            hs.execute("/opt/homebrew/bin/aerospace focus --window-id " .. choice.windowId)
        end
    end
end

chooser = hs.chooser.new(chooserCompletion)

function selectWorkspace()
    chooser:cancel()

    local output, status = hs.execute("/opt/homebrew/bin/aerospace list-workspaces --monitor focused --empty no --json")
    if not status then
        return
    end
    local workspacesJson = hs.json.decode(output)
    local choices = {}
    for _, workspaceJson in ipairs(workspacesJson) do
        local output, status = hs.execute("/opt/homebrew/bin/aerospace list-windows --workspace " .. workspaceJson["workspace"] .. " --format %{app-bundle-id}%{app-name} --json")
        if not status then
            return
        end
        local windowsJson = hs.json.decode(output)
        local subText = nil
        local image = nil
        for _, windowJson in ipairs(windowsJson) do
            if not subText then
                subText = windowJson["app-name"]
                image = hs.image.imageFromAppBundle(windowJson["app-bundle-id"])
            else
                subText = subText .. ", " .. windowJson["app-name"]
            end
        end
        local choice = {
            text = "workspace " .. workspaceJson["workspace"],
            subText = subText,
            image = image,
            workspaceName = workspaceJson["workspace"]
        }
        table.insert(choices, choice)
    end
    chooser:choices(choices)

    chooser:show()
end

function selectWindow()
    chooser:cancel()

    local output, status = hs.execute("/opt/homebrew/bin/aerospace list-windows --workspace focused --format %{window-id}%{window-title}%{app-bundle-id}%{app-name} --json")
    if not status then
        return
    end
    local windowsJson = hs.json.decode(output)
    local choices = {}
    for _, windowJson in ipairs(windowsJson) do
        local choice = {
            text = windowJson["window-title"],
            subText = windowJson["app-name"],
            image = hs.image.imageFromAppBundle(windowJson["app-bundle-id"]),
            windowId = windowJson["window-id"]
        }
        table.insert(choices, choice)
    end
    chooser:choices(choices)

    chooser:show()
end

function updateMenubar(workspaceName)
    local output, status = hs.execute("/opt/homebrew/bin/aerospace list-workspaces --monitor focused --json")
    if not status then
        return
    end
    local workspacesJson = hs.json.decode(output)
    local title = nil
    for _, workspaceJson in ipairs(workspacesJson) do
        local workspaceTitle = workspaceJson["workspace"]
        if workspaceTitle == workspaceName then
            workspaceTitle = "[ " .. workspaceTitle .. " ]"
        end
        if not title then
            title = workspaceTitle
        else
            title = title .. " " .. workspaceTitle
        end
    end
    menubar:setTitle(title)
end

menubar = hs.menubar.new()
updateMenubar(nil)

function onWorkspaceChange(eventName, params)
    updateMenubar(params["focused-workspace"])

    hs.alert.show("workspace " .. params["focused-workspace"])
end

hs.hotkey.bind({ "alt", "cmd" }, "up", selectWorkspace)
hs.hotkey.bind({ "alt", "cmd" }, "down", selectWindow)
hs.urlevent.bind("on-workspace-change", onWorkspaceChange)
