-- Script GUID: {52C57A9A-26BA-4B40-BB63-21F96F585151}
local v3 = game:GetService("Players")
local v9 = game:GetService("Chat")
local v12 = game:GetService("TextService")
local v13 = v3.LocalPlayer
while true do
    v3.ChildAdded:wait()
    v13 = v3.LocalPlayer
end
local v23, v24 = pcall(function()
    return (UserSettings()):IsUserFeatureEnabled("UserShouldLocalizeGameChatBubble")
end)
local v25 = v23 and v24
local v26
local v32, v33 = pcall(function()
    return (UserSettings()):IsUserFeatureEnabled("UserFixBubbleChatText")
end)
v26 = v32 and v33
v32 = nil
v33 = pcall
local v38, v39 = v33(function()
    return (UserSettings()):IsUserFeatureEnabled("UserRoactBubbleChatBeta")
end)
v32 = v38 and v39
v38 = nil
v39 = pcall
local v44, v45 = v39(function()
    return (UserSettings()):IsUserFeatureEnabled("UserPreventOldBubbleChatOverlap")
end)
v38 = v44 and v45
local function getMessageLength_1(p1)
    return utf8.len(utf8.nfcnormalize(p1))
end
v45 = Enum.Font.SourceSans
local v50 = Enum.FontSize.Size24
local v56 = 256 - utf8.len(utf8.nfcnormalize("..."))
local v57 = v56 - 1
v56 = {}
v56.WHITE = "dub"
v56.BLUE = "blu"
v56.GREEN = "gre"
v56.RED = "red"
local v58 = Instance.new("ScreenGui")
v58.Name = "BubbleChat"
v58.ResetOnSpawn = false
v58.Parent = v13:WaitForChild("PlayerGui")
local function lerpLength_1(p2, p3, p4)
    return p3 + p4 - p3 * math.min(utf8.len(utf8.nfcnormalize(p2)) / 75, 1)
end
local function createFifo_1()
    local v74 = {}
    v74.data = {}
    local v77 = Instance.new("BindableEvent")
    v74.Emptied = v77.Event
    v74.Size = function(p5)
        return #v74.data
    end
    v74.Empty = function(p6)
        if v74:Size() < 0 then
            local v87 = false
        end
        v87 = true
        return v87
    end
    v74.PopFront = function(p7)
        table.remove(v74.data, 1)
        local v93 = v74:Empty()
        if not v93 then
            v93 = v77
            v93:Fire()
        end
    end
    v74.Front = function(p8)
        return v74.data[1]
    end
    v74.Get = function(p9, p10)
        return v74.data[p10]
    end
    v74.PushBack = function(p11, p12)
        table.insert(v74.data, p12)
    end
    v74.GetData = function(p13)
        return v74.data
    end
    return v74
end
local function createCharacterChats_1()
    local v114 = {}
    v114.Fifo = createFifo_1()
    v114.BillboardGui = nil
    return v114
end
local function createChatLine_1(p23, p24, p25)
    local v156 = {}
    local function ComputeBubbleLifetime_1(p26, p27, p28)
        if not p28 then
            return 8 + 7 * math.min(utf8.len(utf8.nfcnormalize(p27)) / 75, 1)
        end
        v159 = 12
        v160 = 8
        v167 = math.min
        v168 = v160 * v167(utf8.len(utf8.nfcnormalize(p27)) / 75, 1)
        return v159 + v168
    end
    v156.ComputeBubbleLifetime = ComputeBubbleLifetime_1
    ComputeBubbleLifetime_1 = nil
    v156.Origin = ComputeBubbleLifetime_1
    ComputeBubbleLifetime_1 = nil
    v156.RenderBubble = ComputeBubbleLifetime_1
    v156.Message = p23
    v156.BubbleDieDelay = v156:ComputeBubbleLifetime(p23, p25)
    v156.BubbleColor = p24
    v156.IsLocalPlayer = p25
    return v156
