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
-- Moai (http://getmoai.com/) and RapaNui in the credits of your program.
]]

RNFactory = {}

contentCenterX = nil
contentCenterY = nil
contentHeight = nil
contentWidth = nil
contentScaleX = nil
contentScaleY = nil
contentWidth = nil
screenOriginX = nil
screenOriginY = nil
statusBarHeight = nil
viewableContentHeight = nil
viewableContentWidth = nil
HiddenStatusBar = "HiddenStatusBar"
CenterReferencePoint = "CenterReferencePoint"

RNFactory.screen = RNScreen:new()

groups = {}
groups_size = 0

RNFactory.mainGroup = RNGroup:new()

RNFactory.stageWidth = 0
RNFactory.stageHeight = 0
RNFactory.width = 0
RNFactory.height = 0

function RNFactory.init()

    local lwidth, lheight, screenlwidth, screenHeight
    local screenX, screenY = MOAIEnvironment.screenWidth, MOAIEnvironment.screenHeight

    if screenX ~= nil then --if physical screen
        lwidth, lheight, screenlwidth, screenHeight = screenX, screenY, screenX, screenY
    else
        lwidth, lheight, screenlwidth, screenHeight = config.sizes[config.device][1], config.sizes[config.device][2], config.sizes[config.device][3], config.sizes[config.device][4]
    end

    if config.landscape == true then -- flip lwidths and Hieghts
        lwidth, lheight = lheight, lwidth
        screenlwidth, screenHeight = screenHeight, screenlwidth
    end

    landscape, device, sizes, screenX, screenY = nil


    if name == nil then
        name = "mainwindow"
    end

    --  lwidth, lheight from the SDConfig.lua

    MOAISim.openWindow(name, screenlwidth, screenHeight)
    RNFactory.screen:initWith(lwidth, lheight, screenlwidth, screenHeight)

    RNFactory.width = lwidth
    RNFactory.height = lheight

    contentlwidth = lwidth
    contentHeight = lheight

    --the resize in x axis is good. The resize in y axis is not, because it's from the bottom to top
    --so we have to set y offset but if we do so,touch events won't be good they will suffer from this offset
    --example of resize with 480x800 screen already set on config and resized in view from here.
    --RNFactory.screen.viewport:setSize(800*800/480,480*480/320)
    --RNFactory.screen.viewport:setOffset(-1, 0.3) --

    RNInputManager.setGlobalRNScreen(screen)
end

-- extra method call to setup the underlying system
RNFactory.init()

function RNFactory.showDebugLines()
    MOAIDebugLines.setStyle(MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1)
    MOAIDebugLines.setStyle(MOAIDebugLines.PROP_WORLD_BOUNDS, 2, 0.75, 0.75, 0.75)
end

function RNFactory.getCurrentScreen()
    return RNFactory.screen
end



function RNFactory.createList(name, params)
    local list = RNListView:new()
    list.name = name
    list.options = params.options
    list.elements = params.elements
    list.x = params.x
    list.y = params.y
    if params.canScrollY ~= nil then list.canScrollY = params.canScrollY else list.canScrollY = true end
    list:init()
    return list
end

function RNFactory.createPageSwipe(name, params)
    local pSwipe = RNPageSwipe:new()
    pSwipe.options = params.options
    pSwipe.elements = params.elements
    pSwipe:init()
    return pSwipe
end

function RNFactory.createImage(image, params)

    local parentGroup, left, top

    top = 0
    left = 0

    if (params ~= nil) then
        if (params.top ~= nil) then
            top = params.top
        end

        if (params.left ~= nil) then
            left = params.left
        end

        if (params.parentGroup ~= nil) then
            parentGroup = params.parentGroup
        else
            parentGroup = RNFactory.mainGroup
        end
    end

    if (parentGroup == nil) then
        parentGroup = RNFactory.mainGroup
    end


    local o = RNObject:new()
    local o, deck = o:initWithImage2(image)

    o.x = o.originalWidth / 2 + left
    o.y = o.originalHeight / 2 + top
    local parentGroup = RNFactory.mainGroup

    RNFactory.screen:addRNObject(o)

    if parentGroup ~= nil then
        parentGroup:insert(o)
    end


    return o, deck
