#!/usr/bin/env osascript -l JavaScript

'use strict';

ObjC.import('stdlib')
ObjC.import('stdio')

function run(argv) {

  if (argv.length < 1 || argv.length > 2) {
    $.printf('%s', "Only one or two arguments allowed!")
    $.exit(1)
  }

  var hidden = false,
      path   = null

  if (argv.length == 2) {
    if (argv[0] == '-h' && argv[1] != '-h') {
      hidden = true
      path = argv[1]
    } else if(argv[0] != '-h' && argv[1] == '-h') {
      hidden = true
      path = argv[0]
    }
  } else {
    path = argv[0]
  }

  if (path == null) {
    $.exit(1)
  }

  var systemEvents = Application('System Events'),
      loginItems   = systemEvents.loginItems

  //console.log(Object.prototype.toString.call( systemEvents.loginItems.at(0) ))
  //
  //for (var i = 0; i < loginItems.length; i++) {
  //  var loginItem = loginItems[i],
  //      name = loginItem.name(),
  //      path = loginItem.path(),
  //      hidden = loginItem.hidden(),
  //      kind = loginItem.kind()
  //
  //  // console.log(Object.prototype.toString.call( loginItem ))
  //
  //  console.log(name)
  //  console.log(path)
  //  console.log(hidden)
  //  console.log(kind)
  //
  //  loginItem.hidden = false
  //}

  var newLoginItem = systemEvents.LoginItem({
    path: path,
    hidden: hidden
  })

  systemEvents.loginItems.push(newLoginItem)

  $.exit(0)
}
