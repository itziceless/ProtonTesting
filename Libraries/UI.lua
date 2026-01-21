local api = {
	Tabs = {},
	Modules = {},
	Keybind = {"RightShift"},
	Loaded = false,
	_ModuleIndex = {}
}

local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local lplr = Players.LocalPlayer

local Color = {}
local Pallet = {
	Background = Color3.fromRGB(13, 16, 19),
	Sidebar = Color3.fromRGB(17, 21, 25),
	Panel = Color3.fromRGB(20, 25, 30),
	PanelInner = Color3.fromRGB(22, 28, 33),
	Border = Color3.fromRGB(34, 40, 46),
	Hover = Color3.fromRGB(28, 34, 39),
	Selected = Color3.fromRGB(30, 37, 43),
	TextPrimary = Color3.fromRGB(235, 240, 245),
	TextSecondary = Color3.fromRGB(160, 170, 180),
	TextMuted = Color3.fromRGB(115, 125, 135),
	Accent = Color3.fromRGB(150, 170, 200),
	Dot = Color3.fromRGB(245, 245, 245),
	Font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
}

function Color.Dark(col, num)
	local h, s, v = col:ToHSV()
	return Color3.fromHSV(h, s, math.clamp(select(3, Pallet.Background:ToHSV()) > 0.5 and v + num or v - num, 0, 1))
end

function Color.Light(col, num)
	local h, s, v = col:ToHSV()
	return Color3.fromHSV(h, s, math.clamp(select(3, Pallet.Background:ToHSV()) > 0.5 and v - num or v + num, 0, 1))
end

local function Corner(o, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = r
	c.Parent = o
end

local function Tween(o, p)
	TweenService:Create(o, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), p):Play()
end

local Main = Instance.new("ScreenGui")
Main.Parent = lplr.PlayerGui
Main.ResetOnSpawn = false
Main.Name = "Proton"

local Menu = Instance.new("Frame")
Menu.Parent = Main
Menu.Size = UDim2.fromScale(0.5, 0.6)
Menu.Position = UDim2.fromScale(0.5, 0.5)
Menu.AnchorPoint = Vector2.new(0.5, 0.5)
Menu.BackgroundColor3 = Pallet.Panel
Corner(Menu, UDim.new(0, 8))

local MinSize = Vector2.new(520, 340)
local NormalSize = Menu.Size
local Maximized = false
local Minimized = false

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Menu
Stroke.Color = Pallet.Accent
Stroke.Transparency = 0.85
Stroke.Thickness = 2

local Header = Instance.new("Frame")
Header.Parent = Menu
Header.Size = UDim2.new(1, 0, 0, 46)
Header.BackgroundColor3 = Pallet.Panel
Corner(Header, UDim.new(0, 8))

local HeaderFix = Instance.new("Frame")
HeaderFix.Parent = Header
HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)
HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFix.BorderSizePixel = 0
HeaderFix.BackgroundColor3 = Pallet.Panel

local HeaderText = Instance.new("TextLabel")
HeaderText.Parent = Header
HeaderText.Size = UDim2.new(1, -120, 1, 0)
HeaderText.Position = UDim2.new(0, 20, 0, 0)
HeaderText.BackgroundTransparency = 1
HeaderText.Text = "Home"
HeaderText.FontFace = Pallet.Font
HeaderText.TextSize = 15
HeaderText.TextColor3 = Pallet.TextPrimary
HeaderText.TextXAlignment = Enum.TextXAlignment.Left

local Controls = Instance.new("Frame")
Controls.Parent = Header
Controls.Size = UDim2.new(0, 90, 1, 0)
Controls.Position = UDim2.new(1, -96, 0, 0)
Controls.BackgroundTransparency = 1

local function Control(image, x, callback)
	local b = Instance.new("ImageButton")
	b.Parent = Controls
	b.Size = UDim2.new(0, 26, 0, 26)
	b.Position = UDim2.new(0, x, 0.5, 0)
	b.AnchorPoint = Vector2.new(0, 0.5)
	b.Image = image
	b.BackgroundColor3 = Pallet.PanelInner
	Corner(b, UDim.new(1, 0))
	b.MouseButton1Click:Connect(callback)
end

Control("rbxassetid://96248178095850", 0, function()
	if Minimized then
		Tween(Menu, { Size = NormalSize })
	else
		NormalSize = Menu.Size
		Tween(Menu, { Size = UDim2.new(Menu.Size.X.Scale, Menu.Size.X.Offset, 0, 46) })
	end
	Minimized = not Minimized
end)

