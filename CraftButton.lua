local ADDON_NAME = "CraftButton"
-- Weapon recipes
local RECIPE_MASTERY = 445385
local RECIPE_CRIT = 445379
local RECIPE_HASTE = 445317
local RECIPE_VERSA = 445351
local RECIPE_RADIANT_POWER = 445339
-- Cloak recipes
local RECIPE_WINGED_GRACE = 445386
local RECIPE_LEECHING_FANGS = 445393
-- Ring recipes
local RECIPE_RING_CRIT = 445387
local RECIPE_RING_HASTE = 445320
local RECIPE_RING_MASTERY = 445375
local RECIPE_RING_VERSA = 445349
local RECIPE_DEFENDERS_MARCH = 445396
-- Wrist recipes
local RECIPE_WRIST_LEECH = 445325
local RECIPE_WRIST_AVOIDANCE = 445334
local RECIPE_WRIST_SPEED = 445330
local VELLUM_ID = 38682
local VELLUM_LOCATION_DEFAULT = ItemLocation:CreateFromBagAndSlot(4, 36)

-- Function to find vellum in bags 0-4
local function findVellumLocation()
    for bag = 0, 4 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) or 0 do
            local itemID = C_Container.GetContainerItemID(bag, slot)
            if itemID == VELLUM_ID then
                return ItemLocation:CreateFromBagAndSlot(bag, slot)
            end
        end
    end
    -- Fallback to default location if not found
    return VELLUM_LOCATION_DEFAULT
end

-- Weapon regular reagent table
local WeaponRegular = {
    {
        reagent = {itemID = 219950},
        quantity = 5,
        dataSlotIndex = 2
    },
    {
        reagent = {itemID = 219946},
        quantity = 2,
        dataSlotIndex = 1
    },
    {
        reagent = {itemID = 219947},
        quantity = 48,
        dataSlotIndex = 1
    },
    {
        reagent = {itemID = 219954},
        quantity = 1,
        dataSlotIndex = 3
    },
    {
        reagent = {itemID = 222500},
        quantity = 1,
        dataSlotIndex = 4
    }
}

-- Radiant Power reagent table
local WeaponPower = {
    {
        reagent = {itemID = 219950},
        quantity = 10,
        dataSlotIndex = 2
    },
    {
        reagent = {itemID = 219946},
        quantity = 40,
        dataSlotIndex = 1
    },
    {
        reagent = {itemID = 219947},
        quantity = 35,
        dataSlotIndex = 1
    },
    {
        reagent = {itemID = 219955},
        quantity = 2,
        dataSlotIndex = 3
    },
    {
        reagent = {itemID = 222500},
        quantity = 1,
        dataSlotIndex = 4
    }
}

-- Cloak reagent table
local ReagentCloak = {
    {
        reagent = {itemID = 219950},
        quantity = 5,
        dataSlotIndex = 2
    },
    {
        reagent = {itemID = 219946},
        quantity = 3,
        dataSlotIndex = 1
    },
    {
        reagent = {itemID = 219947},
        quantity = 37,
        dataSlotIndex = 1
    },
    {
        reagent = {itemID = 222500},
        quantity = 1,
        dataSlotIndex = 3
    }
}

-- Wrist reagent table
local ReagentWrist = {
    {
        reagent = {itemID = 219950},
        quantity = 5,
        dataSlotIndex = 2
    },
    {
        reagent = {itemID = 219946},
        quantity = 1,
        dataSlotIndex = 1
    },
    {
        reagent = {itemID = 219947},
        quantity = 39,
        dataSlotIndex = 1
    },
    {
        reagent = {itemID = 222500},
        quantity = 1,
        dataSlotIndex = 3
    }
}

-- Ring reagent table
local ReagentRing = {
    {
        reagent = {itemID = 219950},
        quantity = 5,
        dataSlotIndex = 2
    },
    {
        reagent = {itemID = 219946},
        quantity = 1,
        dataSlotIndex = 1
    },
    {
        reagent = {itemID = 219947},
        quantity = 29,
        dataSlotIndex = 1
    },
    {
        reagent = {itemID = 222500},
        quantity = 1,
        dataSlotIndex = 3
    }
}

