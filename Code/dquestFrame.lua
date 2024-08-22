function NpcPortraitFrame()
    local dquestFramePortrait = CreateFrame("Frame", nil, QuestFrame)
    QuestFramePortrait:SetParent(dquestFramePortrait)
    dquestFramePortrait:SetFrameLevel(9)
    QuestFramePortrait:SetWidth(50)
    QuestFramePortrait:SetHeight(50)
    QuestFramePortrait:SetPoint("TOPLEFT", QuestFrame, "TOPLEFT", 23 * 3, -3 * 6)
end

function ScrollFrameCorrection(frame)
    frame:SetPoint("TOPLEFT", QuestFrame, 120, -55)
    frame:SetWidth(512)
end

function HideScrollFrameBar(frameName)
    if frameName then
        local frameScrollBar = getglobal(frameName)
        if frameScrollBar then
            local frameScrollBarScrollUpButton = getglobal(frameName .. "ScrollUpButton")
            local frameScrollBarScrollDownButton = getglobal(frameName .. "ScrollDownButton")
            local frameScrollBarThumbTexture = getglobal(frameName .. "ThumbTexture")

            if frameScrollBarScrollUpButton then
                frameScrollBarScrollUpButton:SetNormalTexture(nil)
                frameScrollBarScrollUpButton:SetDisabledTexture(nil)
            end
            if frameScrollBarScrollDownButton then
                frameScrollBarScrollDownButton:SetNormalTexture(nil)
                frameScrollBarScrollDownButton:SetDisabledTexture(nil)
            end
            if frameScrollBarThumbTexture then
                frameScrollBarThumbTexture:SetTexture(nil)
            end
            -- frameScrollBar:SetWidth(0)
        end
    end
end
local race = UnitRace("player")
local texturePath
if race == "Night Elf" then
    texturePath = "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Blue"
elseif race == "Human" or race == "Gnome" or race == "Dwarf" or race == "High Elf" then
    texturePath = "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Blue"
else
    texturePath = "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Common1"
end

local function ClearBackgroundTextures(frame, maxCount)
    local count = 0
    for _, value in ipairs({ frame:GetRegions() }) do
        if value:GetDrawLayer() == "BACKGROUND" then
            count = count + 1
            if count <= maxCount then
                value:SetTexture(nil)
            else
                break
            end
        end
    end
end

local function ClearArtworkTextures(frame)
    for _, value in ipairs({ frame:GetRegions() }) do
        if value:GetDrawLayer() == "ARTWORK" then
            value:SetTexture(nil)
        end
    end
end

function DQuestFrame()
    local frame = QuestFrame

    frame:SetBackdrop({
        bgFile = "Interface\\AddOns\\DialogUI\\UI\\Parchment1",
        edgeFile = nil,
        tile = false,
        tileEdge = false,
        tileSize = 0,
        edgeSize = 0,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        }
    })

    frame:SetWidth(512)
    frame:SetHeight(512)
    QuestFrameCloseButton:Hide()
    ClearArtworkTextures(frame)

end

local function createTextBackdrop(name, parent, anchor, w, h, offsetX, offsetY)
    local frame = CreateFrame("Frame", name, parent)
    frame:SetBackdrop({
        bgFile = "Interface\\AddOns\\DialogUI\\UI\\SubHeaderBackground",
        edgeFile = nil,
        tile = false,
        tileEdge = false,
        tileSize = 0,
        edgeSize = 0,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        }
    })
    frame:SetWidth(w)
    frame:SetHeight(h)
    frame:SetFrameStrata("TOOLTIP")
    frame:SetPoint("LEFT", anchor, "RIGHT", offsetX, offsetY)
    frame:Hide()
end

local function createButtonHighlight(name, parent, anchor, w, h, offsetX, offsetY)
    local frame = CreateFrame("Frame", name, parent)
    frame:SetBackdrop({
        bgFile = "Interface\\AddOns\\DialogUI\\UI\\RewardChoice-Highlight",
        edgeFile = nil,
        tile = false,
        tileEdge = false,
        tileSize = 0,
        edgeSize = 0,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        }
    })
    frame:SetWidth(w)
    frame:SetHeight(h)
    frame:SetFrameStrata("TOOLTIP")
    frame:SetPoint("LEFT", anchor, "RIGHT", offsetX, offsetY)
    frame:Hide()
end

function textbackdrops()

    createButtonHighlight("HighlightRewardsFrame", QuestFrame, QuestRewardItemHighlight, 150, 45, -250, 6)

end

function hidebackdrops()
HighlightRewardsFrame:Hide()
end

local panels = {
    {
        panel = QuestFrameDetailPanel,
        scrollFrame = QuestDetailScrollFrame,
        scrollBarName = QuestDetailScrollFrameScrollBar:GetName(),
        hideRegions = false,
        clearArtwork = false
    },
    {
        panel = QuestFrameGreetingPanel,
        scrollFrame = QuestGreetingScrollFrame,
        scrollBarName = QuestGreetingScrollFrameScrollBar:GetName(),
        hideRegions = true,
        clearArtwork = true
    },
    {
        panel = QuestFrameProgressPanel,
        scrollFrame = QuestProgressScrollFrame,
        scrollBarName = QuestProgressScrollFrameScrollBar:GetName(),
        hideRegions = false,
        clearArtwork = false
    },
    {
        panel = QuestFrameRewardPanel,
        scrollFrame = QuestRewardScrollFrame,
        scrollBarName = QuestRewardScrollFrameScrollBar:GetName(),
        hideRegions = false,
        clearArtwork = false
    }
}