end

function RNFactory.createImageFromMoaiImage(moaiImage, params)

    local parentGroup, left, top

    top = 0
    left = 0

    if (params ~= nil) then
        if (params.top ~= nil) then
            top = params.top
        end

        if (params.left ~= nil) then
            left = params.left
        end

        if (params.parentGroup ~= nil) then
            parentGroup = params.parentGroup
        else
            parentGroup = RNFactory.mainGroup
        end
    end

    if (parentGroup == nil) then
        parentGroup = RNFactory.mainGroup
    end


    local image = RNObject:new()
    image:initWithMoaiImage(moaiImage)
    RNFactory.screen:addRNObject(image)
    image.x = image.originalWidth / 2 + left
    image.y = image.originalHeight / 2 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end

    return image
end

function RNFactory.createImageFromMoaiProp2D(image, params)
    local left = 0
    local top = 0
    local parentGroup = RNFactory.mainGroup
    if params then
        parentGroup = params.parentGroup or parentGroup
        left = params.left or left
        top = params.top or top
    end

    local o = RNObject:new()
    local o = o:initWithMoaiProp2D(image)

    o.x = left
    o.y = top
    print ("Size of Image is", image.width, image.height)

    RNFactory.screen:addRNObject(o)

    --o.prop:setScl(1,-1)
    if parentGroup ~= nil then
        parentGroup:insert(o)
    end

    return o
end

function RNFactory.createImage2(image, sizex, sizey)
    local o = RNObject:new()
    local o, deck = o:initWithImage2(image, sizex, sizey)


    local parentGroup = RNFactory.mainGroup

    RNFactory.screen:addRNObject(o)

    if parentGroup ~= nil then
        parentGroup:insert(o)
    end


    return o, deck
end

function RNFactory.createAnim2(image, sizex, sizey, tilex, tiley, posx, posy, scalex, scaley)
    local o = RNObject:new()
    local o, deck = o:initWithAnim2(image, sizex, sizey, tilex, tiley, scalex, scaley)

    o.x = posx
    o.y = posy

    local parentGroup = RNFactory.mainGroup

    RNFactory.screen:addRNObject(o)

    if parentGroup ~= nil then
        parentGroup:insert(o)
    end


    return o, deck
end

function RNFactory.createMoaiImage(filename)
    local image = MOAIImage.new()
    image:load(filename, MOAIImage.TRUECOLOR + MOAIImage.PREMULTIPLY_ALPHA)
    return image
end

function RNFactory.createBlankMoaiImage(width, height)
    local image = MOAIImage.new()
    image:init(width, height)
    return image
end

function RNFactory.createCopyRect(moaiimage, params)

    local parentGroup, left, top

    top = 0
    left = 0

    if (params ~= nil) then
        if (params.top ~= nil) then
            top = params.top
        end

        if (params.left ~= nil) then
            left = params.left
        end

        if (params.parentGroup ~= nil) then
            parentGroup = params.parentGroup
        else
            parentGroup = RNFactory.mainGroup
        end
    end

    if (parentGroup == nil) then
        parentGroup = RNFactory.mainGroup
    end


    local image = RNObject:new()
    image:initCopyRect(moaiimage, params)
    RNFactory.screen:addRNObject(image)
    image.x = image.originalWidth / 2 + left
    image.y = image.originalHeight / 2 + top

    if parentGroup ~= nil then
        parentGroup:insert(image)
    end


    return image
end