local function performCraft(recipeID, amount, reagents, displayName)
    if type(recipeID) ~= "number" then
        recipeID = RECIPE_MASTERY
        amount = amount or 1
        reagents = reagents or WeaponRegular
    else
        amount = amount or 1
        reagents = reagents or WeaponRegular
    end
    -- Check if profession window is open
    if not ProfessionsFrame or not ProfessionsFrame:IsVisible() then
        print("|cffff0000Error: Professions window must be open|r")
        return
    end

    -- Perform the craft
    C_TradeSkillUI.CraftEnchant(
        recipeID,            -- recipe ID
        amount,              -- amount to craft
        reagents,            -- reagent table
        findVellumLocation(), -- dynamically find vellum location
        true                 -- concentrating
    )

    local nameToShow = displayName or recipeID
    print("|cff00ff00Crafting initiated! Recipe: " .. nameToShow .. " Amount: " .. amount .. "|r")
end

local function createCraftButton()
    -- Create the main frame (use BackdropTemplate so SetBackdrop works)
    local frame = CreateFrame("Frame", ADDON_NAME .. "Frame", UIParent, "BackdropTemplate")
    frame:SetSize(420, 360)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetBackdrop({
        bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
        edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {left = 11, right = 12, top = 12, bottom = 11}
    })
    frame:SetBackdropColor(0.05, 0.05, 0.1, 0.95)
    frame:SetBackdropBorderColor(0.4, 0.4, 0.4, 0.8)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetUserPlaced(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetFrameStrata("HIGH")
    frame:Show()

    -- Create the title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", frame, "TOP", 0, -10)
    title:SetText(ADDON_NAME)
    title:SetTextColor(1, 0.82, 0)

    -- Create close button (top-right corner)
    local closeBtn = CreateFrame("Button", ADDON_NAME .. "CloseBtn", frame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4)
    closeBtn:SetScript("OnClick", function() frame:Hide() end)

    local craftQuantityBox
    -- Saved variables
    CraftButtonDB = CraftButtonDB or {}
    local db = CraftButtonDB
    db.quantity = db.quantity or 30
    if db.useFramework == nil then db.useFramework = true end

    local function makeButton(name, text, col, row, recipeID, reagents)
        local btn = CreateFrame("Button", ADDON_NAME .. name, frame, "GameMenuButtonTemplate")
        local btnWidth, btnHeight = 120, 28
        btn:SetSize(btnWidth, btnHeight)
        -- align in a neat grid inside the frame using TOPLEFT + tighter margins
        local fw = frame:GetWidth()
        local leftMargin = 12
        local topMargin = 28
        local cols = 3
        local colGap = 12
        local rowSpacing = 36
        local x = leftMargin + (col * (btnWidth + colGap))
        local y = -topMargin - (row * rowSpacing)
        btn:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y)
        btn:SetText(text)
        local btnText = btn:GetFontString()
        if btnText then
            btnText:SetFont("Fonts/FRIZQT__.TTF", 11)
            btnText:SetTextColor(1, 1, 1)
        end
        
        -- Check if recipe is known using GetRecipeInfo (handle different return shapes)
        local isKnown = false
        if C_TradeSkillUI.GetRecipeInfo then
            local info = C_TradeSkillUI.GetRecipeInfo(recipeID)
            if info then
                if type(info) == "table" then
                    if info.learned ~= nil then
                        isKnown = info.learned
                    elseif info.isLearned ~= nil then
                        isKnown = info.isLearned
                    else
                        -- If we got a table but no explicit flag, assume known
                        isKnown = true
                    end
                else
                    -- If GetRecipeInfo returned a non-table truthy value, treat as known
                    isKnown = true
                end
            end
        end
        
        if not isKnown then
            -- Disable unknown recipes
            btn:SetAlpha(0.5)
            btn:Disable()
            btn:SetScript("OnClick", function()
                print("|cffff0000Recipe unknown: " .. text .. "|r")
            end)
        else
            btn:SetScript("OnClick", function()
                local amount = 1
                if craftQuantityBox and craftQuantityBox:GetText() ~= "" then
                    amount = tonumber(craftQuantityBox:GetText()) or 1
                end
                performCraft(recipeID, amount, reagents, text)
            end)
        end
        
        btn:SetScript("OnEnter", function(self)
            self:SetAlpha(1)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            if isKnown then
                GameTooltip:AddLine("Click to craft " .. text, 0.2, 1, 0.2)
            else
                GameTooltip:AddLine(text .. " (Unknown)", 1, 0, 0)
                GameTooltip:AddLine("Learn this recipe to use", 1, 1, 1)
            end
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function()
            GameTooltip:Hide()
            if not isKnown then
                btn:SetAlpha(0.5)
            end
        end)
        btn:Show()
        return btn
    end

        -- Helper to create action buttons that run custom code (no recipe check)
        local function makeActionButton(name, text, col, row, onClick, align)
            local btn = CreateFrame("Button", ADDON_NAME .. name, frame, "GameMenuButtonTemplate")
            local btnWidth, btnHeight = 105, 25
            btn:SetSize(btnWidth, btnHeight)
            local leftMargin = 12
            local topMargin = 28
            local colGap = 12
            local rowSpacing = 38
            local x = leftMargin + (col * (btnWidth + colGap))
            local y = -topMargin - (row * rowSpacing)
            if align == "center" then
                btn:SetPoint("TOP", frame, "TOP", 0, y)
            else
                btn:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y)
            end
            btn:SetText(text)
            local btnText = btn:GetFontString()
            if btnText then
                btnText:SetFont("Fonts/FRIZQT__.TTF", 10)
                btnText:SetTextColor(1, 1, 1)
            end
            btn:SetScript("OnClick", onClick)
            btn:SetScript("OnEnter", function(self)
                self:SetAlpha(1)
                GameTooltip:SetOwner(self, "ANCHOR_TOP")
                GameTooltip:AddLine(text, 0.2, 1, 0.2)
                GameTooltip:Show()
            end)
            btn:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
            btn:Show()
            return btn
        end

    -- Weapon buttons (column 0)
    -- Radiant Power at top, leave one-row gap, then other enchants
    makeButton("RadiantPowerBtn", "Radiant Power", 0, 0, RECIPE_RADIANT_POWER, WeaponPower)
    -- gap row 1
    makeButton("MasteryBtn", "Stonebound Artistry", 0, 2, RECIPE_MASTERY, WeaponRegular)
    makeButton("CritBtn", "Council's Guile", 0, 3, RECIPE_CRIT, WeaponRegular)
    makeButton("HasteBtn", "Stormrider's Fury", 0, 4, RECIPE_HASTE, WeaponRegular)
    makeButton("VersaBtn", "Oathsworn Tenacity", 0, 5, RECIPE_VERSA, WeaponRegular)

    -- Ring buttons (column 1)
    makeButton("RingCritBtn", "Ring Crit", 1, 0, RECIPE_RING_CRIT, ReagentRing)
    makeButton("RingHasteBtn", "Ring Haste", 1, 1, RECIPE_RING_HASTE, ReagentRing)
    makeButton("RingMasteryBtn", "Ring Mastery", 1, 2, RECIPE_RING_MASTERY, ReagentRing)
    makeButton("RingVersaBtn", "Ring Versa", 1, 3, RECIPE_RING_VERSA, ReagentRing)
    -- Defenders March placed on a separate lower row in the ring column
    makeButton("DefendersMarchBtn", "Defenders March", 1, 5, RECIPE_DEFENDERS_MARCH, ReagentRing)

    -- Shatter action button (scans bags and crafts salvage)
    local shatterBtn = makeActionButton("ShatterBtn", "Shatter Essence", 1, 6, function()
        -- Open the salvage tradeskill UI (spell/skill 333)
        if C_TradeSkillUI and C_TradeSkillUI.OpenTradeSkill then
            C_TradeSkillUI.OpenTradeSkill(333)
        end
        for w = 12, 16 do
            for i = 1, 98 do
                local id = C_Container.GetContainerItemID and C_Container.GetContainerItemID(w, i)
                if id == 213610 then
                    local loc = ItemLocation:CreateFromBagAndSlot(w, i)
                    if C_TradeSkillUI and C_TradeSkillUI.CraftSalvage then
                        C_TradeSkillUI.CraftSalvage(445466, 1, loc)
                        print("|cff00ff00Shatter: started salvage on item at bag " .. w .. " slot " .. i .. "|r")
                        return
                    end
                end
            end
        end
        print("|cffff0000Shatter: no item 213610 found in bags 7-12|r")
    end, "center")

    -- Enlarge and restyle the Shatter button
    if shatterBtn then
        shatterBtn:SetSize(220, 44)
        local fs = shatterBtn:GetFontString()
        if fs and fs.SetFont then
            fs:SetFont("Fonts/FRIZQT__.TTF", 14)
        end
    end

    -- Bottom controls: quantity label + editbox, and a right-aligned checkbox
    local qtyLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    qtyLabel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 14, 14)
    qtyLabel:SetText("Craft quantity?")

    craftQuantityBox = CreateFrame("EditBox", ADDON_NAME .. "QuantityBox", frame, "InputBoxTemplate")
    craftQuantityBox:SetSize(44, 24)
    craftQuantityBox:SetPoint("LEFT", qtyLabel, "RIGHT", 8, 0)
    craftQuantityBox:SetAutoFocus(false)
    craftQuantityBox:SetText(tostring(db.quantity))
    craftQuantityBox:SetMaxLetters(6)
    craftQuantityBox:SetScript("OnEnterPressed", function(self)
        local v = tonumber(self:GetText())
        if v and v >= 1 then
            db.quantity = v
        end
        self:ClearFocus()
    end)
    craftQuantityBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    local useFrameworkCB = CreateFrame("CheckButton", ADDON_NAME .. "UseFrameworkCB", frame, "UICheckButtonTemplate")
    useFrameworkCB:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
    local cbText = _G[useFrameworkCB:GetName() .. "Text"]
    if cbText then
        cbText:SetText("Use framework?")
        cbText:ClearAllPoints()
        cbText:SetPoint("RIGHT", useFrameworkCB, "LEFT", -8, 0)
        cbText:SetJustifyH("RIGHT")
    end

    -- Add/remove the framework reagent (itemID 222500) from reagent tables
    local function setFrameworkForTable(tbl, enabled)
        if enabled then
            -- ensure entry exists with quantity 1
            local found = false
            for _, entry in ipairs(tbl) do
                if entry and entry.reagent and entry.reagent.itemID == 222500 then
                    entry.quantity = 1
                    found = true
                    break
                end
            end
            if not found then
                local ds = 4
                if tbl == ReagentCloak or tbl == ReagentWrist or tbl == ReagentRing then
                    ds = 3
                end
                table.insert(tbl, { reagent = { itemID = 222500 }, quantity = 1, dataSlotIndex = ds })
            end
        else
            -- remove any entries for 222500
            for i = #tbl, 1, -1 do
                local entry = tbl[i]
                if entry and entry.reagent and entry.reagent.itemID == 222500 then
                    table.remove(tbl, i)
                end
            end
        end
    end

    local function updateFrameworkUsage()
        local enabled = useFrameworkCB:GetChecked()
        setFrameworkForTable(WeaponRegular, enabled)
        setFrameworkForTable(WeaponPower, enabled)
        setFrameworkForTable(ReagentCloak, enabled)
        setFrameworkForTable(ReagentWrist, enabled)
        setFrameworkForTable(ReagentRing, enabled)
    end

    useFrameworkCB:SetScript("OnClick", function()
        db.useFramework = useFrameworkCB:GetChecked()
        updateFrameworkUsage()
    end)
    useFrameworkCB:SetChecked(db.useFramework)
    updateFrameworkUsage()

    -- Cloak + Wrist buttons (column 2) with a gap between cloak and wrist
    -- Cloak (top)
    makeButton("WingedGraceBtn", "Winged Grace", 2, 0, RECIPE_WINGED_GRACE, ReagentCloak)
    makeButton("LeechingFangsBtn", "Leeching Fangs", 2, 1, RECIPE_LEECHING_FANGS, ReagentCloak)
    -- Gap row (2)
    -- Wrist buttons (start at row 3)
    makeButton("WristLeechBtn", "Wrist Leech", 2, 3, RECIPE_WRIST_LEECH, ReagentWrist)
    makeButton("WristAvoidanceBtn", "Wrist Avoid", 2, 4, RECIPE_WRIST_AVOIDANCE, ReagentWrist)
    makeButton("WristSpeedBtn", "Wrist Speed", 2, 5, RECIPE_WRIST_SPEED, ReagentWrist)

    return frame
