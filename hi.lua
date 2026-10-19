-- الخدمات الأساسية
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- إزالة أي واجهة سابقة لمنع التكرار
if CoreGui:FindFirstChild("TimebombProGUI") then
    CoreGui.TimebombProGUI:Destroy()
end

-- إنشاء الواجهة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TimebombProGUI"
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
ScreenGui.IgnoreGuiInset = true

-- خلفية القائمة الرئيسية (تغطي الشاشة بتعتيم فخم)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
MainFrame.BackgroundTransparency = 0.5
MainFrame.Parent = ScreenGui

-- نافذة الخيارات المركزية بتصميم احترافي (Glassmorphism & Modern Dark)
local CenterBox = Instance.new("Frame")
CenterBox.Size = UDim2.new(0, 400, 0, 260)
CenterBox.Position = UDim2.new(0.5, -200, 0.5, -130)
CenterBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
CenterBox.BorderSizePixel = 0
CenterBox.Parent = MainFrame

local BoxCorner = Instance.new("UICorner", CenterBox)
BoxCorner.CornerRadius = UDim.new(0, 16)

local UIStroke = Instance.new("UIStroke", CenterBox)
UIStroke.Color = Color3.fromRGB(70, 130, 255)
UIStroke.Thickness = 1.5

-- عنوان القائمة الاحترافي
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Text = "TIMEBOMB • CONTROLLER"
Title.TextColor3 = Color3.fromRGB(240, 240, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = CenterBox

-- زر إخفاء الرأس ورجل (تصميم احترافي)
local QualityBtn = Instance.new("TextButton")
QualityBtn.Size = UDim2.new(0, 340, 0, 50)
QualityBtn.Position = UDim2.new(0.5, -170, 0.32, 0)
QualityBtn.Text = "اخفاء الراس ورجل"
QualityBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
QualityBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
QualityBtn.TextSize = 15
QualityBtn.Font = Enum.Font.GothamSemibold
QualityBtn.Parent = CenterBox
Instance.new("UICorner", QualityBtn).CornerRadius = UDim.new(0, 10)
local stroke1 = Instance.new("UIStroke", QualityBtn)
stroke1.Color = Color3.fromRGB(50, 50, 60)
stroke1.Thickness = 1

-- زر الأوتو (تصميم احترافي)
local AutoBtn = Instance.new("TextButton")
AutoBtn.Size = UDim2.new(0, 340, 0, 50)
AutoBtn.Position = UDim2.new(0.5, -170, 0.58, 0)
AutoBtn.Text = "الأوتو"
AutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
AutoBtn.TextSize = 15
AutoBtn.Font = Enum.Font.GothamSemibold
AutoBtn.Parent = CenterBox
Instance.new("UICorner", AutoBtn).CornerRadius = UDim.new(0, 10)
local stroke2 = Instance.new("UIStroke", AutoBtn)
stroke2.Color = Color3.fromRGB(50, 50, 60)
stroke2.Thickness = 1

-- متغيرات التحكم
local autoEnabled = false
local floatingAutoBtn = nil

-- دالة لإخفاء القائمة الكبيرة بسلاسة تامة
local function fadeOutAndDestroy()
    task.spawn(function()
        for i = 0, 1, 0.1 do
            MainFrame.BackgroundTransparency = 0.5 + (0.5 * i)
            CenterBox.BackgroundTransparency = i
            Title.TextTransparency = i
            QualityBtn.TextTransparency = i
            QualityBtn.BackgroundTransparency = i
            AutoBtn.TextTransparency = i
            AutoBtn.BackgroundTransparency = i
            task.wait(0.02)
        end
        MainFrame.Visible = false
    end)
end

-- تفعيل ميزة إخفاء الرأس والرجل اليمين بشكل دائم (حتى بعد الموت والعودة للحياة)
local function applyQualityFeatures()
    local function modifyCharacter(char)
        if not char then return end
        
        -- مراقبة الرأس وإخفائه فوراً ودائماً
        local head = char:WaitForChild("Head", 3)
        if head then 
            head.Transparency = 1 
            head.CanCollide = false 
            for _, v in ipairs(head:GetChildren()) do
                if v:IsA("Decal") then v.Transparency = 1 end
            end
        end
        
        -- مراقبة الرجل اليمين وإخفائها فوراً ودائماً
        local rightLegNames = {"Right Leg", "RightLowerLeg", "RightUpperLeg", "RightFoot"}
        for _, legName in ipairs(rightLegNames) do
            local leg = char:WaitForChild(legName, 3)
            if leg then
                leg.Transparency = 1
                leg.CanCollide = false
            end
        end
        
        -- إعادة تطبيق التعديل إذا تم عمل ريست أو الموت والعودة
        local humanoid = char:WaitForChild("Humanoid", 3)
        if humanoid then
            humanoid.Died:Connect(function()
                -- يتم إعادة التفعيل تلقائياً عند الموت عبر CharacterAdded
            end)
        end
    end

    if LocalPlayer.Character then
        modifyCharacter(LocalPlayer.Character)
    end
    
    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.3) -- انتظار تحميل الشخصية بالكامل بعد الموت
        modifyCharacter(char)
    end)
