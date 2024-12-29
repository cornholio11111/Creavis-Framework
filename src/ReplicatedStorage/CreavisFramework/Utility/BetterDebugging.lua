local RunService = game:GetService("RunService")
local BetterDebugging = {}

function BetterDebugging.Print(Priority: number, Text: string)
    local Letter = (RunService:IsClient() and "(C)") or (RunService:IsServer() and "(S)") or "(?)"

    local outputText = Letter .. " " .. Text

    if Priority == -1 then
        error(outputText)
    elseif Priority == 0 then
        print(outputText)
    elseif Priority == 1 then
        warn(outputText)
    end
end

return BetterDebugging