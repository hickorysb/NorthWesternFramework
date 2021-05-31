fx_version "adamant"
game "gta5"

version "1.0.0"
author "NorthWesternBear <hickorysmokedbacon.yt@gmail.com>"
description "Multi-character support for the NorthWesternFramework."

client_scripts {
    "client/*.lua"
}
server_scripts {
    "server/*.lua"
}

dependency "nwf-core"

files {
    "html/*.html",
    "html/*.js",
    "html/*.png",
    "html/*.css",
    "html/*.jpg"
}

ui_page "html/character.html"
