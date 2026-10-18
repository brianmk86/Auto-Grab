--[=[
    Kicia Rebuild - Fluent UI Demo
    Esta interfaz es únicamente visual:
    - No carga el script original.
    - No ejecuta remotes ni hooks.
    - No implementa targeting, ESP, silent aim, auto-fire ni exploits.
]=]

local function safeLoad(url)
    local ok, source = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or type(source) ~= "string" then
        return nil
    end
    local compileOk, chunk = pcall(loadstring, source)
    if not compileOk or type(chunk) ~= "function" then
        return nil
    end
    local runOk, result = pcall(chunk)
    return runOk and result or nil
end

local Fluent = safeLoad(
    "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"
)
if not Fluent then
    warn("Kicia Demo UI: no se pudo cargar Fluent UI.")
    return
end

local SaveManager = safeLoad(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"
)
local InterfaceManager = safeLoad(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"
)

local Window = Fluent:CreateWindow({
    Title = "Kicia Demo UI",
    SubTitle = "Fluent interface only",
    TabWidth = 160,
    Size = UDim2.fromOffset(620, 480),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "layout-dashboard" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Movement = Window:AddTab({ Title = "Movement", Icon = "move" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "sliders-horizontal" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = Fluent.Options

local function demoNotice(name)
    Fluent:Notify({
        Title = "Demo mode",
        Content = name .. " no está conectado a ninguna función.",
        SubContent = "Interfaz visual únicamente.",
        Duration = 3,
    })
end

local function demoToggle(tab, id, title, description)
    local item = tab:AddToggle(id, {
        Title = title,
        Description = description or "Solo demostración",
        Default = false,
    })
    item:OnChanged(function()
        -- Deliberadamente no ejecuta lógica de juego ni cambia el toggle.
        demoNotice(title)
    end)
    return item
end

local function demoButton(tab, title, description)
    tab:AddButton({
        Title = title,
        Description = description or "Solo demostración",
        Callback = function()
            demoNotice(title)
        end,
    })
end

local function demoSlider(tab, id, title, min, max, default)
    local item = tab:AddSlider(id, {
        Title = title,
        Description = "Valor visual; no modifica el personaje",
        Default = default or min,
        Min = min,
        Max = max,
        Rounding = 1,
    })
    item:OnChanged(function()
        demoNotice(title)
    end)
    return item
end

-- Main -----------------------------------------------------------------------
Tabs.Main:AddParagraph({
    Title = "Kicia Demo UI",
    Content = "Maqueta Fluent basada en la organización del script original.\nTodas las acciones están desconectadas.",
})
demoButton(Tabs.Main, "Mostrar estado", "No inspecciona ni modifica partidas")
demoButton(Tabs.Main, "Recargar interfaz", "Solo muestra una notificación")
demoButton(Tabs.Main, "Unload demo", "Cierra únicamente esta interfaz")

-- Visuals --------------------------------------------------------------------
Tabs.Visuals:AddParagraph({
    Title = "Visuals — Demo",
    Content = "Los elementos de visualización del script original están representados como controles desactivados.",
})
demoToggle(Tabs.Visuals, "PlayerESP", "Player ESP (disabled)", "No crea Highlights, tracers ni nametags")
demoToggle(Tabs.Visuals, "Chams", "Chams (disabled)", "No modifica personajes")
demoToggle(Tabs.Visuals, "HealthBars", "Health bars (disabled)", "No lee jugadores ni salud")
demoToggle(Tabs.Visuals, "Crosshair", "Crosshair preview", "Solo control de interfaz")
demoSlider(Tabs.Visuals, "FontSize", "Text size", 8, 32, 14)
demoSlider(Tabs.Visuals, "TracerThickness", "Tracer thickness", 1, 6, 2)

-- Combat ---------------------------------------------------------------------
Tabs.Combat:AddParagraph({
    Title = "Combat — Demo only",
    Content = "Los controles de combate se muestran solo como maqueta y no tienen callbacks de juego.",
})
demoToggle(Tabs.Combat, "SilentAim", "Silent aim (disabled)", "No selecciona objetivos ni altera disparos")
demoToggle(Tabs.Combat, "Aimbot", "Aimbot (disabled)", "No mueve la cámara ni apunta")
demoToggle(Tabs.Combat, "Triggerbot", "Triggerbot (disabled)", "No activa herramientas ni remotes")
demoToggle(Tabs.Combat, "Hitbox", "Hitbox (disabled)", "No modifica partes de personajes")
demoSlider(Tabs.Combat, "FOV", "FOV preview", 30, 120, 90)

-- Movement -------------------------------------------------------------------
Tabs.Movement:AddParagraph({
    Title = "Movement — Demo",
    Content = "Controles visuales sin cambios de WalkSpeed, CFrame, Humanoid o AssemblyLinearVelocity.",
})
demoToggle(Tabs.Movement, "Bhop", "Bhop (disabled)")
demoToggle(Tabs.Movement, "Fly", "Fly (disabled)")
demoToggle(Tabs.Movement, "Speed", "Speed (disabled)")
demoToggle(Tabs.Movement, "AntiFling", "Anti-fling (disabled)")
demoSlider(Tabs.Movement, "SpeedValue", "Speed value", 1, 100, 16)

-- Misc -----------------------------------------------------------------------
Tabs.Misc:AddParagraph({
    Title = "Miscellaneous — Demo",
    Content = "Funciones administrativas y de utilidad representadas sin ejecutar acciones externas.",
})
demoToggle(Tabs.Misc, "AutoRespawn", "Auto respawn (disabled)")
demoToggle(Tabs.Misc, "AutoQueue", "Auto queue (disabled)")
demoToggle(Tabs.Misc, "DeviceSpoof", "Device spoof (disabled)")
demoButton(Tabs.Misc, "Test notification", "Prueba visual")

-- Settings -------------------------------------------------------------------
if InterfaceManager and SaveManager then
    pcall(function()
        InterfaceManager:SetLibrary(Fluent)
        SaveManager:SetLibrary(Fluent)
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetIgnoreIndexes({})
        InterfaceManager:SetFolder("KiciaDemoUI")
        SaveManager:SetFolder("KiciaDemoUI/configs")
        InterfaceManager:BuildInterfaceSection(Tabs.Settings)
        SaveManager:BuildConfigSection(Tabs.Settings)
    end)
else
    Tabs.Settings:AddParagraph({
        Title = "Managers unavailable",
        Content = "La interfaz funciona, pero los addons de guardado no están disponibles.",
    })
end

Window:SelectTab(1)
Fluent:Notify({
    Title = "Kicia Demo UI",
    Content = "Interfaz cargada en modo demostración.",
    SubContent = "No hay funciones de juego conectadas.",
    Duration = 6,
})

-- Solo desconecta la interfaz de Fluent al descargar; no toca el juego.
