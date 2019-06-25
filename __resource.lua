resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Car Test Drive'

version '1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/testdrive_sv.lua',
}

client_scripts {
	'@es_extended/locale.lua',
	'client/utils.lua',
	'client/testdrive_cl.lua',
}

dependency 'es_extended'

export 'GeneratePlate'