-- Generic function to handle panels
local function handlePanel(panelInfo)
    ClearBackgroundTextures(panelInfo.panel, 4)
    ScrollFrameCorrection(panelInfo.scrollFrame)
    HideScrollFrameBar(panelInfo.scrollBarName)

    if panelInfo.hideRegions then
        for index, value in ipairs({ panelInfo.panel:GetRegions() }) do
            if value:GetDrawLayer() == "ARTWORK" then
                if value:GetName() == "QuestGreetingFrameHorizontalBreak" then
                    value:SetTexture(nil)
                end
            end
        end
    end

    if panelInfo.clearArtwork then
        ClearArtworkTextures(panelInfo.panel)
    end
end

-- Function to handle all panels
function HandleAllPanels()
    for _, panelInfo in ipairs(panels) do
        handlePanel(panelInfo)
    end
end

-----------------------------Buttons--------------------------------

local function SetButtonProperties(button, normalTexture, highlightTexture, pushedTexture, width, height, pointA, pointB,
                                   pointX, pointY,
                                   fontColor)
    button:SetNormalTexture(normalTexture)
    button:SetHighlightTexture(highlightTexture)
    button:SetPushedTexture(pushedTexture)
    button:SetWidth(width)
    button:SetHeight(height)
    button:SetPoint(pointA, QuestFrame, pointB, pointX, pointY)
    SetFontColor(button:GetFontString(), fontColor)


    if button == QuestFrameCompleteButton then
        button:SetDisabledTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey")
    end

    if button == QuestFrameAcceptButton then
        button:SetDisabledTexture("Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey")
    end
end



function QuestFrameButtons()
	
	
    -- Accept Button
    SetButtonProperties(QuestFrameAcceptButton, texturePath,
        "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Gossip",
        texturePath,
        128, 32, "BOTTOMLEFT", "BOTTOMLEFT", 80, 50, "DarkModeGold")
		
		-- Adjust texture coordinates to maintain aspect ratio
		--SetTexCoord(0, 1, 0, 1)
		QuestFrameAcceptButton:GetNormalTexture():SetAllPoints(QuestFrameAcceptButton)
		QuestFrameAcceptButton:GetHighlightTexture():SetAllPoints(QuestFrameAcceptButton)
		QuestFrameAcceptButton:GetPushedTexture():SetAllPoints(QuestFrameAcceptButton)

    -- -- Decline Button
    SetButtonProperties(QuestFrameDeclineButton, "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey",
        "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Gossip",
        "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey",
        128, 32, "BOTTOMRIGHT", "BOTTOMRIGHT", -80, 50, "DarkModeGold")
		
				QuestFrameDeclineButton:GetNormalTexture():SetAllPoints(QuestFrameDeclineButton)
			QuestFrameDeclineButton:GetHighlightTexture():SetAllPoints(QuestFrameDeclineButton)
			QuestFrameDeclineButton:GetPushedTexture():SetAllPoints(QuestFrameDeclineButton)

    -- Complete Button
    SetButtonProperties(QuestFrameCompleteQuestButton, texturePath,
        "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Gossip",
        texturePath,
        128, 32, "BOTTOMLEFT", "BOTTOMLEFT", 80, 50, "DarkModeGrey90")
		
		QuestFrameCompleteQuestButton:GetNormalTexture():SetAllPoints(QuestFrameCompleteQuestButton)
		QuestFrameCompleteQuestButton:GetHighlightTexture():SetAllPoints(QuestFrameCompleteQuestButton)
		QuestFrameCompleteQuestButton:GetPushedTexture():SetAllPoints(QuestFrameCompleteQuestButton)

    -- Cancel Button
    SetButtonProperties(QuestFrameCancelButton, "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey",
        "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Gossip",
        "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey",
        128, 32, "BOTTOMRIGHT", "BOTTOMRIGHT", -80, 50, "DarkModeGrey90")
		
		-- Adjust texture coordinates to maintain aspect ratio
		--SetTexCoord(0, 1, 0, 1)
		QuestFrameCancelButton:GetNormalTexture():SetAllPoints(QuestFrameCancelButton)
		QuestFrameCancelButton:GetHighlightTexture():SetAllPoints(QuestFrameCancelButton)
		QuestFrameCancelButton:GetPushedTexture():SetAllPoints(QuestFrameCancelButton)

    -- Goodbye Button
	SetButtonProperties(QuestFrameGoodbyeButton, "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey",
		"Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Gossip",
		"Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey",
		128, 32, "BOTTOMRIGHT", "BOTTOMRIGHT", -80, 50, "DarkModeGrey90")

		-- Adjust texture coordinates to maintain aspect ratio
		--SetTexCoord(0, 1, 0, 1)
		QuestFrameGoodbyeButton:GetNormalTexture():SetAllPoints(QuestFrameGoodbyeButton)
		QuestFrameGoodbyeButton:GetHighlightTexture():SetAllPoints(QuestFrameGoodbyeButton)
		QuestFrameGoodbyeButton:GetPushedTexture():SetAllPoints(QuestFrameGoodbyeButton)

    -- GreetingGoodbye Button
    SetButtonProperties(QuestFrameGreetingGoodbyeButton, "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey",
        "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Gossip",
        "Interface\\AddOns\\DialogUI\\UI\\OptionBackground-Grey",
        128, 32, "BOTTOMRIGHT", "BOTTOMRIGHT", -80, 50, "DarkModeGoldDim")

			-- Adjust texture coordinates to maintain aspect ratio
		--SetTexCoord(0, 1, 0, 1)
		QuestFrameGreetingGoodbyeButton:GetNormalTexture():SetAllPoints(QuestFrameGreetingGoodbyeButton)
		QuestFrameGreetingGoodbyeButton:GetHighlightTexture():SetAllPoints(QuestFrameGreetingGoodbyeButton)
		QuestFrameGreetingGoodbyeButton:GetPushedTexture():SetAllPoints(QuestFrameGreetingGoodbyeButton)

    -- Continue Button
    SetButtonProperties(QuestFrameCompleteButton, texturePath,
        "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Gossip",
        texturePath,
        128, 32, "BOTTOMLEFT", "BOTTOMLEFT", 80, 50, "DarkModeGrey90")

		QuestFrameCompleteButton:GetNormalTexture():SetAllPoints(QuestFrameCompleteButton)
		QuestFrameCompleteButton:GetHighlightTexture():SetAllPoints(QuestFrameCompleteButton)
		QuestFrameCompleteButton:GetPushedTexture():SetAllPoints(QuestFrameCompleteButton)
		
		local texturePath1 = texturePath
		local highlightTexture = "Interface\\AddOns\\DialogUI\\UI\\ButtonHighlight-Gossip"
		local buttonWidth = 275
		local buttonHeight = 20
		local pointA = "TOP"
		local pointB = "TOP"
		local pointX = 70
		local pointY = 50
		local fontColor = "DarkModeGold"
		
		for i = 1, 11 do
			local button = getglobal("QuestTitleButton" .. i)
			if button then
				SetButtonProperties(button, texturePath, highlightTexture, texturePath, buttonWidth, buttonHeight, pointA, pointB, pointX, pointY, fontColor)
			end
		end
		