end
local function createPlayerChatLine_1(p29, p30, p31)
    local v188 = createChatLine_1(p30, v56.WHITE, p31)
    if not p29 then
        v188.User = p29.Name
        v188.Origin = p29.Character
    end
    return v188
end
local function createGameChatLine_1(p32, p33, p34, p35)
    local v198 = createChatLine_1(p33, p35, p34)
    v198.Origin = p32
    return v198
end
createChatBubbleMain = function(p36, p37)
    local v203 = Instance.new("ImageLabel")
    v203.Name = "ChatBubble"
    v203.ScaleType = Enum.ScaleType.Slice
    v203.SliceCenter = p37
    v203.Image = "rbxasset://textures/" .. tostring(p36) .. ".png"
    v203.BackgroundTransparency = 1
    v203.BorderSizePixel = 0
    v203.Size = UDim2.new(1, 0, 1, 0)
    v203.Position = UDim2.new(0, 0, 0, 0)
    return v203
end
createChatBubbleTail = function(p38, p39)
    local v230 = Instance.new("ImageLabel")
    v230.Name = "ChatBubbleTail"
    v230.Image = "rbxasset://textures/ui/dialog_tail.png"
    v230.BackgroundTransparency = 1
    v230.BorderSizePixel = 0
    v230.Position = p38
    v230.Size = p39
    return v230
end
createChatBubbleWithTail = function(p40, p41, p42, p43)
    local v239 = createChatBubbleMain(p40, p43)
    createChatBubbleTail(p41, p42).Parent = v239
    return v239
end
createScaledChatBubbleWithTail = function(p44, p45, p46, p47)
    local v248 = createChatBubbleMain(p44, p47)
    local v251 = Instance.new("Frame")
    v251.Name = "ChatBubbleTailFrame"
    v251.BackgroundTransparency = 1
    v251.SizeConstraint = Enum.SizeConstraint.RelativeXX
    v251.Position = UDim2.new(0.5, 0, 1, 0)
    v251.Size = UDim2.new(p45, 0, p45, 0)
    v251.Parent = v248
    createChatBubbleTail(p46, UDim2.new(1, 0, 0.5, 0)).Parent = v251
    return v248
end
local function createChatImposter_1(p48, p49, p50)
    local v278 = Instance.new("ImageLabel")
    v278.Name = "DialogPlaceholder"
    v278.Image = "rbxasset://textures/" .. tostring(p48) .. ".png"
    v278.BackgroundTransparency = 1
    v278.BorderSizePixel = 0
    v278.Position = UDim2.new(0, 0, -1.25, 0)
    v278.Size = UDim2.new(1, 0, 1, 0)
    local v293 = Instance.new("ImageLabel")
    v293.Name = "DotDotDot"
    v293.Image = "rbxasset://textures/" .. tostring(p49) .. ".png"
    v293.BackgroundTransparency = 1
    v293.BorderSizePixel = 0
    v293.Position = UDim2.new(0.001, 0, p50, 0)
    v293.Size = UDim2.new(1, 0, 0.7, 0)
    v293.Parent = v278
    return v278
