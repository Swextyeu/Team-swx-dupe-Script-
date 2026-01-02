-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- REMOTES
local remotes = require(game:GetService("ReplicatedStorage")
    .client.Modules.RemoteEventClient)

local vector3_zero = Vector3.zero

-- =========================
-- START ANIMATION
-- =========================

-- Alle vorhandenen GUIs speichern & ausblenden
local hiddenGuis = {}

for _,gui in ipairs(PlayerGui:GetChildren()) do
    if gui:IsA("ScreenGui") and gui.Enabled then
        gui.Enabled = false
        table.insert(hiddenGuis, gui)
    end
end

-- Overlay GUI
local introGui = Instance.new("ScreenGui")
introGui.Name = "IntroTextGui"
introGui.IgnoreGuiInset = true
introGui.ResetOnSpawn = false
introGui.Parent = PlayerGui

local introText = Instance.new("TextLabel")
introText.Size = UDim2.new(1, 0, 1, 0)
introText.BackgroundColor3 = Color3.fromRGB(0,0,0)
introText.TextColor3 = Color3.new(1,1,1)
introText.TextScaled = true
introText.Text = "BY TEAM SWX (COULD LAG)"
introText.Font = Enum.Font.GothamBold
introText.Parent = introGui

-- 5 Sekunden warten
task.wait(5)

-- Intro entfernen
introGui:Destroy()

-- Alte GUIs wieder anzeigen
for _,gui in ipairs(hiddenGuis) do
    if gui then
        gui.Enabled = true
    end
end

-- =========================
-- DUPE GUI
-- =========================

local gui = Instance.new("ScreenGui")
gui.Name = "DupeGui"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 110)
frame.Position = UDim2.new(0, 20, 0.5, -55)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Time Box
local timeBox = Instance.new("TextBox")
timeBox.Size = UDim2.new(1, -10, 0, 30)
timeBox.Position = UDim2.new(0, 5, 0, 5)
timeBox.Text = "5"
timeBox.PlaceholderText = "Dupe Time (sec)"
timeBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
timeBox.TextColor3 = Color3.new(1,1,1)
timeBox.ClearTextOnFocus = false
timeBox.Parent = frame

-- 🔴 DUPE BUTTON
local dupeButton = Instance.new("TextButton")
dupeButton.Size = UDim2.new(1, -10, 0, 40)
dupeButton.Position = UDim2.new(0, 5, 0, 45)
dupeButton.Text = "DUPE"
dupeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
dupeButton.TextColor3 = Color3.new(1,1,1)
dupeButton.Font = Enum.Font.GothamBold
dupeButton.Parent = frame

-- =========================
-- DUPE LOGIC
-- =========================
local running = false
local DUPE_RUNS = 10

local function runDupe()
    for i = 1, DUPE_RUNS do
        remotes:GetRemoteEvent("RodThrow").dispatch:FireServer({
            vector3_zero,
            vector3_zero,
            9e9,
            false
        })

        remotes:GetRemoteEvent("EndStruggle").dispatch:FireServer({
            true,
            vector3_zero
        })
    end
end

dupeButton.MouseButton1Click:Connect(function()
    running = not running
    dupeButton.Text = running and "STOP" or "DUPE"

    if running then
        task.spawn(function()
            while running do
                runDupe()
                task.wait(tonumber(timeBox.Text) or 5)
            end
        end)
    end
end)
