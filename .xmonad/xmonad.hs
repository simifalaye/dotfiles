-- Base
import XMonad
import qualified Data.Map as M
import XMonad.Config.Desktop
import Data.Monoid
import Data.Maybe (isJust)
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Utilities
import XMonad.Util.EZConfig (additionalKeysP, additionalMouseBindings)
import XMonad.Util.Run (safeSpawn, runInTerm, spawnPipe)
import XMonad.Util.SpawnOnce

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops

-- Actions
import qualified XMonad.Actions.Search as S
import XMonad.Actions.CopyWindow (kill1, copyToAll, killAllOtherCopies, runOrCopy)
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Actions.CycleWS
import XMonad.Actions.UpdatePointer

-- Layouts modifiers
import XMonad.Layout.WorkspaceDir
import XMonad.Layout.Spacing (spacing)
import XMonad.Layout.NoBorders

-- Layouts
import XMonad.Layout.Tabbed

-- Prompts
import XMonad.Prompt (defaultXPConfig, XPConfig(..), XPPosition(Top), Direction1D(..))
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Ssh

-------------------------------------------------------------------------------
-- User Config --

myScriptPath  = "~/.xmonad/bin/"
myFont        = "xft:MesloLGS NF:regular:pixelsize=12"
myModMask     = mod4Mask    -- Sets modkey to super/windows key
myTerminal    = "alacritty" -- Sets default terminal
myTextEditor  = "vim"       -- Sets default text editor
myBorderWidth = 3           -- Sets border width for windows
myGaps        = 2           -- Sets the gap between windows

-- Base16 Colors
base00 = "#000000" -- Black
base01 = "#282828" -- Black 1
base02 = "#383838" -- Black 2
base03 = "#585858" -- Bright Black
base04 = "#B8B8B8" -- Grey
base05 = "#D8D8D8" -- White
base06 = "#E8E8E8" -- White 1
base07 = "#F8F8F8" -- Bright White
base08 = "#AB4642" -- Red
base09 = "#DC9656" -- Orange
base0A = "#F7CA88" -- Yellow/Bright-Yellow
base0B = "#A1B56C" -- Green/Bright-Green
base0C = "#86C1B9" -- Cyan/Bright-Cyan
base0D = "#7CAFC2" -- Blue/Bright-Blue
base0E = "#BA8BAF" -- Magenta/Bright-Magenta
base0F = "#A16946" -- Brown

-------------------------------------------------------------------------------
-- Main --

main = do
    xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc"
    xmonad $ ewmh desktopConfig
        { manageHook = ( isFullscreen --> doFullFloat )
            <+> myManageHook
            <+> manageHook desktopConfig
            <+> manageDocks
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc x
                        , ppCurrent = xmobarColor base00 base0D        -- Current workspace in xmobar
                        , ppVisible = xmobarColor base05 ""            -- Visible but not current workspace
                        , ppHidden = xmobarColor base05 ""             -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor base03 ""    -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor base0D "" . shorten 60 -- Title of active window in xmobar
                        , ppSep =  "<fc=" ++ base04 ++ "> | </fc>"     -- Separators in xmobar
                        , ppUrgent = xmobarColor base08 ""             -- Urgent workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
                        >> updatePointer (0.5, 0.5) (0, 0) -- Automove pointer
        , modMask            = myModMask
        , terminal           = myTerminal
        , mouseBindings      = myMouseBindings
        , startupHook        = myStartupHook
        , layoutHook         = myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = base00
        , focusedBorderColor = base0D
        } `additionalKeysP` myKeys

-------------------------------------------------------------------------------
-- Startup --