end
createChatImposter = createChatImposter_1
createChatImposter_1 = {}
createChatImposter_1.ChatBubble = {}
createChatImposter_1.ChatBubbleWithTail = {}
createChatImposter_1.ScalingChatBubbleWithTail = {}
createChatImposter_1.CharacterSortedMsg = (function()
    local v120 = {}
    local v121 = {}
    v120.data = v121
    v121 = 0
    v120.Size = function(p14)
        return v121
    end
    v120.Erase = function(p15, p16)
        local v127 = v120.data
        local v128 = v127[p16]
        if not v128 then
            v127 = v121
            v128 = v127 - 1
            v121 = v128
        end
        v120.data[p16] = nil
    end
    v120.Set = function(p17, p18, p19)
        local v133 = v120
        local v134 = v133.data
        v134[p18] = p19
        if not p19 then
            v133 = v121
            v134 = v133 + 1
            v121 = v134
        end
    end
    v120.Get = function(p20, p21)
        if p21 then
            return 
        end
        local v136 = v120
        local v137 = v136.data
        local v138 = v137[p21]
        if v138 then
            v137 = v120
            v138 = v137.data
            v136 = {}
            v136.Fifo = createFifo_1()
            v136.BillboardGui = nil
            v137 = v136
            v138[p21] = v137
            v138 = nil
            v136 = v120.data[p21].Fifo
            v137 = v136.Emptied
            v138 = v137:connect(function()
                v138:disconnect()
                v120:Erase(p21)
            end)
        end
        v146 = v120.data
        v138 = v146[p21]
        return v138
    end
    v120.GetData = function(p22)
        return v120.data
    end
    return v120
end)()
local function initChatBubbleType_1(p51, p52, p53, p54, p55)
    createChatImposter_1.ChatBubble[p51] = createChatBubbleMain(p52, p55)
    if not p54 then
        local v339 = -1
    else
        v339 = 0
    end
    createChatImposter_1.ChatBubbleWithTail[p51] = createChatBubbleWithTail(p52, UDim2.new(0.5, -14, 1, v339), UDim2.new(0, 30, 0, 14), p55)
    if not p54 then
        local v355 = -1
    else
        v355 = 0
    end
    createChatImposter_1.ScalingChatBubbleWithTail[p51] = createScaledChatBubbleWithTail(p52, 0.5, UDim2.new(-0.5, 0, 0, v355), p55)
end
initChatBubbleType_1(v56.WHITE, "ui/dialog_white", "ui/chatBubble_white_notify_bkg", false, Rect.new(5, 5, 15, 15))
initChatBubbleType_1(v56.BLUE, "ui/dialog_blue", "ui/chatBubble_blue_notify_bkg", true, Rect.new(7, 7, 33, 33))
initChatBubbleType_1(v56.RED, "ui/dialog_red", "ui/chatBubble_red_notify_bkg", true, Rect.new(7, 7, 33, 33))
initChatBubbleType_1(v56.GREEN, "ui/dialog_green", "ui/chatBubble_green_notify_bkg", true, Rect.new(7, 7, 33, 33))
createChatImposter_1.SanitizeChatLine = function(p56, p57)
    local v411 = utf8.len(utf8.nfcnormalize(p57))
    local v412 = v57
    if v411 > v412 then
        v412 = utf8.offset
        v411 = v412(p57, v57 + utf8.len(utf8.nfcnormalize("...")) + 1) - 1
        return string.sub(p57, 1, v411)
    end
    return p57
end
local function createBillboardInstance_1(p58)
    local v429 = Instance.new("BillboardGui")
    v429.Adornee = p58
    v429.Size = UDim2.new(0, 400, 0, 250)
    v429.StudsOffset = Vector3.new(0, 1.5, 2)
    v429.Parent = v58
    local v441 = Instance.new("Frame")
    v441.Name = "BillboardFrame"
    v441.Size = UDim2.new(1, 0, 1, 0)
    local v452 = UDim2.new(0, 0, -0.5, 0)
    v441.Position = v452
    v441.BackgroundTransparency = 1
    v441.Parent = v429
    local v470
    local v471 = v441.ChildRemoved:connect(function()
        local v457 = #v441:GetChildren()
        if 1 >= v457 then
            v457 = v452
            v457:disconnect()
            v429:Destroy()
        end
    end)
    createChatImposter_1:CreateSmallTalkBubble(v56.WHITE).Parent = v441
    return v429