function RNFactory.createAnim(image, sizex, sizey, left, top, scaleX, scaleY)

    if scaleX == nil then
        scaleX = 1
    end

    if scaleY == nil then
        scaleY = 1
    end

    if left == nil then
        left = 0
    end

    if top == nil then
        top = 0
    end

    local parentGroup = RNFactory.mainGroup


    local o = RNObject:new()
    local o, deck = o:initWithAnim2(image, sizex, sizey, scaleX, scaleY)

    o.x = left
    o.y = top
    o.scalex=scaleX
    o.scaley=scaleY

    local parentGroup = RNFactory.mainGroup

    RNFactory.screen:addRNObject(o)

    if parentGroup ~= nil then
        parentGroup:insert(o)
    end


    return o, deck
end

function RNFactory.createText(text, params)

    local top, left, size, font, height, width, alignment

    font = "arial-rounded"
    size = 15
    alignment = MOAITextBox.CENTER_JUSTIFY
    --LEFT_JUSTIFY, CENTER_JUSTIFY or RIGHT_JUSTIFY.

    if (params ~= nil) then
        if (params.top ~= nil) then
            top = params.top
        end

        if (params.left ~= nil) then
            left = params.left
        end

        if (params.font ~= nil) then
            font = params.font
        end

        if (params.size ~= nil) then
            size = params.size
        end

        if (params.height ~= nil) then
            height = params.height
        end

        if (params.width ~= nil) then
            width = params.width
        end

        if (params.alignment ~= nil) then
            alignment = params.alignment
        end
    end

    local RNText = RNText:new()
    local gFont
    RNText, gFont = RNText:initWithText2(text, font, size, left, top, width, height, alignment)
    RNFactory.screen:addRNObject(RNText)
    RNFactory.mainGroup:insert(RNText)
    return RNText, gFont
end


function RNFactory.createTextOld(text, params)

    local top, left, size, font, height, width, alignment

    font = "arial-rounded"
    size = 15
    alignment = MOAITextBox.CENTER_JUSTIFY
    --LEFT_JUSTIFY, CENTER_JUSTIFY or RIGHT_JUSTIFY.

    if (params ~= nil) then
        if (params.top ~= nil) then
            top = params.top
        end

        if (params.left ~= nil) then
            left = params.left
        end

        if (params.font ~= nil) then
            font = params.font
        end

        if (params.size ~= nil) then
            size = params.size
        end

        if (params.height ~= nil) then
            height = params.height
        end

        if (params.width ~= nil) then
            width = params.width
        end

        if (params.alignment ~= nil) then
            alignment = params.alignment
        end
    end

    local RNText = RNText:new()
    RNText:initWithText(text, font, size, left, top, width, height, alignment)
    RNFactory.screen:addRNObject(RNText)
    RNFactory.mainGroup:insert(RNText)
    return RNText
end

function RNFactory.createRect(x, y, width, height, params)
    local parentGroup, top, left
    local rgb = { 255, 255, 255 }

    if params then
        parentGroup = params.parentGroup or RNFactory.mainGroups
        rgb = params.rgb or rgb
    end

    local shape = RNObject:new()
    shape:initWithRect(width, height, rgb)
    RNFactory.screen:addRNObject(shape)
    shape.x = shape.originalWidth * .5 + x
    shape.y = shape.originalHeight * .5 + y
    shape.rotation = 0

    if parentGroup ~= nil then
        parentGroup:insert(shape)
    end
    return shape
end

function RNFactory.createCircle(x, y, r, params)
    local parentGroup, top, left
    local rgb = { 255, 255, 255 }

    if params then
        if type(params) == "table" then
            parentGroup = params.parentGroup or RNFactory.mainGroups
            top = params.top or 0
            left = params.left or 0
            rgb = params.rgb or rgb
        end
    end

    local shape = RNObject:new()
    shape:initWithCircle(x, y, r, rgb)
    RNFactory.screen:addRNObject(shape)
    shape.x = x
    shape.y = y
    shape.rotation = 0

    if parentGroup ~= nil then
        parentGroup:insert(shape)
    end
    return shape
end

return RNFactory