end

-----------------------------Fonts--------------------------------
 COLORS = {
    --ColorKey = {r, g, b}
    -- DarkBrown = { 0.19, 0.17, 0.13 },
    -- LightBrown = { 0.50, 0.36, 0.24 },
    Ivory = { 0.87, 0.86, 0.75 },
	White = { 1, 1, 1 },
	DarkModeGrey90 = {0.9, 0.9, 0.9},
    DarkModeGrey70 = {0.7, 0.7, 0.7},
    DarkModeGrey50 = {0.5, 0.5, 0.5},
    DarkModeGold = {1, 0.98, 0.8},
    DarkModeGoldDim = {0.796, 0.784, 0.584},
};

function SetFontColor(fontObject, key)
    local color = COLORS[key];
    fontObject:SetTextColor(color[1], color[2], color[3]);
end





function FontColorAndSize()
    CurrentQuestsText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 16)      -- Current quest text  "Current Quests"
    AvailableQuestsText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 16)    -- Available quest text "Available Quests"
    GreetingText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 14)           --Quest Greeting Text
    QuestTitleFont:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 16)         --Quest Title Text in the detail panel
    QuestFont:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 14)       --Quest Description Text in the detail panel
    QuestObjectiveText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 14)     --Quest Objective Text in the detail panel
    QuestProgressTitleText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 16) --Quest Progress Title Text in the progress panel
    QuestProgressText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 14)      --Quest Progress Text in the progress panel
    QuestFrameNpcNameText:SetFont("Interface\\AddOns\\DialogUI\\Font\\frizqt___cyr.ttf", 18)  --Quest NPC Name Text (it's been replaced with the title of the quest)
	
end

function ColorFonts()
SetFontColor(QuestFrameNpcNameText, "DarkModeGrey90")
SetFontColor(GreetingText, "DarkModeGrey70")
SetFontColor(CurrentQuestsText,"DarkModeGrey90")
SetFontColor(QuestTitleFont,"DarkModeGrey90")
SetFontColor(QuestDescription, "DarkModeGrey70")
SetFontColor(AvailableQuestsText, "DarkModeGrey90")
SetFontColor(QuestProgressTitleText, "DarkModeGrey70")
SetFontColor(QuestProgressText, "DarkModeGrey70")
SetFontColor(QuestObjectiveText, "DarkModeGrey70")
SetFontColor(QuestRewardTitleText, "DarkModeGrey70")
SetFontColor(QuestRewardText, "DarkModeGrey70")
SetFontColor(QuestFont,"DarkModeGrey70")
end

-----------------------------Load on Startup-------------------------
NpcPortraitFrame()
QuestFrameButtons()
FontColorAndSize()
textbackdrops()

-- ColorFonts()

---------------Event Handlers-------------------

QuestNpcNameFrame:SetScript("OnShow",
    function(self)
        QuestFrameNpcNameText:SetText(GetTitleText())
        QuestFrameNpcNameText:SetFontObject(GameFontNormal)
        QuestFrameNpcNameText:SetShadowColor(0, 0, 0, 1)
        QuestFrameNpcNameText:SetShadowOffset(-1, -1)
        QuestFrameNpcNameText:SetPoint("TOP", QuestNpcNameFrame, "TOPLEFT", 160, 5)
        QuestTitleText:Hide()
        QuestProgressTitleText:Hide()
        NpcPortraitFrame()
        QuestFrameNpcNameText:SetWidth(300)
        QuestFrameNpcNameText:SetHeight(50)
		
    end)
	

QuestFrame:SetScript("OnShow",
    function(self)
		QuestFrame:SetScale(1.2)
        DQuestFrame()
        HandleAllPanels()
		ColorFonts()
		QuestSpacerFrame:SetHeight(55)
    end
)




local oldOnShow = QuestFrameGreetingPanel_OnShow;
QuestFrameGreetingPanel_OnShow = function()
    oldOnShow();

    for i = 1, MAX_NUM_QUESTS do
        local titleLine = getglobal("QuestTitleButton" .. i);
        if (titleLine:IsVisible()) then
            local bulletPointTexture = titleLine:GetRegions();
            if (titleLine.isActive == 1) then
                bulletPointTexture:SetTexture("Interface\\GossipFrame\\ActiveQuestIcon");
            else
                bulletPointTexture:SetTexture("Interface\\GossipFrame\\AvailableQuestIcon");
            end
        end
    end
end


-- Hook Blizzard Code---

function QuestFrameRewardPanel_OnShow()
	QuestFrameDetailPanel:Hide();
	QuestFrameGreetingPanel:Hide();
	QuestFrameProgressPanel:Hide();
	local material = QuestFrame_GetMaterial();
	QuestFrame_SetMaterial(QuestFrameRewardPanel, material);
	QuestRewardTitleText:Hide()
	-- QuestRewardTitleTextFrame:Hide()
	-- QuestFrame_SetTitleTextColor(QuestRewardTitleText,material);
	QuestRewardText:SetText(GetRewardText());
	QuestRewardText:ClearAllPoints()
	QuestRewardText:SetPoint("CENTER", QuestFrameNpcNameText, "CENTER" ,0, -70);
	-- QuestFrame_SetTextColor(QuestRewardText, material);
	QuestFrameItems_Update("QuestReward");
	QuestRewardScrollFrame:UpdateScrollChildRect();
	QuestRewardScrollFrameScrollBar:SetValue(0);
	if ( QUEST_FADING_DISABLE == "0" ) then
		QuestRewardScrollChildFrame:SetAlpha(0);
		UIFrameFadeIn(QuestRewardScrollChildFrame, QUESTINFO_FADE_IN);
	end
end

function QuestRewardCancelButton_OnClick()
	DeclineQuest();
	PlaySound("igQuestCancel");
end

function QuestRewardCompleteButton_OnClick()
	if ( QuestFrameRewardPanel.itemChoice == 0 and GetNumQuestChoices() > 0 ) then
		QuestChooseRewardError();
	else
		GetQuestReward(QuestFrameRewardPanel.itemChoice);
		PlaySound("igQuestListComplete");
	end
end

function QuestProgressCompleteButton_OnClick()
	CompleteQuest();
	--PlaySound("igQuestListComplete");
end

function QuestGoodbyeButton_OnClick()
	DeclineQuest();
	PlaySound("igQuestCancel");
end

function QuestItem_OnClick()
	if ( IsControlKeyDown() ) then
		if ( this.rewardType ~= "spell" ) then
			DressUpItemLink(GetQuestItemLink(this.type, this:GetID()));
		end
	elseif ( IsShiftKeyDown() ) then
		if ( ChatFrameEditBox:IsVisible() and this.rewardType ~= "spell") then
			ChatFrameEditBox:Insert(GetQuestItemLink(this.type, this:GetID()));
		end
	end
end

function QuestRewardItem_OnClick()
	if ( IsControlKeyDown() ) then
		if ( this.rewardType ~= "spell" ) then
			DressUpItemLink(GetQuestItemLink(this.type, this:GetID()));
		end
	elseif ( IsShiftKeyDown() ) then
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:Insert(GetQuestItemLink(this.type, this:GetID()));
		end
	elseif ( this.type == "choice" ) then
		QuestRewardItemHighlight:SetPoint("TOPLEFT", this, "TOPLEFT", -8, 7);
		-- QuestRewardItemHighlight:Show();
		HighlightRewardsFrame:Show()
		QuestFrameRewardPanel.itemChoice = this:GetID();
	end
end

function QuestFrameProgressPanel_OnShow()
	QuestFrameRewardPanel:Hide();
	QuestFrameDetailPanel:Hide();
	QuestFrameGreetingPanel:Hide();
	local material = QuestFrame_GetMaterial();
	QuestFrame_SetMaterial(QuestFrameProgressPanel, material);
	QuestProgressTitleText:SetText(GetTitleText());
	-- QuestFrame_SetTitleTextColor(QuestProgressTitleText, material);
	QuestProgressText:SetText(GetProgressText());
	-- QuestFrame_SetTextColor(QuestProgressText, material);
	if ( IsQuestCompletable() ) then
		QuestFrameCompleteButton:Enable();
	else
		QuestFrameCompleteButton:Disable();
	end
	QuestFrameProgressItems_Update();
	if ( QUEST_FADING_DISABLE == "0" ) then
		QuestProgressScrollChildFrame:SetAlpha(0);
		UIFrameFadeIn(QuestProgressScrollChildFrame, QUESTINFO_FADE_IN);
	end
end

function QuestFrameProgressItems_Update()
	local numRequiredItems = GetNumQuestItems();
	local questItemName = "QuestProgressItem";
	if ( numRequiredItems > 0 or GetQuestMoneyToGet() > 0 ) then
		QuestProgressRequiredItemsText:Show();
		
		-- If there's money required then anchor and display it
		if ( GetQuestMoneyToGet() > 0 ) then
			MoneyFrame_Update("QuestProgressRequiredMoneyFrame", GetQuestMoneyToGet());
			
			if ( GetQuestMoneyToGet() > GetMoney() ) then
				-- Not enough money
				QuestProgressRequiredMoneyText:SetTextColor(0, 0, 0);
				SetMoneyFrameColor("QuestProgressRequiredMoneyFrame", 1.0, 0.1, 0.1);
			else
				QuestProgressRequiredMoneyText:SetTextColor(0.2, 0.2, 0.2);
				SetMoneyFrameColor("QuestProgressRequiredMoneyFrame", 1.0, 1.0, 1.0);
			end
			QuestProgressRequiredMoneyText:Show();
			QuestProgressRequiredMoneyFrame:Show();

			-- Reanchor required item
			getglobal(questItemName..1):SetPoint("TOPLEFT", "QuestProgressRequiredMoneyText", "BOTTOMLEFT", 0, -10);
		else
			QuestProgressRequiredMoneyText:Hide();
			QuestProgressRequiredMoneyFrame:Hide();

			getglobal(questItemName..1):SetPoint("TOPLEFT", "QuestProgressRequiredItemsText", "BOTTOMLEFT", -3, -5);
		end


		
		for i=1, numRequiredItems, 1 do	
			local requiredItem = getglobal(questItemName..i);
			requiredItem.type = "required";
			local name, texture, numItems = GetQuestItemInfo(requiredItem.type, i);
			SetItemButtonCount(requiredItem, numItems);
			SetItemButtonTexture(requiredItem, texture);
			requiredItem:Show();
			getglobal(questItemName..i.."Name"):SetText(name);
			
		end
	else
		QuestProgressRequiredMoneyText:Hide();
		QuestProgressRequiredMoneyFrame:Hide();
		QuestProgressRequiredItemsText:Hide();
	end
	for i=numRequiredItems + 1, MAX_REQUIRED_ITEMS, 1 do
		getglobal(questItemName..i):Hide();
	end
	QuestProgressScrollFrame:UpdateScrollChildRect();
	QuestProgressScrollFrameScrollBar:SetValue(0);
end

function QuestFrameGreetingPanel_OnShow()
	QuestFrameRewardPanel:Hide();
	QuestFrameProgressPanel:Hide();
	QuestFrameDetailPanel:Hide();
	if ( QUEST_FADING_DISABLE == "0" ) then
		QuestGreetingScrollChildFrame:SetAlpha(0);
		UIFrameFadeIn(QuestGreetingScrollChildFrame, QUESTINFO_FADE_IN);
	end
	local material = QuestFrame_GetMaterial();
	QuestFrame_SetMaterial(QuestFrameGreetingPanel, material);
	GreetingText:SetText(GetGreetingText());
	-- QuestFrame_SetTextColor(GreetingText, material);
	-- QuestFrame_SetTitleTextColor(CurrentQuestsText, material);
	-- QuestFrame_SetTitleTextColor(AvailableQuestsText, material);
	-- AvailableQuestsTextFrame:Show()
	local numActiveQuests = GetNumActiveQuests();
	local numAvailableQuests = GetNumAvailableQuests();
	if ( numActiveQuests == 0 ) then
		CurrentQuestsText:Hide();
		-- CurrentQuestsTextFrame:Hide()
		QuestGreetingFrameHorizontalBreak:Hide();
	else 
		CurrentQuestsText:SetPoint("TOPLEFT", "GreetingText", "BOTTOMLEFT", 0, -10);
		CurrentQuestsText:Show();
		-- CurrentQuestsTextFrame:Show()
		QuestTitleButton1:SetPoint("TOPLEFT", "CurrentQuestsText", "BOTTOMLEFT", -10, -5);
		for i=1, numActiveQuests, 1 do
			local questTitleButton = getglobal("QuestTitleButton"..i);
			questTitleButton:SetText(GetActiveTitle(i));
			questTitleButton:SetHeight(questTitleButton:GetTextHeight() + 2);
			questTitleButton:SetID(i);
			questTitleButton.isActive = 1;
			questTitleButton:Show();
			if ( i > 1 ) then
				questTitleButton:SetPoint("TOPLEFT", "QuestTitleButton"..(i-1),"BOTTOMLEFT", 0, -0)
			end
		end
	end
	if ( numAvailableQuests == 0 ) then
		AvailableQuestsText:Hide();
		-- AvailableQuestsTextFrame:Hide()
		QuestGreetingFrameHorizontalBreak:Hide();
	else
		if ( numActiveQuests > 0 ) then
			QuestGreetingFrameHorizontalBreak:SetPoint("TOPLEFT", "QuestTitleButton"..numActiveQuests, "BOTTOMLEFT",22,-10);
			QuestGreetingFrameHorizontalBreak:Show();
			AvailableQuestsText:SetPoint("TOPLEFT", "QuestGreetingFrameHorizontalBreak", "BOTTOMLEFT", -12, -10);
		else
			AvailableQuestsText:SetPoint("TOPLEFT", "GreetingText", "BOTTOMLEFT", 0, -10);
		end
		AvailableQuestsText:Show();
		-- AvailableQuestsTextFrame:Show();
		-- showBackdrop()
		getglobal("QuestTitleButton"..(numActiveQuests + 1)):SetPoint("TOPLEFT", "AvailableQuestsText", "BOTTOMLEFT", -10, -15);
		for i=(numActiveQuests + 1), (numActiveQuests + numAvailableQuests), 1 do
			local questTitleButton = getglobal("QuestTitleButton"..i);
			questTitleButton:SetText(GetAvailableTitle(i - numActiveQuests));
			questTitleButton:SetHeight(questTitleButton:GetTextHeight() + 2);
			questTitleButton:SetID(i - numActiveQuests);
			questTitleButton.isActive = 0;
			questTitleButton:Show();
			if ( i > numActiveQuests + 1 ) then
				questTitleButton:SetPoint("TOPLEFT", "QuestTitleButton"..(i-1),"BOTTOMLEFT", 0, -15)
			end
		end
	end
	for i=(numActiveQuests + numAvailableQuests + 1), MAX_NUM_QUESTS, 1 do
		getglobal("QuestTitleButton"..i):Hide();
	end
end

function QuestFrame_OnShow()
	PlaySound("igQuestListOpen");
end

function QuestFrame_OnHide()
	QuestFrameGreetingPanel:Hide();
	QuestFrameDetailPanel:Hide();
	QuestFrameRewardPanel:Hide();
	QuestFrameProgressPanel:Hide();
	CloseQuest();
	hidebackdrops()
	PlaySound("igQuestListClose");
end

function QuestTitleButton_OnClick()
	if ( this.isActive == 1 ) then
		SelectActiveQuest(this:GetID());
	else
		SelectAvailableQuest(this:GetID());
	end
	PlaySound("igQuestListSelect");
end

function QuestMoneyFrame_OnLoad()
	MoneyFrame_OnLoad();
	MoneyFrame_SetType("STATIC");
end

function QuestFrameItems_Update(questState)
	local isQuestLog = 0;
	if ( questState == "QuestLog" ) then
		isQuestLog = 1;
	end
	local numQuestRewards;
	local numQuestChoices;
	local numQuestSpellRewards = 0;
	local money;
	local spacerFrame;
	if ( isQuestLog == 1 ) then
		numQuestRewards = GetNumQuestLogRewards();
		numQuestChoices = GetNumQuestLogChoices();
		if ( GetQuestLogRewardSpell() ) then
			numQuestSpellRewards = 1;
		end
		money = GetQuestLogRewardMoney();
		spacerFrame = QuestLogSpacerFrame;
	else
		numQuestRewards = GetNumQuestRewards();
		numQuestChoices = GetNumQuestChoices();
		if ( GetRewardSpell() ) then
			numQuestSpellRewards = 1;
		end
		money = GetRewardMoney();
		spacerFrame = QuestSpacerFrame;
	end

	local totalRewards = numQuestRewards + numQuestChoices + numQuestSpellRewards;
	local questItemName = questState.."Item";
	local material = QuestFrame_GetMaterial();
	local  questItemReceiveText = getglobal(questState.."ItemReceiveText")
	if ( totalRewards == 0 and money == 0 ) then
		getglobal(questState.."RewardTitleText"):Hide();
		-- QuestRewardTitleTextFrame:Hide()
	else
		getglobal(questState.."RewardTitleText"):Show();
		-- QuestRewardTitleTextFrame:Show()
		-- QuestFrame_SetTitleTextColor(getglobal(questState.."RewardTitleText"), material);
		QuestFrame_SetAsLastShown(getglobal(questState.."RewardTitleText"), spacerFrame);
	end
	if ( money == 0 ) then
		getglobal(questState.."MoneyFrame"):Hide();
	else
		getglobal(questState.."MoneyFrame"):Show();
		QuestFrame_SetAsLastShown(getglobal(questState.."MoneyFrame"), spacerFrame);
		MoneyFrame_Update(questState.."MoneyFrame", money);
	end
	
	-- Hide unused rewards
	for i=totalRewards + 1, MAX_NUM_ITEMS, 1 do
		getglobal(questItemName..i):Hide();
	end

	local questItem, name, texture, isTradeskillSpell, quality, isUsable, numItems = 1;
	local rewardsCount = 0;
	
	-- Setup choosable rewards
	if ( numQuestChoices > 0 ) then
		local itemChooseText = getglobal(questState.."ItemChooseText");
		itemChooseText:Show();
		-- QuestFrame_SetTextColor(itemChooseText, material);
		QuestFrame_SetAsLastShown(itemChooseText, spacerFrame);
		
		local index;
		local baseIndex = rewardsCount;
		for i=1, numQuestChoices, 1 do	
			index = i + baseIndex;
			questItem = getglobal(questItemName..index);
			questItem.type = "choice";
			numItems = 1;
			if ( isQuestLog == 1 ) then
				name, texture, numItems, quality, isUsable = GetQuestLogChoiceInfo(i);
			else
				name, texture, numItems, quality, isUsable = GetQuestItemInfo(questItem.type, i);
			end
			questItem:SetID(i)
			questItem:Show();
			-- For the tooltip
			questItem.rewardType = "item"
			QuestFrame_SetAsLastShown(questItem, spacerFrame);
			getglobal(questItemName..index.."Name"):SetText(name);
			SetItemButtonCount(questItem, numItems);
			SetItemButtonTexture(questItem, texture);
			if ( isUsable ) then
				SetItemButtonTextureVertexColor(questItem, 1.0, 1.0, 1.0);
				SetItemButtonNameFrameVertexColor(questItem, 1.0, 1.0, 1.0);
			else
				SetItemButtonTextureVertexColor(questItem, 0.9, 0, 0);
				SetItemButtonNameFrameVertexColor(questItem, 0.9, 0, 0);
			end
			if ( i > 1 ) then
				if ( mod(i,2) == 1 ) then
					questItem:SetPoint("TOPLEFT", questItemName..(index - 2), "BOTTOMLEFT", 0, -2);
				else
					questItem:SetPoint("TOPLEFT", questItemName..(index - 1), "TOPRIGHT", 1, 0);
				end
			else
				questItem:SetPoint("TOPLEFT", itemChooseText, "BOTTOMLEFT", -3, -5);
			end
			rewardsCount = rewardsCount + 1;
		end
	else
		getglobal(questState.."ItemChooseText"):Hide();
	end
	
	-- Setup spell rewards
	if ( numQuestSpellRewards > 0 ) then
		local learnSpellText = getglobal(questState.."SpellLearnText");
		learnSpellText:Show();
		-- QuestFrame_SetTextColor(learnSpellText, material);
		QuestFrame_SetAsLastShown(learnSpellText, spacerFrame);

		--Anchor learnSpellText if there were choosable rewards
		if ( rewardsCount > 0 ) then
			learnSpellText:SetPoint("TOPLEFT", questItemName..rewardsCount, "BOTTOMLEFT", 3, -5);
		else
			learnSpellText:SetPoint("TOPLEFT", questState.."RewardTitleText", "BOTTOMLEFT", 0, -5);
		end

		if ( isQuestLog == 1 ) then
			texture, name, isTradeskillSpell = GetQuestLogRewardSpell();
		else
			texture, name, isTradeskillSpell = GetRewardSpell();
		end
		
		if ( isTradeskillSpell ) then
			learnSpellText:SetText(REWARD_TRADESKILL_SPELL);
		else
			learnSpellText:SetText(REWARD_SPELL);
		end
		
		rewardsCount = rewardsCount + 1;
		questItem = getglobal(questItemName..rewardsCount);
		questItem:Show();
		-- For the tooltip
		questItem.rewardType = "spell";
		SetItemButtonCount(questItem, 0);
		SetItemButtonTexture(questItem, texture);
		getglobal(questItemName..rewardsCount.."Name"):SetText(name);
		questItem:SetPoint("TOPLEFT", learnSpellText, "BOTTOMLEFT", -3, -5);
	else
		getglobal(questState.."SpellLearnText"):Hide();
	end
	
	-- Setup mandatory rewards
	if ( numQuestRewards > 0 or money > 0) then
		-- QuestFrame_SetTextColor(questItemReceiveText, material);
		-- Anchor the reward text differently if there are choosable rewards
		if ( numQuestSpellRewards > 0  ) then
			questItemReceiveText:SetText(TEXT(REWARD_ITEMS));
			questItemReceiveText:SetPoint("TOPLEFT", questItemName..rewardsCount, "BOTTOMLEFT", 3, -5);		
		elseif ( numQuestChoices > 0  ) then
			questItemReceiveText:SetText(TEXT(REWARD_ITEMS));
			local index = numQuestChoices;
			if ( mod(index, 2) == 0 ) then
				index = index - 1;
			end
			questItemReceiveText:SetPoint("TOPLEFT", questItemName..index, "BOTTOMLEFT", 3, -5);
		else 
			questItemReceiveText:SetText(TEXT(REWARD_ITEMS_ONLY));
			questItemReceiveText:SetPoint("TOPLEFT", questState.."RewardTitleText", "BOTTOMLEFT", 3, -5);
		end
		questItemReceiveText:Show();
		QuestFrame_SetAsLastShown(questItemReceiveText, spacerFrame);
		-- Setup mandatory rewards
		local index;
		local baseIndex = rewardsCount;
		for i=1, numQuestRewards, 1 do
			index = i + baseIndex;
			questItem = getglobal(questItemName..index);
			questItem.type = "reward";
			numItems = 1;
			if ( isQuestLog == 1 ) then
				name, texture, numItems, quality, isUsable = GetQuestLogRewardInfo(i);
			else
				name, texture, numItems, quality, isUsable = GetQuestItemInfo(questItem.type, i);
			end
			questItem:SetID(i)
			questItem:Show();
			-- For the tooltip
			questItem.rewardType = "item";
			QuestFrame_SetAsLastShown(questItem, spacerFrame);
			getglobal(questItemName..index.."Name"):SetText(name);
			SetItemButtonCount(questItem, numItems);
			SetItemButtonTexture(questItem, texture);
			if ( isUsable ) then
				SetItemButtonTextureVertexColor(questItem, 1.0, 1.0, 1.0);
				SetItemButtonNameFrameVertexColor(questItem, 1.0, 1.0, 1.0);
			else
				SetItemButtonTextureVertexColor(questItem, 0.5, 0, 0);
				SetItemButtonNameFrameVertexColor(questItem, 1.0, 0, 0);
			end
			
			if ( i > 1 ) then
				if ( mod(i,2) == 1 ) then
					questItem:SetPoint("TOPLEFT", questItemName..(index - 2), "BOTTOMLEFT", 0, -2);
				else
					questItem:SetPoint("TOPLEFT", questItemName..(index - 1), "TOPRIGHT", 1, 0);
				end
			else
				questItem:SetPoint("TOPLEFT", questState.."ItemReceiveText", "BOTTOMLEFT", -3, -5);
			end
			rewardsCount = rewardsCount + 1;
		end
	else	
		questItemReceiveText:Hide();
	end
	if ( questState == "QuestReward" ) then
		QuestFrameCompleteQuestButton:Enable();
		QuestFrameRewardPanel.itemChoice = 0;
		QuestRewardItemHighlight:Hide();
		HighlightRewardsFrame:Hide();
	end
end

function QuestFrameDetailPanel_OnShow()
	QuestFrameRewardPanel:Hide();
	QuestFrameProgressPanel:Hide();
	QuestFrameGreetingPanel:Hide();
	local material = QuestFrame_GetMaterial();
	QuestFrame_SetMaterial(QuestFrameDetailPanel, material);
	QuestTitleText:SetText(GetTitleText());
	-- QuestFrame_SetTitleTextColor(QuestTitleText, material);
	QuestDescription:SetText(GetQuestText());
	-- QuestFrame_SetTextColor(QuestDescription, material);
	-- QuestFrame_SetTitleTextColor(QuestDetailObjectiveTitleText, material);
	QuestObjectiveText:SetText(GetObjectiveText());
	
	-- QuestFrame_SetTextColor(QuestObjectiveText, material);
	QuestFrame_SetAsLastShown(QuestObjectiveText, QuestSpacerFrame);
	QuestFrameItems_Update("QuestDetail");
	-- QuestObjectiveTextFrame:Show()
	QuestDetailScrollFrame:UpdateScrollChildRect();
	QuestDetailScrollFrameScrollBar:SetValue(0);

	-- Hide Objectives and rewards until the text is completely displayed
	TextAlphaDependentFrame:SetAlpha(0);
	QuestFrameAcceptButton:Disable();

	QuestFrameDetailPanel.fading = 1;
	QuestFrameDetailPanel.fadingProgress = 0;
	QuestDescription:SetAlphaGradient(0, QUEST_DESCRIPTION_GRADIENT_LENGTH);
	if ( QUEST_FADING_DISABLE == "1" ) then
		QuestFrameDetailPanel.fadingProgress = 1024;
	end
end

function QuestFrameDetailPanel_OnUpdate(elapsed)
	if ( this.fading ) then
		this.fadingProgress = this.fadingProgress + (elapsed * QUEST_DESCRIPTION_GRADIENT_CPS);
		PlaySound("WriteQuest");
		if ( not QuestDescription:SetAlphaGradient(this.fadingProgress, QUEST_DESCRIPTION_GRADIENT_LENGTH) ) then
			this.fading = nil;
			-- Show Quest Objectives and Rewards
			if ( QUEST_FADING_DISABLE == "0" ) then
				UIFrameFadeIn(TextAlphaDependentFrame, QUESTINFO_FADE_IN );
			else
				TextAlphaDependentFrame:SetAlpha(1);
			end
			QuestFrameAcceptButton:Enable();
		end
	end
end

function QuestDetailAcceptButton_OnClick()
	AcceptQuest();
end

function QuestDetailDeclineButton_OnClick()
	DeclineQuest();
	PlaySound("igQuestCancel");
end

function QuestFrame_SetMaterial(frame, material)
	if ( material == "Parchment" ) then
		getglobal(frame:GetName().."MaterialTopLeft"):Hide();
		getglobal(frame:GetName().."MaterialTopRight"):Hide();
		getglobal(frame:GetName().."MaterialBotLeft"):Hide();
		getglobal(frame:GetName().."MaterialBotRight"):Hide();
	else
		getglobal(frame:GetName().."MaterialTopLeft"):Show();
		getglobal(frame:GetName().."MaterialTopRight"):Show();
		getglobal(frame:GetName().."MaterialBotLeft"):Show();
		getglobal(frame:GetName().."MaterialBotRight"):Show();
		getglobal(frame:GetName().."MaterialTopLeft"):SetTexture("Interface\\ItemTextFrame\\ItemText-"..material.."-TopLeft");
		getglobal(frame:GetName().."MaterialTopRight"):SetTexture("Interface\\ItemTextFrame\\ItemText-"..material.."-TopRight");
		getglobal(frame:GetName().."MaterialBotLeft"):SetTexture("Interface\\ItemTextFrame\\ItemText-"..material.."-BotLeft");
		getglobal(frame:GetName().."MaterialBotRight"):SetTexture("Interface\\ItemTextFrame\\ItemText-"..material.."-BotRight");
	end
end

function QuestFrame_GetMaterial()
	local material = GetQuestBackgroundMaterial();
	if ( not material ) then
		material = "Parchment";
	end
	return material;
end

function QuestFrame_SetTitleTextColor(fontString, material)
	local temp, materialTitleTextColor = GetMaterialTextColors(material);
	-- fontString:SetTextColor(materialTitleTextColor[1], materialTitleTextColor[2], materialTitleTextColor[3]);
end

function QuestFrame_SetTextColor(fontString, material)
	local materialTextColor = GetMaterialTextColors(material);
	-- fontString:SetTextColor(materialTextColor[1], materialTextColor[2], materialTextColor[3]);
end