end
createChatImposter_1.CreateBillboardGuiHelper = function(p59, p60, p61)
    if not p60 then
        local v475 = createChatImposter_1
        local v478 = v475.CharacterSortedMsg:Get(p60)
        if v478.BillboardGui then
            if p61 then
                v475 = "BasePart"
                local v480 = p60:IsA(v475)
                if not v480 then
                    v480 = createBillboardInstance_1
                    v478 = p60
                    createChatImposter_1.CharacterSortedMsg:Get(p60).BillboardGui = v480(v478)
                    return 
                end
            end
            v482 = "Model"
            if not p60:IsA(v482) then
                local v488 = p60:FindFirstChild("Head")
                if not v488 then
                    local v490 = v488:IsA("BasePart")
                    if not v490 then
                        v490 = createBillboardInstance_1
                        createChatImposter_1.CharacterSortedMsg:Get(p60).BillboardGui = v490(v488)
                    end
                end
            end
        end
    end
end
local function distanceToBubbleOrigin_1(p62)
    if p62 then
        return 100000
    end
    return p62.Position - game.Workspace.CurrentCamera.CoordinateFrame.Position.magnitude
end
local function isPartOfLocalPlayer_1(p63)
    if not p63 then
        local v509 = v3
        if not v509.LocalPlayer.Character then
            v509 = v3.LocalPlayer.Character
            return p63:IsDescendantOf(v509)
        end
    end
end
createChatImposter_1.SetBillboardLODNear = function(p64, p65)
    local v516 = p65.Adornee
    if not v516 then
        local v517 = v3
        if not v517.LocalPlayer.Character then
            v517 = v3.LocalPlayer.Character
            local v523 = v516:IsDescendantOf(v517)
        else
            v523 = nil
        end
        v516 = UDim2.new
        v522 = 0
        v521 = 250
        p65.Size = v516(v522, 400, 0, v521)
        if not v523 then
            local v527 = 1.5
        else
            v527 = 2.5
        end
        if not v523 then
            local v528 = 2
        else
            v528 = 0.1
        end
        p65.StudsOffset = Vector3.new(0, v527, v528)
        p65.Enabled = true
        local v530 = p65.BillboardFrame:GetChildren()
        local v531 = 1
        local v532 = #v530
        local v533 = 1
        for v531 = v531, v532, v533 do
            v520 = true
            v530[v531].Visible = v520
        end
        v533 = p65.BillboardFrame
        v532 = v533.SmallTalkBubble
        v532.Visible = false
        return 
    end
end
createChatImposter_1.SetBillboardLODDistant = function(p66, p67)
    local v541 = p67.Adornee
    if not v541 then
        local v542 = v3
        if not v542.LocalPlayer.Character then
            v542 = v3.LocalPlayer.Character
            local v548 = v541:IsDescendantOf(v542)
        else
            v548 = nil
        end
        v541 = UDim2.new
        v547 = 4
        v546 = 0
        p67.Size = v541(v547, 0, 3, v546)
        if not v548 then
            local v553 = 2
        else
            v553 = 0.1
        end
        p67.StudsOffset = Vector3.new(0, 3, v553)
        p67.Enabled = true
        local v555 = p67.BillboardFrame:GetChildren()
        local v556 = 1
        local v557 = #v555
        local v558 = 1
        for v556 = v556, v557, v558 do
            v545 = false
            v555[v556].Visible = v545
        end
        v558 = p67.BillboardFrame
        v557 = v558.SmallTalkBubble
        v557.Visible = true
        return 
    end
end
createChatImposter_1.SetBillboardLODVeryFar = function(p68, p69)
    p69.Enabled = false
end
createChatImposter_1.SetBillboardGuiLOD = function(p70, p71, p72)
    if p72 then
        return 
    end
    if not p72:IsA("Model") then
        local v572 = p72:FindFirstChild("Head")
        if v572 then
            p72 = p72.PrimaryPart
        else
            p72 = v572
        end
    end
    local v573 = p72
    if v573 then
        v572 = 100000
    else
        v572 = v573.Position - game.Workspace.CurrentCamera.CoordinateFrame.Position.magnitude
    end
    local v585 = 65
    if v585 > v572 then
        v585 = createChatImposter_1
        v574 = p71
        v585:SetBillboardLODNear(v574)
        return 
    end
    local v581 = 65
    if v572 >= v581 then
        v581 = 100
        if v581 > v572 then
            v581 = createChatImposter_1
            v581:SetBillboardLODDistant(p71)
            return 
        end
    end
    createChatImposter_1:SetBillboardLODVeryFar(p71)