Control("rbxassetid://96248178095850", 32, function()
	if Maximized then
		Tween(Menu, { Size = NormalSize, Position = UDim2.fromScale(0.5, 0.5) })
	else
		NormalSize = Menu.Size
		Tween(Menu, { Size = UDim2.fromScale(0.95, 0.95), Position = UDim2.fromScale(0.5, 0.5) })
	end
	Maximized = not Maximized
end)

Control("rbxassetid://96248178095850", 64, function()
	Main:Destroy()
end)

local Sidebar = Instance.new("Frame")
Sidebar.Parent = Menu
Sidebar.Size = UDim2.new(0, 225, 1, -46)
Sidebar.Position = UDim2.new(0, 0, 0, 46)
Sidebar.BackgroundColor3 = Pallet.Panel
Corner(Sidebar, UDim.new(0, 14))

local SearchContainer = Instance.new("Frame")
SearchContainer.Parent = Sidebar
SearchContainer.Position = UDim2.new(0, 10, 0, 1)
SearchContainer.Size = UDim2.new(1, -20, 0, 34)
SearchContainer.BackgroundColor3 = Pallet.PanelInner
Corner(SearchContainer, UDim.new(0, 5))

local SearchIcon = Instance.new("ImageLabel")
SearchIcon.Parent = SearchContainer
SearchIcon.Size = UDim2.new(0, 16, 0, 16)
SearchIcon.Position = UDim2.new(0, 10, 0.5, 0)
SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Image = "rbxassetid://6031154871"
SearchIcon.ImageTransparency = 0.2

local SearchInput = Instance.new("TextBox")
SearchInput.Parent = SearchContainer
SearchInput.Position = UDim2.new(0, 36, 0, 0)
SearchInput.Size = UDim2.new(1, -44, 1, 0)
SearchInput.BackgroundTransparency = 1
SearchInput.PlaceholderText = "Search modules"
SearchInput.Text = ""
SearchInput.ClearTextOnFocus = false
SearchInput.FontFace = Pallet.Font
SearchInput.TextSize = 14
SearchInput.TextColor3 = Pallet.TextPrimary
SearchInput.PlaceholderColor3 = Pallet.TextMuted
SearchInput.TextXAlignment = Enum.TextXAlignment.Left

local TabButtons = Instance.new("Frame")
TabButtons.Parent = Sidebar
TabButtons.Position = UDim2.new(0, 10, 0, 40)
TabButtons.Size = UDim2.new(1, -20, 1, -66)
TabButtons.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabButtons
TabLayout.Padding = UDim.new(0, 8)

local TabHolder = Instance.new("Frame")
TabHolder.Parent = Menu
TabHolder.Position = UDim2.new(0, 225, 0, 46)
TabHolder.Size = UDim2.new(1, -228, 1, -49)
TabHolder.BackgroundColor3 = Pallet.PanelInner
Corner(TabHolder, UDim.new(0, 8))

local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "ProtonNotifications"
NotificationGui.ResetOnSpawn = false
NotificationGui.Parent = lplr.PlayerGui

local Holder = Instance.new("Frame")
Holder.Parent = NotificationGui
Holder.Size = UDim2.new(0, 360, 1, 0)
Holder.Position = UDim2.new(1, -20, 0, 20)
Holder.AnchorPoint = Vector2.new(1, 0)
Holder.BackgroundTransparency = 1

local STACK_Y = 0
local HEIGHT = 78
local GAP = 10

local SeverityThemes = {
	info = {
		Bg = Color3.fromRGB(30, 38, 48),
		Accent = Color3.fromRGB(90, 140, 200),
		Image = "",
		Sound = "rbxassetid://9118828566"
	},
	success = {
		Bg = Color3.fromRGB(32, 46, 38),
		Accent = Color3.fromRGB(90, 200, 140),
		Image = "",
		Sound = "rbxassetid://9118826045"
	},
	warning = {
		Bg = Color3.fromRGB(48, 42, 30),
		Accent = Color3.fromRGB(240, 180, 70),
		Image = "",
		Sound = "rbxassetid://9118827783"
	},
	error = {
		Bg = Color3.fromRGB(48, 30, 30),
		Accent = Color3.fromRGB(230, 80, 80),
		Image = "",
		Sound = "rbxassetid://9118829361"
	}
}