end

-- إنشاء زر الأوتو المتحرك (شكل احترافي فخم وقابل للسحب لأي مكان)
local function createDraggableAutoButton()
    if floatingAutoBtn then return end
    
    floatingAutoBtn = Instance.new("TextButton")
    floatingAutoBtn.Size = UDim2.new(0, 150, 0, 45)
    floatingAutoBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
    floatingAutoBtn.Text = "AUTOBOMB: OFF"
    floatingAutoBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    floatingAutoBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    floatingAutoBtn.TextSize = 13
    floatingAutoBtn.Font = Enum.Font.GothamBold
    floatingAutoBtn.Parent = ScreenGui
    
    Instance.new("UICorner", floatingAutoBtn).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", floatingAutoBtn)
    stroke.Color = Color3.fromRGB(255, 80, 80)
    stroke.Thickness = 1.5

    -- جعل الزر قابلاً للتحرك في كل مكان بسلاسة (يمين، يسار، فوق، تحت)
    local dragging, dragInput, dragStart, startPos
    
    floatingAutoBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = floatingAutoBtn.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            floatingAutoBtn.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- تشغيل وإيقاف الأوتو بتصميم تفاعلي
    floatingAutoBtn.MouseButton1Click:Connect(function()
        autoEnabled = not autoEnabled
        if autoEnabled then
            floatingAutoBtn.Text = "AUTOBOMB: ON"
            floatingAutoBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
            stroke.Color = Color3.fromRGB(80, 255, 80)
        else
            floatingAutoBtn.Text = "AUTOBOMB: OFF"
            floatingAutoBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
            stroke.Color = Color3.fromRGB(255, 80, 80)
        end
    end)
end

-- ربط الأزرار بالوظائف
QualityBtn.MouseButton1Click:Connect(function()
    fadeOutAndDestroy()
    applyQualityFeatures()
end)

AutoBtn.MouseButton1Click:Connect(function()
    fadeOutAndDestroy()
    createDraggableAutoButton()
end)

-- نظام الأوتو الذكي (تتبع الخصم الحقيقي بدقة وتجاهل زملاء الفريق)
RunService.RenderStepped:Connect(function()
    if not autoEnabled then return end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    
    -- فحص ما إذا كان اللاعب يحمل القنبلة
    local hasBomb = char:FindFirstChild("Bomb") or LocalPlayer.Backpack:FindFirstChild("Bomb")
    
    if hasBomb then
        local targetPlayer = nil
        local shortestDistance = math.huge
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                
                if pHumanoid and pHumanoid.Health > 0 then
                    -- استثناء الزملاء في نفس الفريق تماماً
                    local isTeamMate = false
                    if LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
                        isTeamMate = true
                    end
                    
                    if not isTeamMate and pHumanoid.WalkSpeed <= 35 then
                        local enemyRoot = player.Character.HumanoidRootPart
                        local dist = (char.HumanoidRootPart.Position - enemyRoot.Position).Magnitude
                        
                        -- فحص العوائق والجدران عبر Raycast
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterDescendantsInstances = {char, player.Character}
                        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                        
                        local raycastResult = Workspace:Raycast(char.HumanoidRootPart.Position, (enemyRoot.Position - char.HumanoidRootPart.Position), raycastParams)
                        
                        if not raycastResult or dist < 12 then
                            if dist < shortestDistance then
                                shortestDistance = dist
                                targetPlayer = player
                            end
                        end
                    end
                end
            end
        end
        
        -- التوجه حصرياً نحو الخصم المستهدف
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            humanoid:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
        end
    end
end)
