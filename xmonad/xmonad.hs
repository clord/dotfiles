import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.StackSet as W
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Config.Desktop(desktopConfig)
import XMonad.Actions.SpawnOn(spawnHere,  Spawner)
import XMonad.Hooks.SetWMName(setWMName)
import XMonad.Layout.PerWorkspace as PW
import XMonad.Layout.Tabbed
import XMonad.Layout.Spiral
import XMonad.Layout.Circle
import XMonad.Layout.Accordion
import XMonad.Layout.NoBorders
import Data.Char
import System.IO
import ChrisConfig

-- Workspace names without numbers
wsn = [":tx", ":ed" ,":tm", ":nt", ":wb", ":vc", ":tp", ":ei", ":im"]

-- workspace names with a prefix corresponding to the digits [1..9]
ws = zipWith (:) ['1'..] wsn

-- font configuration
defaultFont = Liberation
smlFont = makeSpec defaultFont 10
medFont = makeSpec defaultFont 12
bigFont = makeSpec defaultFont 15


-- The layout we'll use for the workspaces.
localLayoutHook = smartBorders
                $ avoidStruts
                $ PW.onWorkspaces [ws!!3, ws!!4, ws!!5] (noBorders simpleTabbed)
                $   Tall 1 0.03 0.5
                ||| noBorders Full
                ||| spiral (6/7)
                ||| Accordion
                ||| noBorders Circle
                ||| noBorders simpleTabbed

-- Primary entrypoint
main :: IO ()
main = do
          xmobar <- spawnPipe "xmobar ~/.xmobarrc"
          spawn "empathy"
          xmonad $ desktopConfig {
                 borderWidth        = 1
               , normalBorderColor  = "grey10"
               , startupHook        = setWMName "LG3D"
               , focusedBorderColor = "gray70"
               , XMonad.workspaces  = ws
               , manageHook         = manageDocks <+> zManageHook <+> manageHook defaultConfig
               , layoutHook         = localLayoutHook
               , modMask            = mod4Mask
               , terminal           = getTerminal $ medFont
               , logHook            = dynamicLogWithPP $ xmobarPP {
                                                  ppOutput = hPutStrLn xmobar,
                                                  ppTitle = xmobarColor "green" "" . shorten 90 }
             } `additionalKeys`
              ([m4  xK_a  $ spawnEditorIn "Asti" "/media/bloor/asti"
               ,m4  xK_r  $ spawnEditorIn "Root" "/media/bloor"
               ,m4  xK_n  $ spawn "/opt/ibm/lotus/notes/notes"
               ,m4  xK_v  $ spawn "/usr/bin/nvidia-settings"
               ,m4  xK_g  $ spawn "/usr/bin/google-chrome"
               ,m4  xK_s  $ spawn "/usr/bin/gnome-screensaver-command -a"
               ,m4  xK_h  $ spawn "/usr/bin/cmvc-client-gui"
               ,m1  xK_w  kill
               ]
               ++ (term_launchers Sparky   [xK_F1, xK_F2, xK_F3, xK_F4])
               ++ (term_launchers Bloor    [xK_F5, xK_F6, xK_F7, xK_F8])
               ++ (term_launchers Brimley  [xK_F9, xK_F10, xK_F11, xK_F12])
        --       ++ (term_launchers sp Terran   )
              )
         where m4 a = (,) (mod4Mask, a)
               m1 a = (,) (mod1Mask, a)
               m4s a = (,) ((mod4Mask .|. shiftMask), a)
               rta machine font tid = runInXTerm color font cmd
                                 where cmd = screenOn machine tid
                                       color = csForMachine machine $ tid - 1
               term_launchers machine keys = [makepair kb md | md <- idxkeys, kb <- keyfnt]
                                          where idxkeys = zip keys [1..]
                                                keyfnt = zip [smlFont,  bigFont]
                                                             [mod4Mask, mod4Mask .|. shiftMask]
                                                makepair kb md = ((snd kb, fst md),
                                                                  rta machine (fst kb) (snd md))





-- given a command and some customizations, launches a terminal
runInXTerm :: BgColor -> FontSpec -> String -> X ()
runInXTerm color font e = spawnHere $ (getColoredTerm color font) ++ " -e \"" ++ e ++ "\""

-- wrapper that spawns an editor in a given directory
spawnEditorIn :: String -> String -> X ()
spawnEditorIn e s = spawnHere $ wrapAndJoin [notifyCmd (e ++ "Editor") ("in " ++ s),
                                                   "cd " ++ s, "gvim"]

-- Customizations to various window types and classes
zManageHook = composeAll [ className =? "Vncviewer" --> doFloat
                         , className =? "Firefox" --> doF (W.shift $ ws!!4)
                         , className =? "Google-chrome" --> doF (W.shift $ ws!!4)
                         , (resource =? "RootWindow" <&&> className =? "Totalview") --> (doF(W.shift $ ws!!8) <+> doFloat)
                         , (resource =? "dataTableWindow" <&&> className =? "Totalview") --> doFloat
                         , className =? "com-ibm-sdwb-cmvc-client-dc-CMVC" --> doF (W.shift $ ws!!5)
                         , resource =? "gecko"  --> doFloat
                         , resource =? "gcalctool"  --> doFloat
                         , resource =? "empathy" --> doFloat
                         , resource =? "pidgin" --> doFloat
                         , className =? "Sametime" --> doFloat
                         , className =? "Lotus Notes" --> doF W.focusDown --- This prevents focus stealing
                         ]