function api:Notify(data)
	local theme = SeverityThemes[data.Severity or "info"] or SeverityThemes.info
	local duration = data.Duration or 4
	local hovered = false
	local alive = true

	local yOffset = STACK_Y
	STACK_Y += HEIGHT + GAP

	local Card = Instance.new("Frame")
	Card.Parent = Holder
	Card.Size = UDim2.new(1, 0, 0, HEIGHT)
	Card.AnchorPoint = Vector2.new(1, 0)
	Card.Position = UDim2.new(1, 180, 0, yOffset)
	Card.BackgroundColor3 = theme.Bg
	Corner(Card, UDim.new(0, 12))
	Card.ClipsDescendants = true

	local Sound = Instance.new("Sound")
	Sound.Parent = Card
	Sound.SoundId = theme.Sound
	Sound.Volume = 0.5
	Sound:Play()

	local Icon
	if data.Icon then
		Icon = Instance.new("ImageLabel")
		Icon.Parent = Card
		Icon.Size = UDim2.new(0, 24, 0, 24)
		Icon.Position = UDim2.new(0, 14, 0, 14)
		Icon.BackgroundTransparency = 1
		Icon.Image = theme.Image
	end

	local Title = Instance.new("TextLabel")
	Title.Parent = Card
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, Icon and 48 or 16, 0, 10)
	Title.Size = UDim2.new(1, -70, 0, 20)
	Title.Text = data.Title or "Notification"
	Title.FontFace = Pallet.Font
	Title.TextSize = 16
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextColor3 = Pallet.TextPrimary

	local Desc = Instance.new("TextLabel")
	Desc.Parent = Card
	Desc.BackgroundTransparency = 1
	Desc.Position = UDim2.new(0, Icon and 48 or 16, 0, 32)
	Desc.Size = UDim2.new(1, -70, 0, 34)
	Desc.TextWrapped = true
	Desc.TextYAlignment = Enum.TextYAlignment.Top
	Desc.Text = data.Description or ""
	Desc.FontFace = Pallet.Font
	Desc.TextSize = 13
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	Desc.TextColor3 = Pallet.TextMuted

	local Close = Instance.new("TextButton")
	Close.Parent = Card
	Close.Size = UDim2.new(0, 22, 0, 22)
	Close.Position = UDim2.new(1, -30, 0, 10)
	Close.BackgroundTransparency = 1
	Close.Text = "×"
	Close.Font = Enum.Font.GothamBold
	Close.TextSize = 20
	Close.TextColor3 = Pallet.TextMuted

	Close.MouseEnter:Connect(function()
		Close.TextColor3 = Pallet.TextPrimary
	end)
	Close.MouseLeave:Connect(function()
		Close.TextColor3 = Pallet.TextMuted
	end)

	Card.MouseEnter:Connect(function()
		hovered = true
	end)
	Card.MouseLeave:Connect(function()
		hovered = false
	end)

	local function Dismiss()
		if not alive then return end
		alive = false

		TweenService:Create(
			Card,
			TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
			{ Position = UDim2.new(1, 200, 0, yOffset), BackgroundTransparency = 1 }
		):Play()

		task.delay(0.35, function()
			Card:Destroy()
		end)
	end

	Close.MouseButton1Click:Connect(Dismiss)

	TweenService:Create(
		Card,
		TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Position = UDim2.new(1, -8, 0, yOffset) }
	):Play()

	task.delay(0.45, function()
		TweenService:Create(
			Card,
			TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Position = UDim2.new(1, 0, 0, yOffset) }
		):Play()
	end)

	task.spawn(function()
		local elapsed = 0
		while alive and elapsed < duration do
			if not hovered then
				elapsed += task.wait(0.1)
			else
				task.wait(0.1)
			end
		end
		if alive then
			Dismiss()
		end
	end)
end

local function EnableDrag(frame, drag)
	local dragging = false
	local startPos
	local startInput

	drag.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startPos = frame.Position
			startInput = i.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	InputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - startInput
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

EnableDrag(Menu, Header)

local Resize = Instance.new("ImageButton")
Resize.Parent = Menu
Resize.Size = UDim2.new(0, 18, 0, 18)
Resize.Position = UDim2.new(1, -8, 1, -8)
Resize.BackgroundColor3 = Pallet.Border
Resize.BackgroundTransparency = 1
Resize.Image = "rbxassetid://96248178095850"
Resize.ImageTransparency = 0.7

local resizing = false
local startSize
local startPos

Resize.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		resizing = true
		startSize = Menu.AbsoluteSize
		startPos = i.Position
	end
