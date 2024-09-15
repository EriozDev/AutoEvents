fx_version('cerulean')
game('gta5')
lua54('yes')

shared_scripts({
    'config.lua'
})

server_scripts({
    'server/main.lua'
})

client_scripts({
    'client/classes.lua',
    'client/main.lua',
    'client/events.lua'
})
