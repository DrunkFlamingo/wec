local dev_cheats = {} --# assume dev_cheats: dev_cheats










core:add_listener(
        "CheatFrame",
        "ShortcutTriggered",
        function(context) return context.string == "camera_bookmark_view1"; end, --default F10
        function(context)
            local existingFrame = Util.getComponentWithName("CheatFrame");
            if not existingFrame then
                local cheatFrame = Frame.new("UIMFFrame");
                cheatFrame:Resize(750, 400);
            else
                --# assume existingFrame: FRAME
                existingFrame:SetVisible(true)
            end
        end,
        true
    );
