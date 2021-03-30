{- xmonad.hs
 - Modified version from repo:
 -    https://github.com/simlu/xmonad
 -}

-------------------------------------------------------------------------------
-- Imports --
-- stuff
import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit
import Graphics.X11.Xlib
import System.IO (Handle, hPutStrLn)
import XMonad.Actions.CycleWS
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.SpawnOn
import XMonad.Hooks.EwmhDesktops

-- utils
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

-- hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog

-- layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile

-------------------------------------------------------------------------------
-- Main --
main = do
       h <- spawnPipe "xmobar -d"
       xmonad $ ewmh $ def
              { workspaces = workspaces'
              , modMask = modMask'
              , borderWidth = borderWidth'
              , normalBorderColor = normalBorderColor'
              , focusedBorderColor = focusedBorderColor'
              , terminal = terminal'
              , keys = keys'
              , mouseBindings = myMouseBindings
              , layoutHook = layoutHook'
              , manageHook = manageHook'
              , focusFollowsMouse = myFocusFollowsMouse
              , clickJustFocuses = myClickJustFocuses
              , startupHook = startupHook'
              , handleEventHook = handleEventHook def <+> docksEventHook <+> fullscreenEventHook
              , logHook = dynamicLogWithPP $ xmobarPP { ppOutput = hPutStrLn h, ppOrder = reverse }
              }

-------------------------------------------------------------------------------
-- Hooks --

manageHook' :: ManageHook
manageHook' = manageHook def <+> manageDocks

layoutHook' = customLayout

startupHook' :: X ()
startupHook' = do
    spawnOnce "$HOME/.xmonad/bin/env.sh"
    spawn "$HOME/.xmonad/bin/autostart.sh"

-------------------------------------------------------------------------------
-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether a mouse click select the focus or is just passed to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- borders
borderWidth' :: Dimension
borderWidth' = 2

normalBorderColor', focusedBorderColor' :: String
normalBorderColor'  = "#000000"
focusedBorderColor' = "#7CAFC2"

-- workspaces
workspaces' :: [WorkspaceId]
workspaces' = ["1:Web", "2:Chat", "3:Doc", "4", "5", "6", "7", "8:Dev", "9:Sys", "0:Tray"]

-- layouts
customLayout = avoidStruts $ tiled ||| Mirror tiled  ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

-------------------------------------------------------------------------------
-- Terminal --
terminal' :: String
terminal' = "alacritty"

-------------------------------------------------------------------------------
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
-- Keys/Button bindings --
-- modmask
modMask' :: KeyMask
modMask' = mod4Mask

-- keys
keys' :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- print screen
    [ ((modMask .|. controlMask, xK_p   ), spawn "sleep 0.2; import ~/screenshot.png")

    -- lock screen
    , ((modMask .|. controlMask, xK_l   ), spawn "slock")

    -- launching and killing programs
    , ((modMask,               xK_Return), spawn $ XMonad.terminal conf)
    , ((modMask,               xK_space ), spawn "j4-dmenu-desktop")
    , ((modMask .|. shiftMask, xK_space ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
    , ((modMask,               xK_o     ), spawn (terminal' ++ " -e htop"))
    , ((modMask,               xK_q     ), kill)

    -- layouts
    , ((modMask,               xK_y ), sendMessage NextLayout)
    , ((modMask .|. shiftMask, xK_y ), setLayout $ XMonad.layoutHook conf)
    , ((modMask .|. shiftMask, xK_b ), sendMessage ToggleStruts)

    -- Tiled, Fullscreen, Floating
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)
    , ((modMask,               xK_f     ),
        withFocused $ windows . (flip W.float $ W.RationalRect 0 0 1 1))
    , ((modMask .|. shiftMask, xK_f     ),
        withFocused $ windows . (flip W.float $ W.RationalRect 0.1 0.1 0.8 0.8))

    -- refresh (resize viewed windows to correct size
    , ((modMask,               xK_r     ), refresh)

    -- move focus between screens
    , ((modMask,               xK_comma ),  prevScreen)
    , ((modMask,               xK_period),  nextScreen)
    , ((modMask .|. shiftMask, xK_comma ),  shiftPrevScreen)
    , ((modMask .|. shiftMask, xK_period),  shiftNextScreen)

    -- focus
    , ((modMask,               xK_j     ), windows W.focusDown)
    , ((modMask,               xK_k     ), windows W.focusUp)
    , ((modMask,               xK_m     ), windows W.focusMaster)
    , ((mod1Mask,              xK_Tab   ), windows W.focusDown)

    -- swapping
    , ((modMask .|. shiftMask, xK_m     ), windows W.swapMaster)
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- workspace
    , ((modMask,               xK_n  ), nextWS)
    , ((modMask,               xK_p  ), prevWS)
    , ((modMask .|. shiftMask, xK_n  ), shiftToNext)
    , ((modMask .|. shiftMask, xK_p  ), shiftToPrev)
    , ((modMask,               xK_Tab), toggleWS)

    -- increase or decrease number of windows in the master area
    , ((modMask              , xK_i     ), sendMessage (IncMasterN 1))
    , ((modMask              , xK_d     ), sendMessage (IncMasterN (-1)))

    -- resizing
    , ((modMask,               xK_h     ), sendMessage Shrink)
    , ((modMask,               xK_l     ), sendMessage Expand)
    , ((modMask .|. shiftMask, xK_h     ), sendMessage MirrorShrink)
    , ((modMask .|. shiftMask, xK_l     ), sendMessage MirrorExpand)

    -- XF86AudioMute
    , ((0 , 0x1008ff12), spawn "~/.xmonad/bin/volumectl.sh mute")
    -- XF86AudioLowerVolume
    , ((0 , 0x1008ff11), spawn "~/.xmonad/bin/volumectl.sh dec")
    -- XF86AudioRaiseVolume
    , ((0 , 0x1008ff13), spawn "~/.xmonad/bin/volumectl.sh inc")

    -- quit, or restart
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modMask .|. shiftMask, xK_r     ), restart "xmonad" True)
    ]
    ++
    -- mod-[1..9, 0] %! Switch to workspace N
    -- mod-shift-[1..9, 0] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

