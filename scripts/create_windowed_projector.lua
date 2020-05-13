obs = obslua

projector_width = 1280
projector_height = 720
is_automatic = false

function d2hs(decimal)
  return string.format("%04x", decimal)
end

function d2hl(decimal)
  return string.format("%08x", decimal)
end

function h2b64(hex)
  local handle = assert(io.popen(string.format("echo %s | xxd -r -p | base64", string.upper(hex))))
  local base64 = handle:read("*all")
  handle:close()
  return base64
end

function get_screen_width()
  local handle = assert(io.popen([[system_profiler -json SPDisplaysDataType 2>/dev/null | python -c "import sys,json;d=next(i for i in json.load(sys.stdin)['SPDisplaysDataType'][0]['spdisplays_ndrvs'] if 'spdisplays_main' in i);print d['_spdisplays_pixels']"]]))
  local screen_resolution = handle:read("*all")
  handle:close()
  return tonumber(string.match(screen_resolution, "^%d+"))
end

-- QWidget::saveGeometry() refactored in Lua
-- If we really wanted to build this out, then it might be good to pull a live window geometry to determine the window chrome sizes
-- See https://github.com/qt/qtbase/blob/1c80d056e4f45b4ee7c4863cd792e83c889513c5/src/widgets/kernel/qwidget.cpp#L7166
function create_geometry()
  local magic_number = "01d9d0cb"
  local major_version = 3
  local minor_version = 0

  local window_x = 0
  local window_y = 0
  local window_width = projector_width
  local window_height = projector_height

  local frame_left = window_x
  local frame_top = window_y
  local frame_right = frame_left + window_width
  local frame_bottom = frame_top + window_height

  local normal_left = window_x
  local normal_top = window_y + 22
  local normal_right = normal_left + window_width
  local normal_bottom = normal_top + window_height

  local screen_number = 0
  local is_maximized = 0
  local is_fullscreen = 0

  local screen_width = get_screen_width()

  local screen_geometry_left = window_x
  local screen_geometry_top = window_y + 22
  local screen_geometry_right = screen_geometry_left + window_width
  local screen_geometry_bottom = screen_geometry_top + window_height

  local geometry_hex =
    magic_number..
    d2hs(major_version)..
    d2hs(minor_version)..
    d2hl(frame_left)..
    d2hl(frame_top)..
    d2hl(frame_right)..
    d2hl(frame_bottom)..
    d2hl(normal_left)..
    d2hl(normal_top)..
    d2hl(normal_right)..
    d2hl(normal_bottom)..
    d2hs(screen_number)..
    d2hs(is_maximized)..
    d2hs(is_fullscreen)..
    d2hl(screen_width)..
    d2hl(screen_geometry_left)..
    d2hl(screen_geometry_top)..
    d2hl(screen_geometry_right)..
    d2hl(screen_geometry_bottom)

  -- print(geometry_hex)

  return h2b64(geometry_hex)
end

function create_projector()
  local geometry = create_geometry()

  -- print(geometry)

  obs.obs_frontend_open_projector("Preview", -1, geometry, "")
end

function create_camtwist_profile()
  local profile_data = string.format([[<?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
    <key>$archiver</key>
    <string>NSKeyedArchiver</string>
    <key>$objects</key>
    <array>
      <string>$null</string>
      <string>DesktopPlus</string>
      <string>This screen</string>
      <string>{{0, 0}, {%d, %d}}</string>
      <string>Windowed Projector</string>
      <string>OBS</string>
      <string>Windowed Projector (Preview)</string>
      <string>{{0, 0}, {%d, %d}}</string>
    </array>
    <key>$top</key>
    <dict>
      <key>appName</key>
      <dict>
        <key>CF$UID</key>
        <integer>5</integer>
      </dict>
      <key>appTitle</key>
      <dict>
        <key>CF$UID</key>
        <integer>6</integer>
      </dict>
      <key>class</key>
      <dict>
        <key>CF$UID</key>
        <integer>1</integer>
      </dict>
      <key>confine</key>
      <true/>
      <key>cropRect</key>
      <dict>
        <key>CF$UID</key>
        <integer>7</integer>
      </dict>
      <key>doNotScale</key>
      <true/>
      <key>enabled</key>
      <true/>
      <key>filterWindows</key>
      <true/>
      <key>fullScreen</key>
      <false/>
      <key>regex</key>
      <dict>
        <key>CF$UID</key>
        <integer>4</integer>
      </dict>
      <key>regexSearch</key>
      <false/>
      <key>resizable</key>
      <false/>
      <key>screen</key>
      <dict>
        <key>CF$UID</key>
        <integer>2</integer>
      </dict>
      <key>showMouse</key>
      <false/>
      <key>viewPortRect</key>
      <dict>
        <key>CF$UID</key>
        <integer>3</integer>
      </dict>
    </dict>
    <key>$version</key>
    <integer>100000</integer>
  </dict>
  </plist>]],
  projector_width,
  projector_height,
  projector_width,
  projector_height)

  -- print(profile_data)

  local handle = assert(io.popen(string.format("echo '%s' | plutil -convert binary1 - -o - | base64", profile_data)))
  local encoded_profile_data = handle:read("*all")
  handle:close()

  -- print(encoded_profile_data)

  local profile_plist = string.format([[<?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
    <key>encoded</key>
    <array>
      <data>%s</data>
    </array>
    <key>midiKey</key>
    <integer>0</integer>
  </dict>
  </plist>]],
  encoded_profile_data)

  -- print(profile_plist)

  local plist = assert(io.open(os.getenv('HOME') .. '/Library/Application Support/CamTwist/Saved Setups/iPhone', 'w'))
  plist:write(profile_plist)
  plist:close()
