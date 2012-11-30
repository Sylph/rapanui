-- Author: Marko Pukari
-- Date: 11/25/12

package.path = package.path .. ";../?.lua;lunatest/?.lua;mockobjects/?.lua;../rapanui-sdk/?.lua"
require('lunatest')
require('lunahamcrest')
require('RNScreen')
require('RNLayer')

require('MockPartition')
require('MockViewport')
require('MockLayer')
require('MockRNObject')
require('MockMOAILayer2D')
require('MockMOAISim')
require('MockMOAIViewport')
require('MockMOAIPartition')

local MVC = MockViewportConstants

--Mocked Objects 
PROP = {}
VIEWPORT = createViewport("viewport")
TEST_PARTITION=createPartition("TEST_PARTITION")
TEST_LAYER=createTestLayer("TEST_LAYER",VIEWPORT,TEST_PARTITION)
TEST_LAYER2=createTestLayer("TEST_LAYER2",VIEWPORT,TEST_PARTITION)
RNOBJECT = createRNObject("RNOBJECT",PROP)

--Mocked MOIA classes
MOAILayer2D = createMockMOAILayer2D(TEST_LAYER,TEST_LAYER2)
MOAISim = createMockMOAISim()
MOAIViewport = createMockMOAIViewport(VIEWPORT)
MOAIPartition = createMockMOAIPartition(TEST_PARTITION)

--Initialization

RNLayer:new()

local function init()
	MOAILayer2D:reset()
	MOAISim:reset()
	MOAIViewport:reset()
	MOAIPartition:reset()
	return RNScreen:new()
end

--TESTS

--RNScreen:initWith
function testThatScreenSizeIsSetCorrectly()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_that(rnscreen.width,is(equal_to(MVC.WIDTH)))	
	assert_that(rnscreen.height,is(equal_to(MVC.HEIGHT)))	
end

function testThatViewportIsCreated()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_that(MOAIViewport.newCalled,is(greater_than(0)))
end

function testThatViewportSizeIsSet()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_that(VIEWPORT.setSizeCalled,is(greater_than(0)))
end

function testThatViewportScaleIsSet()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_that(VIEWPORT.setScaleCalled,is(greater_than(0)))
end

function testThatViewportOffsetIsSet()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_that(VIEWPORT.setOffsetCalled,is(greater_than(0)))
end

function testThatLayerIsCreated() 
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_that(MOAILayer2D.newCalled,is(greater_than(0)))	
end

function testThatViewportIsSetToLayer() 
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_that(TEST_LAYER.setViewportCalled,is(greater_than(0)))	
end

function testThatNewPartitionIsCreated()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_that(MOAIPartition.newCalled,is(greater_than(0)))
end

function testThatNewPartitionIsSetToScreenMainPartitiob()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_that(rnscreen.mainPartition.name,is(equal_to(TEST_PARTITION.name)))
end

function testThatPartitionIsSetToLayer()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_that(TEST_LAYER.setPartitionCalled,is(greater_than(0)))
end

function testThatLayerIsPushedToMoaiSim()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_that(MOAISim.pushRenderPassCalled,is(greater_than(0)))
end

function testThatLayersAreStoredToScreen()
	local rnscreen = init()
	assert_nil(rnscreen.layers)	
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_not_nil(rnscreen.layers)	
end

function testThatMainPartitionIsFoundFromLayers()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_not_nil(rnscreen.layers:get(RNLayer.MAIN_LAYER))		
end

--RNScreen:addRNObject
function testThatObjectLocationModeIsSet()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	rnscreen:addRNObject(RNOBJECT)
	assert_that(RNOBJECT.setLocatingModeCalled,is(greater_than(0)))
end

function testThatTheObjectIsAddedToMainPartition()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	rnscreen:addRNObject(RNOBJECT)
	assert_that(TEST_PARTITION.insertPropCalled,is(greater_than(0)))
end

function testThatTheObjectParentSceneIsSet()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	rnscreen:addRNObject(RNOBJECT)
	assert_that(RNOBJECT.setParentSceneCalled,is(greater_than(0)))
end

function testThatObjectUpdateLocationIsCalled()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	rnscreen:addRNObject(RNOBJECT)
	assert_that(RNOBJECT.updateLocationCalled,is(greater_than(0)))
end

lunatest.run()