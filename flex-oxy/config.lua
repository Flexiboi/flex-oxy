Config = {}
Config.Debug = false
Config.inventory = 'qb-inventory/html/images/'

Config.copsneeded = 1
Config.PoliceCallChance = 100 --has to be lower
Config.DefaultMulti = 4
Config.RepType = 'dealerrep'
Config.CopsMultiPly = {
    [1] = 1, --Config.Rewardamount * this (1)
    [2] = 2, --Config.Rewardamount * 2
    [3] = 3, --Config.Rewardamount * 3
    [4] = 4,
}

Config.DropOffCount = {
    Min = 3,
    Max = 5
}

Config.Rewardamount = math.random(1,3)
Config.RewardItem = 'black_money'

Config.DeliveryRepLoss = math.random(1,2)
Config.DeliveryRepWin = 1

Config.BeerItem = 'can_heineken'
Config.OxyItem = 'oxy'

Config.StartPed = {
    ped = 'a_m_o_soucent_03',
    scenario = "WORLD_HUMAN_BUM_STANDING",
    coords = vector4(727.08, -801.78, 24.93, 96.45)
}

Config.PedModels = {
    'a_m_y_hipster_03',
    'a_m_y_runner_01',
    'a_m_y_stbla_02',
    'a_m_y_skater_01',
    'a_f_o_salton_01',
    'a_f_y_tourist_02',
    'a_m_m_malibu_01',
    'a_m_m_salton_01',
    'a_m_m_soucent_03',
    'a_m_y_beach_01',
    'a_m_y_stlat_01'
}

Config.Scenario = {
    "WORLD_HUMAN_BUM_STANDING",
    "WORLD_HUMAN_MUSCLE_FLEX",
    "WORLD_HUMAN_TOURIST_MOBILE",
    "CODE_HUMAN_MEDIC_KNEEL"
}

Config.DeliveryLocs = {
    vector4(-293.27, 600.73, 181.58, 355.66),
    vector4(-99.12, 366.42, 113.27, 91.44),
    vector4(42.17, -59.97, 63.58, 97.75),
    vector4(228.69, -326.28, 44.27, 104.13),
    vector4(40.02, -908.14, 30.76, 354.46),
    vector4(217.56, -955.22, 29.36, 232.6),
    vector4(418.02, -971.27, 29.42, 133.56),
    vector4(-576.59, -1021.23, 22.18, 238.36),
    vector4(-324.57, -1355.95, 31.3, 83.11),
    vector4(-169.21, -1352.43, 29.98, 73.46),
    vector4(-985.79, -2149.84, 9.3, 334.68),
    vector4(-635.27, -1779.47, 24.1, 167.36),
    vector4(-265.15, -1025.66, 28.44, 199.97),
    vector4(-87.97, -843.1, 40.54, 144.38),
    vector4(-123.41, -812.98, 43.0, 43.46),
    vector4(-134.98, -673.98, 48.23, 35.59),
    vector4(12.13, -596.21, 31.63, 281.34),
    vector4(-345.46, -445.49, 32.04, 236.13)
}

Config.ShopBuyItem = 'black_money' -- or bank / cash for money

Config.Shop = {
    [1] = {
        repneeded = 1,
        item = 'stickynotelab',
        amount = 1,
        cost = 50,
        stock = 10,
        labinfo = {
            enable = true,
            info = {
                code = 5494,
                labname = 'Coke',
            }
        },
    },
    [2] = {
        repneeded = 25,
        item = 'knife_blade',
        amount = 1,
        cost = 50,
        stock = 2,
        labinfo = {
            enable = false,
            info = {
                code = nil,
                labname = nil,
            }
        },
    },
    [3] = {
        repneeded = 35,
        item = 'stickynotelab',
        amount = 1,
        cost = 50,
        stock = 10,
        labinfo = {
            enable = true,
            info = {
                code = 1743,
                labname = 'Meth',
            }
        },
    },
    [4] = {
        repneeded = 65,
        item = 'weaponpart_sns_trigger',
        amount = 1,
        cost = 135,
        stock = 3,
        labinfo = {
            enable = false,
            info = {
                code = nil,
                labname = nil,
            }
        },
    },
}