myStartupHook = do
    setWMName "LG3D" -- Fix Java apps
    spawnOnce "xset s 3600 3600" -- Change sleep time to 1 hr
    spawnOnce "xsetroot -cursor_name left_ptr" -- Change default cursor
    spawnOnce "gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh" -- For Gnome apps
    spawnOnce (myScriptPath ++ "screen_layout.sh")
    spawnOnce (myScriptPath ++ "start.sh dunst")
    spawnOnce (myScriptPath ++ "start.sh compton --config ~/.config/compton/compton.conf")
    spawnOnce (myScriptPath ++ "start.sh redshift -l geoclue2")
    spawnOnce (myScriptPath ++ "start.sh trayer \
                \ --edge top --align right --widthtype request \
                \ --padding 6 --SetDockType true --SetPartialStrut true \
                \ --expand true --monitor 1 --transparent true --alpha 0 \
                \ --tint 0x000000 --height 20 --iconspacing 2")
    spawnOnce (myScriptPath ++ "start.sh pasystray")
    spawnOnce (myScriptPath ++ "start.sh nm-applet")
    spawnOnce (myScriptPath ++ "start.sh xautolock -time 30 -locker slock -notify 10")
    spawnOnce "nitrogen --restore"

-------------------------------------------------------------------------------
-- Keybinds --

myKeys =
    -- Xmonad
    [ ("M-C-r", spawn "xmonad --recompile")      -- Recompiles xmonad
    , ("M-S-r", spawn "xmonad --restart")        -- Restarts xmonad
    , ("M-S-q", io exitSuccess)                  -- Quits xmonad

    --- Run
    , ("M-<Return>", spawn (myTerminal))
    , ("M-p",        spawn "rofi -show drun")
    , ("M-S-p",      spawn "~/.config/rofi/bin/power.sh")
    , ("M-C-l",      spawn "slock")

    -- Windows
    , ("M-q",   kill1)         -- Kill the currently focused client
    , ("M-t",   withFocused $ windows .W.sink)
    , ("M-f",   withFocused $ windows . (flip W.float $ W.RationalRect 0 0 1 1))
    , ("M-S-f", withFocused $ windows . (flip W.float $ W.RationalRect 0.1 0.1 0.8 0.8))

    -- Windows navigation
    , ("M-m",   windows W.focusMaster) -- Move focus to the master window
    , ("M-j",   windows W.focusDown)   -- Move focus to the next window
    , ("M-k",   windows W.focusUp)     -- Move focus to the prev window
    , ("M-S-m", windows W.swapMaster)  -- Swap the focused window and the master window
    , ("M-S-j", windows W.swapDown)    -- Swap the focused window with the next window
    , ("M-S-k", windows W.swapUp)      -- Swap the focused window with the prev window

    -- Layouts
    , ("M-S-<Space>", sendMessage NextLayout)        -- Switch to next layout
    , ("M-b",         sendMessage ToggleStruts)      -- Toggles struts (bar)
    , ("M-i",         sendMessage (IncMasterN 1))    -- Increase number of master clients
    , ("M-d",         sendMessage (IncMasterN (-1))) -- Decrease number of master clients
    , ("M-h",         sendMessage Shrink)            -- Increase master area
    , ("M-l",         sendMessage Expand)            -- Decrease master area

    -- Workspaces
    , ("M-<Tab>", toggleWS)        -- Switch to last WS
    , ("M-,",     prevScreen)      -- Switch focus to prev monitor
    , ("M-.",     nextScreen)      -- Switch focus to next monitor
    , ("M-S-,",   shiftPrevScreen) -- Move window to prev monitor
    , ("M-S-.",   shiftNextScreen) -- Move window to next monitor

    -- Multimedia Keys
    , ("<XF86MonBrightnessUp>",   spawn "xbacklight -inc 10")
    , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10")
    , ("<XF86AudioMute>",         spawn (myScriptPath ++ "volume.sh mute"))
    , ("<XF86AudioLowerVolume>",  spawn (myScriptPath ++ "volume.sh dec"))
    , ("<XF86AudioRaiseVolume>",  spawn (myScriptPath ++ "volume.sh inc"))
    , ("<Print>",                 spawn (myScriptPath ++ "screenshot.sh -f"))

    -- Graphical apps (M-g + ...)
    , ("M-g b", spawn "firefox")
    , ("M-g f", spawn "nautilus")
    , ("M-g w", spawn "nitrogen")
    -- Terminal apps (M-r + ...)
    , ("M-r h", spawn (myTerminal ++ " -e zsh -i -c htop"))
    , ("M-r e", spawn (myTerminal ++ " -e zsh -i -c nvim"))
    , ("M-r n", spawn (myTerminal ++ " -e zsh -i -c n"))
    , ("M-r c", spawn (myTerminal ++ " -e zsh -i -c calc"))
    -- Environment (M-e + ...)
    , ("M-e c", spawn (myScriptPath ++ "start.sh compton --config ~/.config/compton/compton.conf"))
    , ("M-e d", spawn (myScriptPath ++ "start.sh dunst"))
    ]
    -- Appending some extra xprompts to keybindings list.
    -- Look at "xprompt settings" section this of config for values for "k".
    ++ [("M-x " ++ k, f sXPConfig) | (k,f) <- promptList ]
    -- Appending search engine prompts to keybindings list.
    -- Look at "search engines" section of this config for values for "k".
    ++ [("M-s " ++ k, S.promptSearch sXPConfig f) | (k,f) <- searchList ]
        where nonNSP          = WSIs (return (\ws -> W.tag ws /= "nsp"))
              nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))