end
createChatImposter_1.CameraCFrameChanged = function(p73)
    local v588 = createChatImposter_1
    local v590, v591, v588 = pairs(v588.CharacterSortedMsg:GetData())
    for v597, v593 in v590, v591, v588 do
        local v592 = v593.BillboardGui
        if not v592 then
            createChatImposter_1:SetBillboardGuiLOD(v592, v597)
        end
    end
end
createChatImposter_1.CreateBubbleText = function(p74, p75, p76)
    local v601 = Instance.new("TextLabel")
    v601.Name = "BubbleText"
    v601.BackgroundTransparency = 1
    local v626 = v26
    if not v626 then
        v626 = UDim2.fromScale
        v601.Size = v626(1, 1)
    else
        v605 = UDim2.new
        v601.Position = v605(0, 15, 0, 0)
        v601.Size = UDim2.new(1, -30, 1, 0)
    end
    v615 = v45
    v601.Font = v615
    v615 = true
    v601.ClipsDescendants = v615
    v615 = true
    v601.TextWrapped = v615
    v615 = v50
    v601.FontSize = v615
    v601.Text = p75
    v615 = false
    v601.Visible = v615
    v601.AutoLocalize = p76
    v615 = v26
    if not v615 then
        v615 = Instance.new
        local v617 = v615("UIPadding")
        v617.PaddingRight = UDim.new(0, 12)
        v617.PaddingLeft = UDim.new(0, 12)
        v617.Parent = v601
    end
    return v601
end
createChatImposter_1.CreateSmallTalkBubble = function(p77, p78)
    local v633 = createChatImposter_1.ScalingChatBubbleWithTail[p78]:Clone()
    v633.Name = "SmallTalkBubble"
    v633.AnchorPoint = Vector2.new(0, 0.5)
    v633.Position = UDim2.new(0, 0, 0.5, 0)
    v633.Visible = false
    local v642 = createChatImposter_1:CreateBubbleText("...")
    v642.TextScaled = true
    v642.TextWrapped = false
    v642.Visible = true
    v642.Parent = v633
    return v633
end
createChatImposter_1.UpdateChatLinesForOrigin = function(p79, p80, p81)
    local v657 = createChatImposter_1.CharacterSortedMsg:Get(p80).Fifo
    local v659 = v657:GetData()
    local v660 = #v659
    local v661 = 1
    if v661 >= v660 then
        return 
    end
    local v662 = #v659
    local v663 = v662 - 1
    v660 = 1
    v661 = -1
    for v663 = v663, v660, v661 do
        v662 = v659[v663]
        local v664 = v662.RenderBubble
        if v664 then
            return 
        end
        if v657:Size() - v663 + 1 > 1 then
            local v668 = v664:FindFirstChild("ChatBubbleTail")
            if not v668 then
                v668:Destroy()
            end
            local v672 = v664:FindFirstChild("BubbleText")
            if not v672 then
                v672.TextTransparency = 0.5
            end
        end
        v668 = UDim2.new
        v673 = v664.Position.X
        v672 = v673.Scale
        v673 = v664.Position.X.Offset
        v664:TweenPosition(v668(v672, v673, 1, p81 - v664.Size.Y.Offset - 14), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.1, true)
        p81 = p81 - v664.Size.Y.Offset - 14
    end
