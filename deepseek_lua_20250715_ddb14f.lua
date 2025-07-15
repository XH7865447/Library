-- Orion UI Replica Library
local OrionLib = {}

-- Colors
local colors = {
    Background = Color3.fromRGB(25, 25, 25),
    TopBar = Color3.fromRGB(30, 30, 30),
    Tab = Color3.fromRGB(35, 35, 35),
    TabSelected = Color3.fromRGB(50, 50, 50),
    Section = Color3.fromRGB(40, 40, 40),
    Element = Color3.fromRGB(45, 45, 45),
    ElementHover = Color3.fromRGB(55, 55, 55),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Accent = Color3.fromRGB(0, 120, 215),
    Border = Color3.fromRGB(60, 60, 60)
}

-- Main Window
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OrionLib"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.BackgroundColor3 = colors.Background
MainFrame.BorderColor3 = colors.Border
MainFrame.BorderSizePixel = 1
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = colors.TopBar
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Orion UI"
Title.TextColor3 = colors.Text
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.Gotham
Title.TextSize = 14
Title.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = colors.TopBar
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = colors.Text
CloseButton.Font = Enum.Font.Gotham
CloseButton.TextSize = 14
CloseButton.Parent = TopBar

local TabsHolder = Instance.new("Frame")
TabsHolder.Name = "TabsHolder"
TabsHolder.Size = UDim2.new(1, 0, 0, 30)
TabsHolder.Position = UDim2.new(0, 0, 0, 30)
TabsHolder.BackgroundColor3 = colors.Background
TabsHolder.BorderSizePixel = 0
TabsHolder.Parent = MainFrame

local TabsListLayout = Instance.new("UIListLayout")
TabsListLayout.Name = "TabsListLayout"
TabsListLayout.FillDirection = Enum.FillDirection.Horizontal
TabsListLayout.Padding = UDim.new(0, 0)
TabsListLayout.Parent = TabsHolder

local PagesHolder = Instance.new("Frame")
PagesHolder.Name = "PagesHolder"
PagesHolder.Size = UDim2.new(1, -20, 1, -70)
PagesHolder.Position = UDim2.new(0, 10, 0, 70)
PagesHolder.BackgroundTransparency = 1
PagesHolder.Parent = MainFrame

-- Make window draggable
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Close/Open functionality with tween
local isOpen = true
local tweenService = game:GetService("TweenService")

CloseButton.MouseButton1Click:Connect(function()
    if isOpen then
        local tween = tweenService:Create(
            MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 400, 0, 30)}
        )
        tween:Play()
    else
        local tween = tweenService:Create(
            MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 400, 0, 450)}
        )
        tween:Play()
    end
    isOpen = not isOpen
end)

