#!/usr/bin/python
# -*- coding: utf-8 -*-


import os, json, plistlib, uuid

preferences_plist = '/Library/Preferences/SystemConfiguration/preferences.plist'

os.system('sudo plutil -convert xml1 "%s"' % preferences_plist)
plist = plistlib.readPlist(preferences_plist)

network_services = plist['NetworkServices']

uni_vpn = uuid.uuid1()

for service in network_services:

  if network_services[service]['Interface']['Type'] == 'IPSec':
    if network_services[service]['IPSec']['RemoteAddress'].lower() == 'vpn1.uibk.ac.at':
      uni_vpn = service


# Change Settings



plist['NetworkServices'].update({ uni_vpn: 2 })
plist['NetworkServices'][uni_vpn]['IPSec']['AuthenticationMethod']    = 'SharedSecret'
plist['NetworkServices'][uni_vpn]['IPSec']['LocalIdentifier']         = 'uibk.ac.at'
plist['NetworkServices'][uni_vpn]['IPSec']['LocalIdentifierType']     = 'KeyID'
plist['NetworkServices'][uni_vpn]['IPSec']['RemoteAddress']           = 'vpn1.uibk.ac.at'
plist['NetworkServices'][uni_vpn]['IPSec']['SharedSecret']            = uni_vpn
plist['NetworkServices'][uni_vpn]['IPSec']['SharedSecretEncryption']  = 'Keychain'
plist['NetworkServices'][uni_vpn]['IPSec']['XAuthEnabled']            = 1
plist['NetworkServices'][uni_vpn]['IPSec']['XAuthName']               = 'cast2187'
plist['NetworkServices'][uni_vpn]['IPSec']['XAuthPassword']           = uni_vpn
plist['NetworkServices'][uni_vpn]['IPSec']['XAuthPasswordEncryption'] = 'Keychain'
plist['NetworkServices'][uni_vpn]['UserDefinedName']                  = 'Uni Innsbruck'

for disconnect in ['DisconnectOnWake',
                   'DisconnectOnSleep',
                   'DisconnectOnIdle',
                   'DisconnectOnLogout',
                   'DisconnectOnFastUserSwitch']:
  network_services[uni_vpn]['IPSec'][disconnect] = 1

plist['NetworkServices'][uni_vpn]['IPSec']['DisconnectOnIdleTimer']   = 60



for config in plist['Sets']:
  plist['Sets'][config]['Network']['Service'][uni_vpn]['__LINK__'] = '/NetworkServices/%s' % uni_vpn


plistlib.writePlist(plist, preferences_plist)