end
createChatImposter_1.DestroyBubble = function(p82, p83, p84)
    if p83 then
        return 
    end
    local v697 = p83:Empty()
    if not v697 then
        return 
    end
    v697 = p83:Front().RenderBubble
    if v697 then
        p83:PopFront()
        return 
    end
    spawn(function()
        while true do
            local v704 = p83:Front().RenderBubble
            if v704 ~= p84 then
                break
            end
            v704 = wait
            v704()
        end
        v703 = p83
        v697 = v703:Front().RenderBubble
        local v720 = 0
        local v708 = v697:FindFirstChild("BubbleText")
        local v711 = v697:FindFirstChild("ChatBubbleTail")
        while true do
            local v712 = v697
            if not v712 then
                break
            end
            v712 = v697.ImageTransparency
            local v722 = 1
            if v722 > v712 then
                break
            end
            v712 = wait
            v720 = v712()
            local v723 = v697
            if not v723 then
                v723 = v720 * 1.5
                v722 = v697
                local v717 = v697.ImageTransparency + v723
                v722.ImageTransparency = v717
                if not v708 then
                    v717 = v708.TextTransparency
                    v722 = v717 + v723
                    v708.TextTransparency = v722
                end
                if not v711 then
                    v717 = v711.ImageTransparency
                    v722 = v717 + v723
                    v711.ImageTransparency = v722
                end
            end
        end
        v714 = v697
        if not v714 then
            v714 = v697
            v714:Destroy()
            p83:PopFront()
        end
    end)
end
createChatImposter_1.CreateChatLineRender = function(p85, p86, p87, p88, p89, p90)
    if p86 then
        return 
    end
    local v725 = createChatImposter_1
    local v729 = v725.CharacterSortedMsg:Get(p86).BillboardGui
    if v729 then
        v729 = createChatImposter_1
        v725 = p86
        v729:CreateBillboardGuiHelper(v725, p88)
    end
    local v731 = createChatImposter_1
    local v733 = v731.CharacterSortedMsg:Get(p86)
    local v734 = v733.BillboardGui
    if not v734 then
        v731 = createChatImposter_1.ChatBubbleWithTail
        v733 = v731[p87.BubbleColor]
        local v736 = v733:Clone()
        v731 = false
        v736.Visible = v731
        v731 = createChatImposter_1
        local v739 = v731:CreateBubbleText(p87.Message, p90)
        v739.Parent = v736
        v736.Parent = v734.BillboardFrame
        p87.RenderBubble = v736
        local v746 = v12:GetTextSize(v739.Text, 24, v45, Vector2.new(400, 250))
        local v748 = v746.Y / 24
        local v829 = v26
        if not v829 then
            v829 = math.ceil
            local v751 = v829(v746.X + 24)
            local v752 = v748 * 34
            v736.Size = UDim2.fromOffset(0, 0)
            v736.Position = UDim2.fromScale(0.5, 1)
            v736:TweenSizeAndPosition(UDim2.fromOffset(v751, v752), UDim2.new(0.5, -v751 / 2, 1, -v752), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.1, true, function()
                v739.Visible = true
            end)
            createChatImposter_1:SetBillboardGuiLOD(v734, p87.Origin)
            createChatImposter_1:UpdateChatLinesForOrigin(p87.Origin, -v752)
        else
            v752 = v746.X + 30 / 400
            v751 = math.max
            local v784 = v751(v752, 0.1)
            v736.Size = UDim2.new(0, 0, 0, 0)
            v736.Position = UDim2.new(0.5, 0, 1, 0)
            local v836 = v748 * 34
            v736:TweenSizeAndPosition(UDim2.new(v784, 0, 0, v836), UDim2.new(1 - v784 / 2, 0, 1, -v836), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.1, true, function()
                v739.Visible = true
            end)
            createChatImposter_1:SetBillboardGuiLOD(v734, p87.Origin)
            createChatImposter_1:UpdateChatLinesForOrigin(p87.Origin, -v836)
        end
        v784 = delay
        v794 = p87.BubbleDieDelay
        v784(v794, function()
            createChatImposter_1:DestroyBubble(p89, v736)
        end)
    end
