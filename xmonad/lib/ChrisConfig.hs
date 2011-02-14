module ChrisConfig where

import Data.List(unfoldr, intersperse)
import Data.Char

type FontSize = Integer
type FontSpec = String
data BgColor = Red | Orange | Green | Blue | White 
             | Black | Brown | Cyan 
             | Custom Integer Integer Integer

data Machine = Sparky     -- AIX 5.3, DCE auth
             | Terran     -- AIX 5.3, GSA auth
             | CfeSles    -- 
             | CfeSles2   --
             | CfeRhel    --
             | CfeLinux10 -- 
             | Nobelium   --
             | Pape | Bloor | Brimley -- << Fortran FE
               deriving Show

data Fonts = Inconsolata | DejaVue | Liberation
data FgOrBg = Foreground | Background


-- total function implementing a saturating 0..255 range of colour strings in hex format
intToHex :: Integral a => a -> String
intToHex n
     | n <= 0    = "00"
     | n >= 255  = "ff"
     | n < 16    = '0' : int_to_dig n
     | otherwise = int_to_dig n
    where itoh   = reverse . unfoldr (\x -> if x == 0 then Nothing 
                                                      else let (a, b) = x `quotRem` 16 
                                                            in Just (b, a))
          int_to_dig n = map intToDigit $ itoh $ fromIntegral n

makeSpec :: Fonts -> FontSize -> FontSpec 
makeSpec Inconsolata s = "Inconsolata:size=" ++ (show s)
makeSpec DejaVue     s = "DejaVue Sans Mono:size=" ++ (show s)
makeSpec Liberation  s = "Liberation Mono:size=" ++ (show s)

showColor :: FgOrBg -> Integer -> Integer -> Integer -> String
showColor a r g b = case a of
                      Foreground -> "-fg '#" ++ digits ++ "'"
                      Background -> "-bg '#" ++ digits ++ "'"
                    where digits = (intToHex r) ++ (intToHex g) ++ (intToHex b)

colorstr :: Integer -> Integer -> Integer -> String
colorstr r' g' b' = (showColor Background r' g' b')  ++ " " ++ 
                    (showColor Foreground (r'+218) (g'+218) (b'+218))

colorToStrings :: BgColor -> String 
colorToStrings White  = (showColor Background 255 255 255) ++ " " ++ (showColor Foreground 0 0 60)
colorToStrings Red    = colorstr 30   0   0
colorToStrings Cyan   = colorstr  0  30  40
colorToStrings Green  = colorstr  0  25   0
colorToStrings Blue   = colorstr  0   0  40
colorToStrings Orange = colorstr 50  25   0
colorToStrings Brown  = colorstr 25  18   0
colorToStrings (Custom r g b) = colorstr r g b
colorToStrings _      = colorstr 0 0 0


bgColorTriplet :: (Integer, Integer, Integer) -> BgColor
bgColorTriplet (a, b, c) = Custom a b c


getColoredTerm :: BgColor -> FontSpec -> String
getColoredTerm c s = "xterm -fa '" ++ s ++ "' " ++ (colorToStrings c)

getTerminal :: FontSpec -> String
getTerminal = getColoredTerm Black


csOne :: Int -> BgColor
csOne = (!!) [ Custom 47 21 00
             , Custom 47 31 30
             , Custom 47 00 00
             , Custom 61 22 22 ]

csTwo :: Int -> BgColor
csTwo = (!!) [ Custom 08 26 28
             , Custom 09 15 31
             , Custom 09 36 13
             , Custom 46 28 12 ]

csThree :: Int -> BgColor
csThree i = bgColorTriplet ((zip3 (repeat 80) [20,25..] [10,15..]) !! i)


wrapAndJoin :: [String] -> String
wrapAndJoin a = '(' : (concat (intersperse "; " a)) ++ ")&"

csForMachine :: Machine -> Int -> BgColor
csForMachine Brimley = csOne
csForMachine   Bloor = csTwo
csForMachine    Pape = csThree
csForMachine       _ = error "can't find scheme for machine"

screenCommand :: Machine -> String
screenCommand    Pape = "/home/clord/Linux/bin/screen"
screenCommand Brimley = "/home/clord/Linux/bin/screen"
screenCommand   Bloor = "/home/clord/AIX/bin/screen"
screenCommand       _ = error "can't find screen command for machine"

screenOn :: Machine -> Int -> String
screenOn m s = "TERM=xterm /usr/bin/ssh -XC clord@" ++ (show m) ++ 
               " -t " ++ (screenCommand m) ++ " -A -xR " ++ mAndS ++ 
               " -c '/home/clord/etc/screen/" ++ mAndS ++ ".screenrc'"
         where mAndS = (map toLower $ show m) ++ (show s)

notifyCmd :: String -> String -> String
notifyCmd a o = "DISPLAY=durden:0 notify-send -u low '" ++ a ++ "' '" ++ o ++ "'"