end

-- Global frame reference for reopening
local CraftButtonFrame

-- Create the button when addon loads
local function onAddonLoad(self, event, name)
    if event == "ADDON_LOADED" and name == ADDON_NAME then
        CraftButtonFrame = createCraftButton()
        print("|cff00ff00" .. ADDON_NAME .. " loaded! Button created. Use /cb to show/hide.|r")
        self:UnregisterEvent("ADDON_LOADED")
    end
end

-- Register for addon load
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", onAddonLoad)

-- Register slash commands
SLASH_CRAFTBUTTON1 = "/cb"

-- Recipe alias mapping: shortcode -> {recipeID, reagentTable, displayName}
local recipeAliases = {
    wm = {RECIPE_MASTERY, WeaponRegular, "Stonebound Artistry"},
    wc = {RECIPE_CRIT, WeaponRegular, "Council's Guile"},
    wh = {RECIPE_HASTE, WeaponRegular, "Stormrider's Fury"},
    wv = {RECIPE_VERSA, WeaponRegular, "Oathsworn Tenacity"},
    rp = {RECIPE_RADIANT_POWER, WeaponPower, "Radiant Power"},
    wg = {RECIPE_WINGED_GRACE, ReagentCloak, "Winged Grace"},
    lf = {RECIPE_LEECHING_FANGS, ReagentCloak, "Leeching Fangs"},
    rc = {RECIPE_RING_CRIT, ReagentRing, "Ring Crit"},
    rh = {RECIPE_RING_HASTE, ReagentRing, "Ring Haste"},
    rm = {RECIPE_RING_MASTERY, ReagentRing, "Ring Mastery"},
    rv = {RECIPE_RING_VERSA, ReagentRing, "Ring Versa"},
    dm = {RECIPE_DEFENDERS_MARCH, ReagentRing, "Defenders March"},
    wl = {RECIPE_WRIST_LEECH, ReagentWrist, "Wrist Leech"},
    wa = {RECIPE_WRIST_AVOIDANCE, ReagentWrist, "Wrist Avoidance"},
    ws = {RECIPE_WRIST_SPEED, ReagentWrist, "Wrist Speed"},
}