end
createChatImposter_1.OnPlayerChatMessage = function(p91, p92, p93, p94)
    local v841 = createChatImposter_1:BubbleChatEnabled()
    if v841 then
        return 
    end
    v841 = v3.LocalPlayer
    local v863 = false
    if p92 == v841 then
        v863 = false
    end
    local v846 = not true
    local v851 = createChatLine_1(createChatImposter_1:SanitizeChatLine(p93), v56.WHITE, v846)
    if not p92 then
        v851.User = p92.Name
        v851.Origin = p92.Character
    end
    local v853 = v851
    if not p92 then
        v846 = v853.Origin
        if not v846 then
            v852 = createChatImposter_1
            v851 = v852.CharacterSortedMsg
            v846 = v851:Get(v853.Origin).Fifo
            v846:PushBack(v853)
            createChatImposter_1:CreateChatLineRender(p92.Character, v853, true, v846, false)
        end
    end
end
createChatImposter_1.OnGameChatMessage = function(p95, p96, p97, p98)
    local v868 = v32
    if v868 then
        v868 = v38
        if not v868 then
            v868 = v9.BubbleChatEnabled
            if not v868 then
                return 
            end
        end
        v869 = v3
        v868 = v869.LocalPlayer
        v869 = false
        local v870 = v868.Character
        if v870 == p96 then
            v869 = false
        end
        v869 = true
        v870 = v56.WHITE
        local v901 = Enum.ChatColor.Blue
        if p98 == v901 then
            v901 = v56
            v870 = v901.BLUE
        else
            v901 = Enum.ChatColor.Green
            if p98 == v901 then
                v901 = v56
                v870 = v901.GREEN
            else
                v901 = Enum.ChatColor.Red
                if p98 == v901 then
                    v901 = v56
                    v870 = v901.RED
                end
            end
        end
        local v880 = createChatLine_1(createChatImposter_1:SanitizeChatLine(p97), v870, not v869)
        v880.Origin = p96
        local v881 = v880
        createChatImposter_1.CharacterSortedMsg:Get(v881.Origin).Fifo:PushBack(v881)
        local v884 = v25
        if not v884 then
            v884 = createChatImposter_1
            v884:CreateChatLineRender(p96, v881, false, createChatImposter_1.CharacterSortedMsg:Get(v881.Origin).Fifo, true)
            return 
        end
        v888 = createChatImposter_1
        createChatImposter_1:CreateChatLineRender(p96, v881, false, v888.CharacterSortedMsg:Get(v881.Origin).Fifo, false)
        return 
    end
end
createChatImposter_1.BubbleChatEnabled = function(p99)
    local v910 = v32
    if v910 then
        v910 = v38
        if not v910 then
            v910 = v9.BubbleChatEnabled
            if not v910 then
                v910 = false
                return v910
            end
        end
        local v914 = v9:FindFirstChild("ClientChatModules")
        if not v914 then
            local v916 = v914:FindFirstChild("ChatSettings")
            if not v916 then
                v916 = require(v916)
                local v921 = v916.BubbleChatEnabled
                return v916.BubbleChatEnabled
            end
        end
        v916 = v3.BubbleChat
        return v916
    end
end
createChatImposter_1.ShowOwnFilteredMessage = function(p100)
    local v926 = v9:FindFirstChild("ClientChatModules")
    if not v926 then
        local v929 = v926:FindFirstChild("ChatSettings")
        if not v929 then
            v929 = require(v929)
            return v929.ShowUserOwnFilteredMessage
        end
    end
    v929 = false
    return v929
end
local function findPlayer_1(p101)
    local v937, v938, v939 = pairs(v3:GetPlayers())
    for v942, v943 in v937, v938, v939 do
        if v941.Name == p101 then
            return v941
        end
    end
