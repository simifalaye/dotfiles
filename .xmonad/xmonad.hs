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
import XMonad.Actions.CopyWindow (kill1, copyToAll, killAllOtherCopies, runOrCopy)
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Actions.CycleWS

-- Layouts modifiers
import XMonad.Layout.WorkspaceDir
import XMonad.Layout.Spacing (spacing)
import XMonad.Layout.NoBorders

-- Layouts
import XMonad.Layout.Tabbed

-- Prompts
import XMonad.Prompt (defaultXPConfig, XPConfig(..), XPPosition(Top), Direction1D(..))

-------------------------------------------------------------------------------
-- User Config --

myFont        = "xft:MesloLGS NF:regular:pixelsize=12"
myModMask     = mod4Mask    -- Sets modkey to super/windows key
myTerminal    = "alacritty" -- Sets default terminal
myTextEditor  = "vim"       -- Sets default text editor
myBorderWidth = 3           -- Sets border width for windows
myGaps        = 2           -- Sets the gap between windows

-- Base16 Colors
base00 = "#000000"
base01 = "#282828"
base02 = "#383838"
base03 = "#585858"
base04 = "#B8B8B8"
base05 = "#D8D8D8"
base06 = "#E8E8E8"
base07 = "#F8F8F8"
base08 = "#AB4642"
base09 = "#DC9656"
base0A = "#F7CA88"
base0B = "#A1B56C"
base0C = "#86C1B9"
base0D = "#7CAFC2"
base0E = "#BA8BAF"
base0F = "#A16946"

-------------------------------------------------------------------------------
-- Main --

main = do
    xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc"
    xmonad $ ewmh desktopConfig
        { manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageHook desktopConfig <+> manageDocks
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc x
                        , ppCurrent = xmobarColor base0D "" . wrap "[" "]" -- Current workspace in xmobar
                        , ppVisible = xmobarColor base05 ""                -- Visible but not current workspace
                        , ppHidden = xmobarColor base0A ""                 -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor base03 ""        -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor base07 "" . shorten 60     -- Title of active window in xmobar
                        , ppSep =  "<fc=#666666> | </fc>"                  -- Separators in xmobar
                        , ppUrgent = xmobarColor base08 "" . wrap "!" "!"  -- Urgent workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
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
    spawnOnce "$HOME/.xmonad/bin/env.sh"
    spawn "$HOME/.xmonad/bin/autostart.sh"

-------------------------------------------------------------------------------
-- Keybinds --

myKeys =
    -- Xmonad
    [ ("M-C-r", spawn "xmonad --recompile")      -- Recompiles xmonad
    , ("M-S-r", spawn "xmonad --restart")        -- Restarts xmonad
    , ("M-S-q", io exitSuccess)                  -- Quits xmonad

    --- Run
    , ("M-<Return>", spawn (myTerminal))
    , ("M-p", spawn "rofi -combi-modi \"window,drun\" -show combi")
    , ("M-S-p", spawn "dmenu_run")
    , ("M-C-l", spawn "slock")

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
    , ("M-<Space>", sendMessage NextLayout)        -- Switch to next layout
    , ("M-b",       sendMessage ToggleStruts)      -- Toggles struts
    , ("M-i",       sendMessage (IncMasterN 1))    -- Increase number of clients in the master pane
    , ("M-d",       sendMessage (IncMasterN (-1))) -- Decrease number of clients in the master pane
    , ("M-h",       sendMessage Shrink)            -- Increase master area
    , ("M-l",       sendMessage Expand)            -- Decrease master area

    -- Workspaces
    , ("M-<Tab>", toggleWS)      -- Switch to last WS
    , ("M-,", prevScreen)        -- Switch focus to prev monitor
    , ("M-.", nextScreen)        -- Switch focus to next monitor
    , ("M-S-,", shiftPrevScreen) -- Move window to prev monitor
    , ("M-S-.", shiftNextScreen) -- Move window to next monitor

    -- Multimedia Keys
    , ("<XF86MonBrightnessUp>", spawn "bright")
    , ("<XF86MonBrightnessDown>", spawn "bright -d")
    , ("<XF86AudioMute>",   spawn "~/.xmonad/bin/volume.sh mute")
    , ("<XF86AudioLowerVolume>", spawn "~/.xmonad/bin/volume.sh dec")
    , ("<XF86AudioRaiseVolume>", spawn "~/.xmonad/bin/volume.sh inc")
    , ("<Print>", spawn "~/.xmonad/bin/screenshot.sh -f")
    ] where nonNSP          = WSIs (return (\ws -> W.tag ws /= "nsp"))
            nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))

-- Mouse bindings: default actions bound to mouse events
myMouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList
    -- mod-button1 %! Set the window to floating mode and move by dragging
    [ ((modMask, button1), \w -> focus w >> mouseMoveWindow w
                                          >> windows W.shiftMaster)
    -- mod-button2 %! Raise the window to the top of the stack
      , ((modMask, button2), windows . (W.shiftMaster .) . W.focusWindow)
    -- mod-button3 %! Set the window to floating mode and resize by dragging
      , ((modMask, button3), \w -> focus w >> mouseResizeWindow w
                                         >> windows W.shiftMaster)
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
    ["1:web", "2:dev", "3:chat", "4:vid", "5:doc", "6:misc", "7:misc", "8:misc", "9:sys"]
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
     , className =? "Firefox" --> doShift "<action=xdotool key super+1>1:web</action>"
     , className =? "zoom" --> doShift "<action=xdotool key super+4>4:vid</action>"
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
