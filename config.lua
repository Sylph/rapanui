--[[
--
-- RapaNui
--
-- by Ymobe ltd  (http://ymobe.co.uk)
--
-- LICENSE:
--
-- RapaNui uses the Common Public Attribution License Version 1.0 (CPAL) http://www.opensource.org/licenses/cpal_1.0.
-- CPAL is an Open Source Initiative approved
-- license based on the Mozilla Public License, with the added requirement that you attribute
--width Moai (http://getmoai.com/) and  RapaNui in the credits of your program.
]]

--module(..., package.seeall)

config = {}

-- Preset for some devices you can add as many as you want
-- WARNING
-- if the size of the moai window it's bigger than your real screen size (the computer on which you dev)
-- there are bugs on RNObject placement and on touch input x,y coords so try to stay in your computer resolution
--
config.sizes = {
    ["iPadDev"] = { 768, 1024, 768, 1024 },
    ["iPad"] = { 768, 1024, 768, 1024 }, -- 1:1 pixel iPad
    ["iPadRetina"] = { 2048, 1536, 2048, 1536 }, -- 1:1 pixel ipad retina
    ["iPhone3G"] = { 320, 480, 320, 480 },
    ["iPhone4Full"] = { 640, 960, 640, 960 },
    ["iPhone3G_500_750"] = { 500, 750, 500, 750 },
    ["AcerLiquidMetal"] = { 480, 800, 480, 800 },
    ["Archos70it"] = { 800, 480, 800, 480 },
    ["Desktop"] = { 768, 1024, 768, 1024 },
    ["Auto"] = { MOAIEnvironment.screenWidth or 800, MOAIEnvironment.screenHeight or 480,
                 MOAIEnvironment.screenWidth or 800, MOAIEnvironment.screenHeight or 480}
}

--set landscape mode and device
config.device = "Auto"
config.landscape = true
config.letterBoxClipping = true -- Default to false. It enables the black bars on the side when set to true.

--set stretch and graphics design
--this will stretch your graphics to fit device screen size
--but you need to set for which sizes your assets are originally designed for
--change values with care if you are on landscape
config.stretch = true
config.graphicsDesign = { w = 640, h = 960 }

--this is for iOS. Set it to true if you enabled the status bar in your Moai xCode Project, to keep screen touch configured properly.
config.iosStatusBar = false

return config