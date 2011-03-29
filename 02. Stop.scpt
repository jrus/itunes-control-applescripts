--  Stop.applescript
--
--  Created by Jacob Rus on 2006-06-02.
--  Copyright (c) 2006. All rights reserved.

on run
  tell application "System Events"
    if (application processes whose name is "iTunes") is not {} then
      my main()
    end if
  end tell
end run

on main()
  registerWithGrowl()
  tell application "iTunes" to stop
  showCurrentTrack()
end main

on registerWithGrowl()
  set the_notifications to {"Current Track", "Toggle Shuffle", "Toggle Repeat"}
  
  tell application "GrowlHelperApp"
    register as application ¬
      "iTunes Controller Scripts" all notifications the_notifications ¬
      default notifications the_notifications ¬
      icon of application "iTunes"
  end tell
end registerWithGrowl

on showCurrentTrack()
  tell application "iTunes"
    -- Set the title of the notification
    try
      set note_title to name of current track as Unicode text
      
      -- Set the description of the notification
      set the_year to " (" & (year of current track as string) & ")"
      if the_year = " (0)" then set the_year to ""
      set note_desc to my playState() & "  " & my ratingStars(rating of current track) ¬
        & "\n" & artist of current track ¬
        & "\n" & album of current track & the_year
    on error
      set note_title to "Stopped" as Unicode text
      set note_desc to "" as Unicode text
    end try
    
    try
      set album_art to data of artwork 1 of current track
    on error
      set album_art to null
    end try
    
  end tell
  
  -- Put the notification on the screen
  tell application "GrowlHelperApp"
    if album_art is not null then
      notify with name ¬
        "Current Track" title note_title description note_desc ¬
        application name ¬
        "iTunes Controller Scripts" pictImage album_art
    else
      notify with name ¬
        "Current Track" title note_title description note_desc ¬
        application name "iTunes Controller Scripts"
    end if
  end tell
end showCurrentTrack

on ratingStars(the_rating)
  set star_string to "(" as Unicode text
  set black_star to «data utxt2605» as Unicode text
  set one_half to «data utxt00BD» as Unicode text
  set bullet to «data utxt200A00B7200A» as Unicode text
  
  repeat (the_rating div 20) times
    set star_string to star_string & black_star
  end repeat
  if 10 ≤ (the_rating mod 20) then
    set star_string to star_string & one_half
  end if
  repeat (6 - (length of star_string)) times
    set star_string to star_string & bullet
  end repeat
  set star_string to star_string & ")"
  -- if the_rating = 0 then set star_string to "(Unrated)"
  return star_string
end ratingStars

on playState()
  tell application "iTunes"
    if player state is paused then
      return «data utxt2759200A2759200A200A» as Unicode text
    else if player state is playing then
      return «data utxt25B6» as Unicode text
    else if player state is fast forwarding then
      return «data utxt25B625B6» as Unicode text
    else if player state is rewinding then
      return «data utxt25C025C0» as Unicode text
    else
      return «data utxt25FC» as Unicode text
      --return «data utxt2588» as Unicode text
    end if
  end tell
end playState