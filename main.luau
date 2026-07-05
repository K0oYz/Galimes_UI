local Kuyz = {}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local uiParent = gethui and gethui() or (RunService:IsStudio() and game.Players.LocalPlayer.PlayerGui or CoreGui)

function Kuyz:CreateWindow(cfg)
    local Main = Instance.new("ScreenGui", uiParent)
    Main.Name = "Kuyz_UI"
    
    local Frame = Instance.new("Frame", Main)
    Frame.Size = UDim2.new(0, 500, 0, 300); Frame.Position = UDim2.new(0.5, -250, 0.5, -150)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    -- Efficient Window Dragging
    local dragging, dragStart, startPos
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    local Container = Instance.new("ScrollingFrame", Frame)
    Container.Size = UDim2.new(1, -10, 1, -10); Container.Position = UDim2.new(0, 5, 0, 5)
    Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 5)

    local Window = {}
    function Window:CreateToggle(t)
        local Btn = Instance.new("TextButton", Container)
        Btn.Size = UDim2.new(1, 0, 0, 30); Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        Btn.Text = t.Name; Btn.TextColor3 = Color3.new(1,1,1); Btn.Font = Enum.Font.Gotham
        local status = false
        Btn.MouseButton1Click:Connect(function()
            status = not status
            Btn.BackgroundColor3 = status and Color3.fromRGB(85, 170, 255) or Color3.fromRGB(30, 30, 35)
            t.Callback(status)
        end)
    end
    
    function Window:CreateSlider(s)
        local BG = Instance.new("Frame", Container)
        BG.Size = UDim2.new(1, 0, 0, 30); BG.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        local Fill = Instance.new("Frame", BG)
        Fill.Size = UDim2.new(0, 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
        
        BG.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mouse = game.Players.LocalPlayer:GetMouse()
                local percent = math.clamp((mouse.X - BG.AbsolutePosition.X) / BG.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                s.Callback(math.floor(s.Min + (s.Max - s.Min) * percent))
            end
        end)
    end
    return Window
end

return Kuyz
