CFG = {}

CFG.Colis = {
    PossibleVehicleModel = {
        'rumpo',
        'adder'
    },
    PossibleVehiclePosition = {
        vector3(490.82, -1478.46, 29.13),
        vector3(491.73, -528.80, 24.75),
    },
    Errors = {
        ['autoevent:error:eventDoesNotExist'] = 'EventUid is invalid!'
    },
    TimeInterval = 1200000, -- Toutes les 20 minutes
    TimeDuration = 600000 -- 10 minutes
}

CFG.Eliminations = {
    PossiblePedModel = {
        'cs_bankman',
        'a_f_m_bevhills_02',
        'a_m_y_busicas_01',
        's_m_y_devinsec_01',
        'mp_f_deadhooker',
        'u_m_m_edtoh',
        'g_m_y_famfor_01',
        's_m_m_gentransport'
    },
    PossiblePedDefaultPosition = {

    },
    TimeInterval = 2400000, -- Toutes les 40 minutes
    TimeDuration = 600000, -- 10 minutes
    BlipsRadius = 1.2
}