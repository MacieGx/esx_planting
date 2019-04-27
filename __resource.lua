resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

Discription "Receptury by mWojtasik (Oesis.pl)"

Version "2.0"

server_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'server/main.lua'
}

client_scripts {
    'config.lua',
    '@es_extended/locale.lua',
    'client/main.lua',
    'locales/pl.lua'
}
