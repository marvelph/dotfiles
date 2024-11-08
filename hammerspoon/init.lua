function chooserCompletion(choice)
    if choice then
        hs.execute("/opt/homebrew/bin/aerospace focus --window-id " .. choice.windowId)
    end
end

chooser = hs.chooser.new(chooserCompletion)

function focusWindow()
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
    chooser:choices(choices)

    chooser:show()
end

hs.hotkey.bind({ "alt", "cmd" }, "down", focusWindow)

function onWorkspaceChange(eventName, params)
    hs.alert.show("workspace " .. params["focused-workspace"])
end

hs.urlevent.bind("exec-on-workspace-change", onWorkspaceChange)