-- Mouse bindings: default actions bound to mouse events
myMouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList
    -- mod-button1 %! Set the window to floating mode and move by dragging
    [ ((modMask, button1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
    -- mod-button2 %! Raise the window to the top of the stack
      , ((modMask, button2), windows . (W.shiftMaster .) . W.focusWindow)
    -- mod-button3 %! Set the window to floating mode and resize by dragging
      , ((modMask, button3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

-------------------------------------------------------------------------------
-- Workspaces --

xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape) $
    ["1:Web", "2:Dev", "3:Chat", "4:Vid", "5:Doc", "6:Misc", "7:Misc", "8:Misc", "9:Sys"]
        where
            clickable l =
                [
                    "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                    (i,ws) <- zip [1..9] l,
                    let n = i
                ]

-------------------------------------------------------------------------------
-- Manage Hook --
-- Run: `xprop` and click on a window to get it's name and class

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     [ className =? "Arandr"  --> doFloat
     , className =? "Firefox" --> doShift "<action=xdotool key super+1>1:Web</action>"
     , className =? "zoom" --> doShift "<action=xdotool key super+4>4:Vid</action>"
     , className =? "trayer"  --> doIgnore
     ]

-------------------------------------------------------------------------------
-- Layouts --

myLayout = tiled ||| Mirror tiled  ||| simpleTabbed ||| Full
    where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

myLayoutHook = avoidStruts $ spacing myGaps $ myLayout

------------------------------------------------------------------------
-- Xprompt Settings --

sXPConfig :: XPConfig
sXPConfig = def
    { font = myFont
    , bgColor             = base00
    , fgColor             = base07
    , bgHLight            = base0D
    , fgHLight            = base00
    , borderColor         = base00
    , promptBorderWidth   = 0
    , position            = Top
    , height              = 20
    , historySize         = 256
    , historyFilter       = id
    , defaultText         = []
    , autoComplete        = Nothing
    , showCompletionOnTab = False
    , searchPredicate     = fuzzyMatch
    , alwaysHighlight     = True
    , maxComplRows        = Just 15 -- set to Just 5 for 5 rows
    }

-- A list of all of the standard Xmonad prompts and a key press assigned to them.
-- These are used in conjunction with keybinding I set later in the config.
promptList :: [(String, XPConfig -> X ())]
promptList = [ ("m", manPrompt)          -- manpages prompt
             , ("r", shellPrompt)        -- run an application
             , ("s", sshPrompt)          -- ssh prompt
             ]
-- Search engines to use.
searchList :: [(String, S.SearchEngine)]
searchList = [ ("d", S.duckduckgo)
             , ("g", S.google)
             , ("i", S.images)
             , ("t", S.thesaurus)
             , ("v", S.vocabulary)
             , ("w", S.wikipedia)
             , ("y", S.youtube)
             ]
