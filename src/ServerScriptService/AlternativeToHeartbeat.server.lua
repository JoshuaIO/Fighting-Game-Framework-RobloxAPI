local function updateFunction()
    -- Your update logic here
    print("Update logic executed")
end

-- Alternative 1: Use task.wait() for less frequent updates
spawn(function()
    while true do
        updateFunction()
        task.wait(1)  -- Adjust the wait time as needed
    end
end)

-- Alternative 2: Use specific events instead of continuous updates
local part = workspace:FindFirstChild("Example")
if part then
    part.Touched:Connect(function(hit)
        updateFunction()
    end)
end