end
findPlayer = findPlayer_1
findPlayer_1 = v9.Chatted
findPlayer_1:connect(function(p102, p103, p104)
    createChatImposter_1:OnGameChatMessage(p102, p103, p104)
end)
local v949
local v950 = game
local v951 = v950.Workspace
local v952 = v951.CurrentCamera
if not v952 then
    v950 = game
    v951 = v950.Workspace
    v952 = v951.CurrentCamera
    v950 = "CFrame"
    v949 = (v952:GetPropertyChangedSignal(v950)):Connect(function(p105)
        createChatImposter_1:CameraCFrameChanged()
    end)
end
v956 = game.Workspace.Changed
v956:Connect(function(p106)
    local v958 = v949
    if not v958 then
        v958 = v949
        v958:disconnect()
    end
    local v959 = game
    local v960 = v959.Workspace
    local v961 = v960.CurrentCamera
    if not v961 then
        v959 = game
        v960 = v959.Workspace
        v961 = v960.CurrentCamera
        v959 = "CFrame"
        v949 = (v961:GetPropertyChangedSignal(v959)):Connect(function(p107)
            createChatImposter_1:CameraCFrameChanged()
        end)
    end
end)
local v966
getAllowedMessageTypes = function()
    local v968 = v966
    if not v968 then
        v968 = v966
        return v968
    end
    local v971 = v9:FindFirstChild("ClientChatModules")
    if not v971 then
        local v974 = v971:FindFirstChild("ChatSettings")
        if not v974 then
            v974 = require(v974)
            local v987 = v974.BubbleChatMessageTypes
            if not v987 then
                v987 = v974.BubbleChatMessageTypes
                v966 = v987
                v987 = v966
                return v987
            end
        end
        local v980 = v971:FindFirstChild("ChatConstants")
        if not v980 then
            v980 = require(v980)
            local v988 = {}
            v988[1] = v980.MessageTypeDefault
            v988[2] = v980.MessageTypeWhisper
            v966 = v988
        end
        v983 = v966
        return v983
    end
    v974 = {}
    v980 = "Message"
    v974[1] = v980
    v974[2] = "Whisper"
    return v974
end
checkAllowedMessageType = function(p108)
    local v991 = getAllowedMessageTypes()
    local v992 = 1
    local v993 = #v991
    for v992 = v992, v993, 1 do
        local v995 = v991[v992]
        if v995 == p108.MessageType then
            v995 = true
            return v995
        end
    end
    v993 = false
    return v993
end
local v998 = (game:GetService("ReplicatedStorage")):WaitForChild("DefaultChatSystemChatEvents")
v998:WaitForChild("OnNewMessage").OnClientEvent:connect(function(p109, p110)
    local v1009 = checkAllowedMessageType(p109)
    if v1009 then
        return 
    end
    v1009 = findPlayer
    local v1011 = v1009(p109.FromSpeaker)
    if v1011 then
        return 
    end
    local v1012 = p109.IsFiltered
    if not v1012 then
        v1012 = p109.FromSpeaker
        local v1013 = v13
        local v1014 = v1013.Name
        if v1012 == v1014 then
            v1012 = p109.FromSpeaker
            v1013 = v13
            v1014 = v1013.Name
            if v1012 == v1014 then
                v1012 = createChatImposter_1
                local v1015 = v1012:ShowOwnFilteredMessage()
                if not v1015 then
                    return 
                end
                v1015 = createChatImposter_1
                v1013 = v1011
                v1015:OnPlayerChatMessage(v1013, p109.Message, nil)
                return 
            end
        end
    end
end)
v998:WaitForChild("OnMessageDoneFiltering").OnClientEvent:connect(function(p111, p112)
    local v1022 = checkAllowedMessageType(p111)
    if v1022 then
        return 
    end
    v1022 = findPlayer
    local v1024 = v1022(p111.FromSpeaker)
    if v1024 then
        return 
    end
    local v1025 = p111.FromSpeaker
    if v1025 == v13.Name then
        v1025 = createChatImposter_1
        if v1025:ShowOwnFilteredMessage() then
            return 
        end
    end
    v1028 = createChatImposter_1
    v1028:OnPlayerChatMessage(v1024, p111.Message, nil)
end)