-- Make mobile friendly
if UserInputService.TouchEnabled then
    MainFrame.Size = UDim2.new(0, 350, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
end

-- Library functions
function OrionLib:Window(title)
    Title.Text = title or "Orion UI"
end

function OrionLib:Tab(name)
    local tab = {}
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Size = UDim2.new(0, 80, 1, 0)
    TabButton.BackgroundColor3 = colors.Tab
    TabButton.BorderSizePixel = 0
    TabButton.Text = name
    TabButton.TextColor3 = colors.Text
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 12
    TabButton.Parent = TabsHolder
    
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = colors.Border
    Page.Visible = false
    Page.Parent = PagesHolder
    
    local PageListLayout = Instance.new("UIListLayout")
    PageListLayout.Name = "PageListLayout"
    PageListLayout.Padding = UDim.new(0, 5)
    PageListLayout.Parent = Page
    
    -- Select first tab by default
    if #TabsHolder:GetChildren() == 2 then -- 1 is UIListLayout
        TabButton.BackgroundColor3 = colors.TabSelected
        Page.Visible = true
    end
    
    TabButton.MouseButton1Click:Connect(function()
        for _, child in ipairs(TabsHolder:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = colors.Tab
            end
        end
        TabButton.BackgroundColor3 = colors.TabSelected
        
        for _, child in ipairs(PagesHolder:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        Page.Visible = true
    end)
    
    function tab:Section(name)
        local section = {}
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = name
        SectionFrame.Size = UDim2.new(1, 0, 0, 30)
        SectionFrame.BackgroundColor3 = colors.Section
        SectionFrame.BorderSizePixel = 0
        SectionFrame.Parent = Page
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "Title"
        SectionTitle.Size = UDim2.new(1, -10, 1, 0)
        SectionTitle.Position = UDim2.new(0, 10, 0, 0)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Text = name
        SectionTitle.TextColor3 = colors.Text
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Font = Enum.Font.Gotham
        SectionTitle.TextSize = 12
        SectionTitle.Parent = SectionFrame
        
        local SectionContent = Instance.new("Frame")
        SectionContent.Name = "Content"
        SectionContent.Size = UDim2.new(1, 0, 0, 0)
        SectionContent.Position = UDim2.new(0, 0, 0, 30)
        SectionContent.BackgroundColor3 = colors.Section
        SectionContent.BorderSizePixel = 0
        SectionContent.ClipsDescendants = true
        SectionContent.Parent = SectionFrame
        
        local SectionListLayout = Instance.new("UIListLayout")
        SectionListLayout.Name = "SectionListLayout"
        SectionListLayout.Padding = UDim.new(0, 5)
        SectionListLayout.Parent = SectionContent
        
        SectionListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SectionContent.Size = UDim2.new(1, 0, 0, SectionListLayout.AbsoluteContentSize.Y)
            SectionFrame.Size = UDim2.new(1, 0, 0, 30 + SectionListLayout.AbsoluteContentSize.Y)
        end)
        
        function section:Button(name, callback, description)
            local Button = Instance.new("TextButton")
            Button.Name = name
            Button.Size = UDim2.new(1, -10, 0, 30)
            Button.Position = UDim2.new(0, 5, 0, 0)
            Button.BackgroundColor3 = colors.Element
            Button.BorderSizePixel = 0
            Button.Text = name
            Button.TextColor3 = colors.Text
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 12
            Button.Parent = SectionContent
            
            if description then
                local Description = Instance.new("TextLabel")
                Description.Name = "Description"
                Description.Size = UDim2.new(1, -10, 0, 15)
                Description.Position = UDim2.new(0, 5, 0, 30)
                Description.BackgroundTransparency = 1
                Description.Text = description
                Description.TextColor3 = colors.TextSecondary
                Description.TextXAlignment = Enum.TextXAlignment.Left
                Description.Font = Enum.Font.Gotham
                Description.TextSize = 11
                Description.Parent = SectionContent
            end
            
            Button.MouseEnter:Connect(function()
                Button.BackgroundColor3 = colors.ElementHover
            end)
            
            Button.MouseLeave:Connect(function()
                Button.BackgroundColor3 = colors.Element
            end)
            
            Button.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
        end
        
        function section:Label(text, description)
            local Label = Instance.new("TextLabel")
            Label.Name = text
            Label.Size = UDim2.new(1, -10, 0, 20)
            Label.Position = UDim2.new(0, 5, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = colors.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.Parent = SectionContent
            
            if description then
                local Description = Instance.new("TextLabel")
                Description.Name = "Description"
                Description.Size = UDim2.new(1, -10, 0, 15)
                Description.Position = UDim2.new(0, 5, 0, 20)
                Description.BackgroundTransparency = 1
                Description.Text = description
                Description.TextColor3 = colors.TextSecondary
                Description.TextXAlignment = Enum.TextXAlignment.Left
                Description.Font = Enum.Font.Gotham
                Description.TextSize = 11
                Description.Parent = SectionContent
            end
        end
        
        function section:Dropdown(name, options, callback, description)
            local dropdown = {}
            local selected = options[1] or "Select"
            local isOpen = false
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = name
            DropdownButton.Size = UDim2.new(1, -10, 0, 30)
            DropdownButton.Position = UDim2.new(0, 5, 0, 0)
            DropdownButton.BackgroundColor3 = colors.Element
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Text = name .. ": " .. selected
            DropdownButton.TextColor3 = colors.Text
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextSize = 12
            DropdownButton.Parent = SectionContent
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Name = "DropdownList"
            DropdownList.Size = UDim2.new(1, -10, 0, 0)
            DropdownList.Position = UDim2.new(0, 5, 0, 30)
            DropdownList.BackgroundColor3 = colors.Element
            DropdownList.BorderSizePixel = 0
            DropdownList.ClipsDescendants = true
            DropdownList.Visible = false
            DropdownList.Parent = SectionContent
            
            local DropdownListLayout = Instance.new("UIListLayout")
            DropdownListLayout.Name = "DropdownListLayout"
            DropdownListLayout.Padding = UDim.new(0, 0)
            DropdownListLayout.Parent = DropdownList
            
            if description then
                local Description = Instance.new("TextLabel")
                Description.Name = "Description"
                Description.Size = UDim2.new(1, -10, 0, 15)
                Description.Position = UDim2.new(0, 5, 0, 30 + (isOpen and (#options * 30) or 0))
                Description.BackgroundTransparency = 1
                Description.Text = description
                Description.TextColor3 = colors.TextSecondary
                Description.TextXAlignment = Enum.TextXAlignment.Left
                Description.Font = Enum.Font.Gotham
                Description.TextSize = 11
                Description.Parent = SectionContent
            end
            
            for i, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = colors.Element
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = colors.Text
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.TextSize = 12
                OptionButton.Parent = DropdownList
                
                OptionButton.MouseEnter:Connect(function()
                    OptionButton.BackgroundColor3 = colors.ElementHover
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    OptionButton.BackgroundColor3 = colors.Element
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    selected = option
                    DropdownButton.Text = name .. ": " .. selected
                    isOpen = false
                    DropdownList.Visible = false
                    if callback then
                        callback(selected)
                    end
                end)
            end
            
            DropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                DropdownList.Size = UDim2.new(1, -10, 0, DropdownListLayout.AbsoluteContentSize.Y)
            end)
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                DropdownList.Visible = isOpen
            end)
            
            function dropdown:Set(value)
                if table.find(options, value) then
                    selected = value
                    DropdownButton.Text = name .. ": " .. selected
                    if callback then
                        callback(selected)
                    end
                end
            end
            
            function dropdown:Get()
                return selected
            end
            
            return dropdown
        end
        
        function section:MultiDropdown(name, options, callback, description)
            local multidropdown = {}
            local selected = {}
            local maxSelected = 2 -- As requested, limit to 2 selections
            local isOpen = false
            
            local MultiDropdownButton = Instance.new("TextButton")
            MultiDropdownButton.Name = name
            MultiDropdownButton.Size = UDim2.new(1, -10, 0, 30)
            MultiDropdownButton.Position = UDim2.new(0, 5, 0, 0)
            MultiDropdownButton.BackgroundColor3 = colors.Element
            MultiDropdownButton.BorderSizePixel = 0
            MultiDropdownButton.Text = name .. ": None"
            MultiDropdownButton.TextColor3 = colors.Text
            MultiDropdownButton.Font = Enum.Font.Gotham
            MultiDropdownButton.TextSize = 12
            MultiDropdownButton.Parent = SectionContent
            
            local MultiDropdownList = Instance.new("Frame")
            MultiDropdownList.Name = "MultiDropdownList"
            MultiDropdownList.Size = UDim2.new(1, -10, 0, 0)
            MultiDropdownList.Position = UDim2.new(0, 5, 0, 30)
            MultiDropdownList.BackgroundColor3 = colors.Element
            MultiDropdownList.BorderSizePixel = 0
            MultiDropdownList.ClipsDescendants = true
            MultiDropdownList.Visible = false
            MultiDropdownList.Parent = SectionContent
            
            local MultiDropdownListLayout = Instance.new("UIListLayout")
            MultiDropdownListLayout.Name = "MultiDropdownListLayout"
            MultiDropdownListLayout.Padding = UDim.new(0, 0)
            MultiDropdownListLayout.Parent = MultiDropdownList
            
            if description then
                local Description = Instance.new("TextLabel")
                Description.Name = "Description"
                Description.Size = UDim2.new(1, -10, 0, 15)
                Description.Position = UDim2.new(0, 5, 0, 30 + (isOpen and (#options * 30) or 0))
                Description.BackgroundTransparency = 1
                Description.Text = description
                Description.TextColor3 = colors.TextSecondary
                Description.TextXAlignment = Enum.TextXAlignment.Left
                Description.Font = Enum.Font.Gotham
                Description.TextSize = 11
                Description.Parent = SectionContent
            end
            
            for i, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.BackgroundColor3 = colors.Element
                OptionButton.BorderSizePixel = 0
                OptionButton.Text = option
                OptionButton.TextColor3 = colors.Text
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.TextSize = 12
                OptionButton.Parent = MultiDropdownList
                
                OptionButton.MouseEnter:Connect(function()
                    OptionButton.BackgroundColor3 = colors.ElementHover
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    if table.find(selected, option) then
                        OptionButton.BackgroundColor3 = colors.Accent
                    else
                        OptionButton.BackgroundColor3 = colors.Element
                    end
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    if table.find(selected, option) then
                        table.remove(selected, table.find(selected, option))
                        OptionButton.BackgroundColor3 = colors.Element
                    else
                        if #selected < maxSelected then
                            table.insert(selected, option)
                            OptionButton.BackgroundColor3 = colors.Accent
                        end
                    end
                    
                    if #selected > 0 then
                        MultiDropdownButton.Text = name .. ": " .. table.concat(selected, ", ")
                    else
                        MultiDropdownButton.Text = name .. ": None"
                    end
                    
                    if callback then
                        callback(selected)
                    end
                end)
            end
            
            MultiDropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                MultiDropdownList.Size = UDim2.new(1, -10, 0, MultiDropdownListLayout.AbsoluteContentSize.Y)
            end)
            
            MultiDropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                MultiDropdownList.Visible = isOpen
            end)
            
            function multidropdown:Set(values)
                selected = {}
                for _, value in ipairs(values) do
                    if table.find(options, value) and #selected < maxSelected then
                        table.insert(selected, value)
                    end
                end
                
                -- Update button text
                if #selected > 0 then
                    MultiDropdownButton.Text = name .. ": " .. table.concat(selected, ", ")
                else
                    MultiDropdownButton.Text = name .. ": None"
                end
                
                -- Update option buttons
                for _, child in ipairs(MultiDropdownList:GetChildren()) do
                    if child:IsA("TextButton") then
                        if table.find(selected, child.Name) then
                            child.BackgroundColor3 = colors.Accent
                        else
                            child.BackgroundColor3 = colors.Element
                        end
                    end
                end
                
                if callback then
                    callback(selected)
                end
            end
            
            function multidropdown:Get()
                return selected
            end
            
            return multidropdown
        end
        
        function section:Slider(name, min, max, default, callback, description)
            local slider = {}
            local value = default or min
            local isDragging = false
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = name
            SliderFrame.Size = UDim2.new(1, -10, 0, 50)
            SliderFrame.Position = UDim2.new(0, 5, 0, 0)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = SectionContent
            
            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Name = "Title"
            SliderTitle.Size = UDim2.new(1, 0, 0, 20)
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Text = name .. ": " .. value
            SliderTitle.TextColor3 = colors.Text
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            SliderTitle.Font = Enum.Font.Gotham
            SliderTitle.TextSize = 12
            SliderTitle.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Name = "Bar"
            SliderBar.Size = UDim2.new(1, 0, 0, 5)
            SliderBar.Position = UDim2.new(0, 0, 0, 25)
            SliderBar.BackgroundColor3 = colors.Element
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = colors.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "Button"
            SliderButton.Size = UDim2.new(0, 15, 0, 15)
            SliderButton.Position = UDim2.new((value - min) / (max - min), -5, 0, -5)
            SliderButton.BackgroundColor3 = colors.Text
            SliderButton.BorderSizePixel = 0
            SliderButton.Text = ""
            SliderButton.Parent = SliderBar
            
            if description then
                local Description = Instance.new("TextLabel")
                Description.Name = "Description"
                Description.Size = UDim2.new(1, 0, 0, 15)
                Description.Position = UDim2.new(0, 0, 0, 35)
                Description.BackgroundTransparency = 1
                Description.Text = description
                Description.TextColor3 = colors.TextSecondary
                Description.TextXAlignment = Enum.TextXAlignment.Left
                Description.Font = Enum.Font.Gotham
                Description.TextSize = 11
                Description.Parent = SliderFrame
            end
            
            local function updateValue(input)
                local xOffset = (input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                xOffset = math.clamp(xOffset, 0, 1)
                value = math.floor(min + (max - min) * xOffset)
                SliderTitle.Text = name .. ": " .. value
                SliderFill.Size = UDim2.new(xOffset, 0, 1, 0)
                SliderButton.Position = UDim2.new(xOffset, -5, 0, -5)
                if callback then
                    callback(value)
                end
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                isDragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateValue(input)
                end
            end)
            
            SliderBar.MouseButton1Down:Connect(function(x, y)
                updateValue({Position = Vector2.new(x, y)})
            end)
            
            function slider:Set(newValue)
                value = math.clamp(newValue, min, max)
                SliderTitle.Text = name .. ": " .. value
                local xOffset = (value - min) / (max - min)
                SliderFill.Size = UDim2.new(xOffset, 0, 1, 0)
                SliderButton.Position = UDim2.new(xOffset, -5, 0, -5)
                if callback then
                    callback(value)
                end
            end
            
            function slider:Get()
                return value
            end
            
            return slider
        end
        
        function section:Textbox(name, placeholder, callback, description)
            local textbox = {}
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = name
            TextboxFrame.Size = UDim2.new(1, -10, 0, 30)
            TextboxFrame.Position = UDim2.new(0, 5, 0, 0)
            TextboxFrame.BackgroundTransparency = 1
            TextboxFrame.Parent = SectionContent
            
            local Textbox = Instance.new("TextBox")
            Textbox.Name = "Textbox"
            Textbox.Size = UDim2.new(1, 0, 1, 0)
            Textbox.BackgroundColor3 = colors.Element
            Textbox.BorderSizePixel = 0
            Textbox.Text = ""
            Textbox.PlaceholderText = placeholder or "Enter text..."
            Textbox.TextColor3 = colors.Text
            Textbox.Font = Enum.Font.Gotham
            Textbox.TextSize = 12
            Textbox.Parent = TextboxFrame
            
            if description then
                local Description = Instance.new("TextLabel")
                Description.Name = "Description"
                Description.Size = UDim2.new(1, 0, 0, 15)
                Description.Position = UDim2.new(0, 0, 0, 30)
                Description.BackgroundTransparency = 1
                Description.Text = description
                Description.TextColor3 = colors.TextSecondary
                Description.TextXAlignment = Enum.TextXAlignment.Left
                Description.Font = Enum.Font.Gotham
                Description.TextSize = 11
                Description.Parent = TextboxFrame
            end
            
            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed and callback then
                    callback(Textbox.Text)
                end
            end)
            
            function textbox:Set(text)
                Textbox.Text = text
            end
            
            function textbox:Get()
                return Textbox.Text
            end
            
            return textbox
        end
        
        return section
    end
    
    return tab
end

return OrionLib