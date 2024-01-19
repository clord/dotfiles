import XMonad

import           System.Exit
import           XMonad.Util.Run                       ( safeSpawn
                                                       , spawnPipe
                                                       )
import XMonad.Util.EZConfig
import           Graphics.X11.ExtraTypes.XF86
import           XMonad.Actions.WithAll                ( killAll )
import XMonad.Util.Ungrab
import XMonad.Layout.ThreeColumns
import           XMonad.Layout.MultiToggle           ( Toggle(..)
                                                       , mkToggle
                                                       , single
                                                       )
import           XMonad.Util.NamedScratchpad           ( NamedScratchpad(..)
                                                       , customFloating
                                                       , defaultFloating
                                                       , namedScratchpadAction
                                                       , namedScratchpadManageHook
                                                       )
import           System.IO                             ( hPutStr
                                                       , hClose
                                                       )
import XMonad.Hooks.EwmhDesktops
import           XMonad.Layout.MultiToggle.Instances   ( StdTransformers(NBFULL) )
import XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks              ( Direction2D(..)
                                                       , ToggleStruts(..)
                                                       , avoidStruts
                                                       , docks
                                                       , docksEventHook
                                                       )
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers
import XMonad.Actions.Volume
import Data.Map    (fromList)
import Data.Monoid (mappend)
import XMonad.Util.NamedActions
import qualified XMonad.StackSet                       as W
import qualified XMonad.Util.NamedWindows              as W
import qualified Control.Exception                     as E
import           XMonad.Actions.DynamicWorkspaces      ( removeWorkspace )
import           XMonad.Actions.FloatKeys              ( keysAbsResizeWindow)

import           XMonad.Util.NamedActions             (  NamedAction (..)
                                                       , addDescrKeys'
                                                       , addName
                                                       , showKm
                                                       , subtitle
                                                       )
import XMonad.Layout.Spacing
--polybar--
import qualified Codec.Binary.UTF8.String              as UTF8
import qualified DBus                                  as D
import qualified DBus.Client                           as D

main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . keybindings
     . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig where
    keybindings c@XConfig {XMonad.modMask = m } = addDescrKeys' ((m, xK_F1), showKeybindings) myKeys c



myConfig = def
   { modMask = mod4Mask    -- Rebind Mod to the Super key
   , layoutHook = myLayout
   } 
  { normalBorderColor  = "#0000ff" -- Blue
  , focusedBorderColor = "#007700" -- Green
  }

myLayout = tiled ||| Mirror tiled ||| Full
  where
    tiled    = spacing 3 $ Tall nmaster delta ratio
    nmaster  = 1     -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes



type AppName      = String
type AppTitle     = String
type AppClassName = String
type AppCommand   = String

data App
  = ClassApp AppClassName AppCommand
  | TitleApp AppTitle AppCommand
  | NameApp AppName AppCommand
  deriving Show

audacious = ClassApp "Audacious"            "audacious"
calendar  = ClassApp "Orage"                "orage"
gimp      = ClassApp "Gimp"                 "gimp"
office    = ClassApp "libreoffice-draw"     "libreoffice-draw"
scr       = ClassApp "SimpleScreenRecorder" "simplescreenrecorder"
vlc       = ClassApp "Vlc"                  "vlc"
yad       = ClassApp "Yad"                  "yad --text-info --text 'XMonad'"

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
     




-- Key bindings. Add, modify or remove key bindings here.
--

myTerminal   = "terminator"
appLauncher  = "dmenu_run"
screenLocker = "multilockscreen -l dim"
playerctl c  = "playerctl --player=spotify,%any " <> c

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" . io $
  E.bracket (spawnPipe $ getAppCommand yad) hClose (\h -> hPutStr h (unlines $ showKm x))