end

function update_camtwist_configuration()
  local camtwist_profile_path = os.getenv('HOME') .. '/Library/Preferences/com.allocinit.CamTwist.plist'
  local camtwist_assistant_profile_path = os.getenv('HOME') .. '/Library/Preferences/com.allocinit.CamTwist_Assistant.plist'

  local handle = assert(io.popen(string.format([[\
    plutil -replace autoload -string iPhone %s && \
    plutil -replace frameRate -integer 30 %s && \
    plutil -replace noVirtualDriver -bool false %s && \
    plutil -replace usingCustomVideoSize -bool true %s && \
    plutil -replace videoSize -string "{%d, %d}" %s && \
    plutil -replace videoSize -string "{%d, %d}" %s
  ]],
  camtwist_profile_path,
  camtwist_profile_path,
  camtwist_profile_path,
  camtwist_profile_path,
  projector_width,
  projector_height,
  camtwist_profile_path,
  projector_width,
  projector_height,
  camtwist_assistant_profile_path)))
  local result = handle:read("*all")
  print(result)
  handle:close()
end

function self_sign_zoom()
  local applescript = os.tmpname()
  local handle = assert(io.open(applescript, 'w'))
  handle:write([[
  display dialog "A Terminal window will now be launched, and you will be prompted to enter your password.\n\nThis is required in order to self-sign Zoom, which will enable it to recognize the CamTwist virtual camera.\n\nEnter your password, then press Return." buttons {"Continue"}

  tell application "Terminal"
    activate
    do script "sudo codesign -f -s - /Applications/zoom.us.app && kill -9 $$"
    delay 5
    repeat
      try
        do shell script "ps a | grep -v grep | grep 'sudo codesign -f -s - /Applications/zoom.us.app'"
        delay 0.5
      on error
        exit repeat
      end try
    end repeat
    close front window
  end tell
  ]])
  handle:close()
  os.execute(string.format("chmod +x %s && osascript %s", applescript, applescript))
  os.remove(applescript)
end

function script_properties()
  local props = obs.obs_properties_create()

  obs.obs_properties_add_int(props, "projector_width", "Projector Width", 640, 3840, 1)
  obs.obs_properties_add_int(props, "projector_height", "Projector Height", 480, 2160, 1)
  obs.obs_properties_add_bool(props, "is_automatic", "Open projector automatically on startup?")
  obs.obs_properties_add_button(props, "create_projector", "Create Windowed Projector", create_projector)
  obs.obs_properties_add_button(props, "create_camtwist", "Create CamTwist Profile", create_camtwist_profile)
  obs.obs_properties_add_button(props, "update_camtwist", "Update CamTwist Configuration", update_camtwist_configuration)
  obs.obs_properties_add_button(props, "sign_zoom", "Self-sign Zoom Application", self_sign_zoom)

  return props
end

function script_load(settings)
  projector_width = obs.obs_data_get_int(settings, "projector_width")
  projector_height = obs.obs_data_get_int(settings, "projector_height")
  is_automatic = obs.obs_data_get_bool(settings, "is_automatic")

  if is_automatic then
    create_projector()
  end
end

function script_defaults(settings)
  obs.obs_data_set_int(settings, "projector_width", 1280)
  obs.obs_data_set_int(settings, "projector_height", 720)
  obs.obs_data_set_bool(settings, "is_automatic", true)
end

function script_update(settings)
  projector_width = obs.obs_data_get_int(settings, "projector_width")
  projector_height = obs.obs_data_get_int(settings, "projector_height")
  is_automatic = obs.obs_data_get_bool(settings, "is_automatic")
end

function script_description()
  return "Creates preciscely sized windowed projectors on macOS."
end