end)

InputService.InputChanged:Connect(function(i)
	if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local delta = i.Position - startPos
		local newX = math.max(MinSize.X, startSize.X + delta.X)
		local newY = math.max(MinSize.Y, startSize.Y + delta.Y)
		Menu.Size = UDim2.fromOffset(newX, newY)
	end
end)

InputService.InputEnded:Connect(function()
	resizing = false
end)

function api:CreateCategoryTab(tabsettings)
	local TabApi = { Enabled = false }

	local Button = Instance.new("TextButton")
	Button.Parent = TabButtons
	Button.Size = UDim2.new(1, 0, 0, 44)
	Button.Text = ""
	Button.BackgroundColor3 = Pallet.PanelInner
	Button.AutoButtonColor = false
	Corner(Button, UDim.new(0, 10))

	local Dot = Instance.new("Frame")
	Dot.Parent = Button
	Dot.Size = UDim2.new(0, 6, 0, 6)
	Dot.Position = UDim2.new(1, -14, 0.5, 0)
	Dot.AnchorPoint = Vector2.new(0.5, 0.5)
	Dot.BackgroundColor3 = Pallet.Dot
	Dot.Visible = false
	Corner(Dot, UDim.new(1, 0))

	local Label = Instance.new("TextLabel")
	Label.Parent = Button
	Label.Position = UDim2.new(0, 14, 0, 0)
	Label.Size = UDim2.new(1, -30, 1, 0)
	Label.BackgroundTransparency = 1
	Label.Text = tabsettings.Name
	Label.FontFace = Pallet.Font
	Label.TextSize = 14
	Label.TextColor3 = Pallet.TextSecondary
	Label.TextXAlignment = Enum.TextXAlignment.Left

	local Page = Instance.new("ScrollingFrame")
	Page.Parent = TabHolder
	Page.Size = UDim2.new(1, -20, 1, -10)
	Page.Position = UDim2.new(0, 10, 0, 10)
	Page.ScrollBarImageTransparency = 1
	Page.ScrollBarThickness = 0
	Page.BackgroundTransparency	= 1
	Page.Visible = false
	Corner(Page, UDim.new(0, 12))

	local PageList = Instance.new("UIListLayout")
	PageList.Parent = Page
	PageList.SortOrder = Enum.SortOrder.LayoutOrder
	PageList.FillDirection = Enum.FillDirection.Vertical
	PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	PageList.Padding = UDim.new(0, 1)

	Button.MouseButton1Click:Connect(function()
		for _, v in pairs(api.Tabs) do
			v.Enabled = false
			v.Page.Visible = false
			v.Dot.Visible = false
			v.Button.BackgroundColor3 = Pallet.Panel
		end
		TabApi.Enabled = true
		Page.Visible = true
		Dot.Visible = true
		Button.BackgroundColor3 = Pallet.Selected
		HeaderText.Text = tabsettings.Name
	end)

	TabApi.Button = Button
	TabApi.Page = Page
	TabApi.Dot = Dot

	function TabApi:CreateModule(modulesettings)
		local ModuleApi = { Enabled = false, Open = false }

		local Holder = Instance.new("Frame")
		Holder.Parent = TabApi.Page
		Holder.BackgroundColor3 = Pallet.Panel
		Holder.Size = UDim2.new(1, 0, 0, 60)
		Corner(Holder, UDim.new(0, 12))

		local Title = Instance.new("TextLabel")
		Title.Parent = Holder
		Title.Position = UDim2.new(0, 14, 0, 16)
		Title.Size = UDim2.new(1, -80, 0, 18)
		Title.BackgroundTransparency = 1
		Title.Text = modulesettings.Name
		Title.FontFace = Pallet.Font
		Title.TextSize = 18
		Title.TextColor3 = Pallet.TextSecondary
		Title.TextXAlignment = Enum.TextXAlignment.Left

		local Desc = Instance.new("TextLabel")
		Desc.Parent = Holder
		Desc.Position = UDim2.new(0, 12, 0, 30)
		Desc.Size = UDim2.new(1, -80, 0, 26)
		Desc.BackgroundTransparency = 1
		Desc.TextWrapped = true
		Desc.TextYAlignment = Enum.TextYAlignment.Top
		Desc.Text = modulesettings.Description or ""
		Desc.FontFace = Pallet.Font
		Desc.TextSize = 12
		Desc.TextColor3 = Pallet.TextMuted
		Desc.TextXAlignment = Enum.TextXAlignment.Left

		local Toggle = Instance.new("TextButton")
		Toggle.Parent = Holder
		Toggle.Size = UDim2.new(0, 44, 0, 22)
		Toggle.Position = UDim2.new(1, -68, 0, 18)
		Toggle.Text = ""
		Toggle.BackgroundColor3 = Pallet.Border
		Corner(Toggle, UDim.new(1, 0))

		local Knob = Instance.new("Frame")
		Knob.Parent = Toggle
		Knob.Size = UDim2.new(0, 18, 0, 18)
		Knob.Position = UDim2.new(0, 2, 0.5, 0)
		Knob.AnchorPoint = Vector2.new(0, 0.5)
		Knob.BackgroundColor3 = Pallet.TextSecondary
		Corner(Knob, UDim.new(1, 0))

		Toggle.MouseButton1Click:Connect(function()
			ModuleApi.Enabled = not ModuleApi.Enabled
			if ModuleApi.Enabled then
				Tween(Toggle, { BackgroundColor3 = Pallet.Accent })
				Tween(Knob, { Position = UDim2.new(1, -20, 0.5, 0) })
			else
				Tween(Toggle, { BackgroundColor3 = Pallet.Border })
				Tween(Knob, { Position = UDim2.new(0, 2, 0.5, 0) })
			end
		end)

		ModuleApi.Holder = Holder
		table.insert(api.Modules, ModuleApi)
		return ModuleApi
	end

	table.insert(api.Tabs, TabApi)
	return TabApi