myKeys conf@XConfig {XMonad.modMask = modm} =
  keySet "Audio"
    [ key "Mute"          (0, xF86XK_AudioMute              ) $ spawn "amixer -q set Master toggle"
    , key "Lower volume"  (0, xF86XK_AudioLowerVolume       ) $ spawn "amixer -q set Master 5%-"
    , key "Raise volume"  (0, xF86XK_AudioRaiseVolume       ) $ spawn "amixer -q set Master 5%+"
    , key "Play / Pause"  (0, xF86XK_AudioPlay              ) $ spawn $ playerctl "play-pause"
    , key "Stop"          (0, xF86XK_AudioStop              ) $ spawn $ playerctl "stop"
    , key "Previous"      (0, xF86XK_AudioPrev              ) $ spawn $ playerctl "previous"
    , key "Next"          (0, xF86XK_AudioNext              ) $ spawn $ playerctl "next"
    ] ^++^
  keySet "Launchers"
    [ key "Terminal"      (modm .|. shiftMask  , xK_Return  ) $ spawn (XMonad.terminal conf)
    , key "Dmenu"         (modm                , xK_p       ) $ spawn "dmenu_run"
    , key "Lock screen"   (modm .|. controlMask, xK_l       ) $ spawn screenLocker
    , key "vieb"  (modm                , xK_w       ) $ spawn "vieb"
    ] ^++^
  keySet "Layouts"
    [ key "Next"          (modm              , xK_space     ) $ sendMessage NextLayout
    , key "Reset"         (modm .|. shiftMask, xK_space     ) $ setLayout (XMonad.layoutHook conf)
    , key "Fullscreen"    (modm              , xK_f         ) $ sendMessage (Toggle NBFULL)
    ] ^++^
  keySet "Scratchpads"
    [ key "Audacious"       (modm .|. controlMask,  xK_a    ) $ runScratchpadApp audacious
    ] ^++^
  keySet "System"
    [ key "Toggle status bar gap"  (modm              , xK_b ) toggleStruts
    , key "Logout (quit XMonad)"   (modm .|. shiftMask, xK_q ) $ io exitSuccess
    , key "Restart XMonad"         (modm              , xK_q ) $ spawn "xmonad --recompile; xmonad --restart"
    , key "Capture entire screen"  (modm              , xK_Print ) $ spawn "flameshot full -p ~/Pictures/flameshot/"
    , key "Switch keyboard layout" (modm              , xK_F8 ) $ spawn "kls"
    , key "Disable CapsLock"       (modm              , xK_F9 ) $ spawn "setxkbmap -option ctrl:nocaps"
    ] ^++^
  keySet "Windows"
    [ key "Close focused"   (modm              , xK_BackSpace) kill
    , key "Close all in ws" (modm .|. shiftMask, xK_BackSpace) killAll
    , key "Refresh size"    (modm              , xK_n        ) refresh
    , key "Focus next"      (modm              , xK_Left     ) $ windows W.focusDown
    , key "Focus previous"  (modm              , xK_Right    ) $ windows W.focusUp
    , key "Focus master"    (modm              , xK_m        ) $ windows W.focusMaster
    , key "Swap master"     (modm              , xK_Return   ) $ windows W.swapMaster
    , key "Swap next"       (modm .|. shiftMask, xK_j        ) $ windows W.swapDown
    , key "Swap previous"   (modm .|. shiftMask, xK_k        ) $ windows W.swapUp
    , key "Shrink master"   (modm              , xK_Down     ) $ sendMessage Shrink
    , key "Expand master"   (modm              , xK_Up       ) $ sendMessage Expand
    ] ++ switchWsById
 where
  togglePolybar = spawn "polybar-msg cmd toggle &"
  toggleStruts = togglePolybar >> sendMessage ToggleStruts
  keySet s ks = subtitle s : ks
  key n k a = (k, addName n a)
  action m = if m == shiftMask then "Move to " else "Switch to "
  -- mod-[1..9]: Switch to workspace N | mod-shift-[1..9]: Move client to workspace N
  switchWsById =
    [ key (action m <> show i) (m .|. modm, k) (windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  switchScreen =
    [ key (action m <> show sc) (m .|. modm, k) (screenWorkspace sc >>= flip whenJust (windows . f))
        | (k, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m)  <- [(W.view, 0), (W.shift, shiftMask)]]


isInstance (ClassApp c _) = className =? c
isInstance (TitleApp t _) = title =? t
isInstance (NameApp n _)  = appName =? n

getNameCommand (ClassApp n c) = (n, c)
getNameCommand (TitleApp n c) = (n, c)
getNameCommand (NameApp  n c) = (n, c)

getAppName    = fst . getNameCommand
getAppCommand = snd . getNameCommand

scratchpadApp :: App -> NamedScratchpad
scratchpadApp app = NS (getAppName app) (getAppCommand app) (isInstance app) defaultFloating

runScratchpadApp = namedScratchpadAction scratchpads . getAppName

scratchpads = scratchpadApp <$> [ audacious]