-- Helper to create a filtered reagent table (with or without framework item)
local function filterReagents(tbl, includeFramework)
    local filtered = {}
    for _, entry in ipairs(tbl) do
        if includeFramework or (entry.reagent.itemID ~= 222500) then
            table.insert(filtered, entry)
        end
    end
    return filtered
end

SlashCmdList["CRAFTBUTTON"] = function(msg)
    local parts = {}
    for part in msg:gmatch("%S+") do
        table.insert(parts, part)
    end

    if #parts == 0 then
        -- No arguments: show/toggle the frame
        if CraftButtonFrame then
            if CraftButtonFrame:IsShown() then
                CraftButtonFrame:Hide()
            else
                CraftButtonFrame:Show()
            end
        end
        return
    end

    local alias = parts[1]:lower()
    local amount = tonumber(parts[2]) or 1
    local useFrameworkFlag = tonumber(parts[3])
    local useFramework = (useFrameworkFlag == nil) or (useFrameworkFlag ~= 0)

    local recipe = recipeAliases[alias]
    if not recipe then
        print("|cffff0000Error: Unknown recipe alias '" .. alias .. "'|r")
        print("|cffff00ffAvailable aliases: wm, wc, wh, wv, rp, wg, lf, rc, rh, rm, rv, dm, wl, wa, ws|r")
        return
    end

    if amount < 1 then
        print("|cffff0000Error: Amount must be 1 or higher|r")
        return
    end

    local recipeID, reagents, displayName = recipe[1], recipe[2], recipe[3]
    local filteredReagents = filterReagents(reagents, useFramework)
    performCraft(recipeID, amount, filteredReagents, displayName)
end