end

for _, tab in pairs(api.Tabs) do
	for _, mod in pairs(tab.Page:GetChildren()) do
		if mod:IsA("Frame") then
			table.insert(api._ModuleIndex, { Name = mod.Name, Holder = mod, Page = tab.Page, Tab = tab })
		end
	end
end


local SearchResults = {}
local CurrentResultIndex = 0

local function ClearHighlights()
	for _, m in ipairs(api._ModuleIndex) do
		Tween(m.Holder, { BackgroundColor3 = Pallet.Panel })
	end
end

local function HighlightModule(module)
	local page = module.Page
	local holder = module.Holder
	page.CanvasPosition = Vector2.new(0, math.max(holder.AbsolutePosition.Y - page.AbsolutePosition.Y - 20, 0))
	local oldColor = holder.BackgroundColor3
	local function pulse(times)
		if times <= 0 then return end
		Tween(holder, { BackgroundColor3 = Pallet.Accent })
		task.delay(0.25, function()
			Tween(holder, { BackgroundColor3 = oldColor })
			task.delay(0.25, function() pulse(times - 1) end)
		end)
	end
	pulse(2)
end

local function PerformSearch()
	local query = string.lower(SearchInput.Text or "")
	if query == "" then
		SearchResults = {}
		CurrentResultIndex = 0
		ClearHighlights()
		return
	end

	SearchResults = {}
	for _, m in ipairs(api._ModuleIndex) do
		if string.find(string.lower(m.Name), query, 1, true) then
			table.insert(SearchResults, m)
		end
	end

	if #SearchResults > 0 then
		CurrentResultIndex = 1
		local result = SearchResults[CurrentResultIndex]
		result.Tab.Button:Activate()
		task.wait()
		HighlightModule(result)
	end
end

SearchInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		PerformSearch()
	end
end)

SearchInput.Focused:Connect(function()
	CurrentResultIndex = 0
	SearchResults = {}
	ClearHighlights()
end)

InputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if SearchInput:IsFocused() then
		if input.KeyCode == Enum.KeyCode.Return and #SearchResults > 0 then
			CurrentResultIndex = CurrentResultIndex % #SearchResults + 1
			local result = SearchResults[CurrentResultIndex]
			result.Tab.Button:Activate()
			task.wait()
			HighlightModule(result)
		elseif input.KeyCode == Enum.KeyCode.Escape then
			SearchInput.Text = ""
			ClearHighlights()
			SearchResults = {}
			CurrentResultIndex = 0
		end
	end
end)

local Home = api:CreateCategoryTab({
	Name = "Home" 
})
Home:CreateModule({ 
	Name = "Combat" 
})
Home:CreateModule({ 
	Name = "Combat" 
})
Home:CreateModule({ 
	Name = "Combat" 
})
Home:CreateModule({ 
	Name = "Settings" 
})

api:Notify({
	Title = "Success",
	Description = "Sucessfully loaded with 0 errors.",
	Severity = "success",
	Duration = 5,
})
