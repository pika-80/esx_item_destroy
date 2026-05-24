Config = {}

-- Localização do target
Config.Marker = vec3(1110.74, -2008.84, 31.05)

-- Jobs permitidos
Config.JobMode = 'whitelist' -- whitelist / blacklist

Config.JobList = {
    police = true,
    gnr = true
}

-- Valor por item
Config.ItemsValue = {
    zipbag = 100,
    coke_pooch = 250,
    opium_pooch = 300
}

-- Valor por arma
Config.WeaponsValue = {
    WEAPON_SNSPISTOL = 1000,
    WEAPON_VINTAGEPISTOL = 1500,
    WEAPON_MICROSMG = 2000,
    WEAPON_MINISMG = 2500,
    WEAPON_PUMPSHOTGUN = 3000,
    WEAPON_ASSAULTRIFLE = 3500,
    WEAPON_GUSENBERG = 4000,
    WEAPON_RPG = 6000
}

-- Webhook Discord
Config.DiscordWebhook = ''

-- Tempo da animação
Config.DestroyTime = 5000

-- Animação
Config.AnimDict = 'amb@prop_human_bum_bin@idle_b'
Config.Anim = 'idle_d'