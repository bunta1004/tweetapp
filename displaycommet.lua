
local composer = require( "composer" )
 
local scene = composer.newScene()

local bigbox = display.newGroup()


local options = {
    effect = "fade",
    time = 0,
    -- params = { level="Level 1", score=currentScore }
}

local function onTap( event ) --タップイベントの登録の表示
    composer.removeHidden()
    composer.gotoScene( "list", options )
end
 
local rect,background,button
function scene:create( event ) --表示の作成
 
    local sceneGroup = self.view

    local background = display.newRect( bigbox, 0, 200, 600, 900 )
    background:setFillColor( 1, 1, 1 )

    button = display.newRect( bigbox, 150, 400, 100, 50 )
    button:setFillColor( 0, 0, 0.8 )

    button_text = display.newText( bigbox, "back", 150, 400, nil, 20 )

    local group = display.newGroup()
    group.x = 0
    group.y = 61
    local back = display.newRect( group, 150, -30, 350, 150 )
    back:setFillColor( 0, 0, 0.3 )

    local tweet = event.params.tweet
    local text = display.newText( group, ": "..tweet, 0, 0, nil, 20 )
    text.anchorX = 0
    text.x = 30
    text.y = -30

    local date = event.params.date
    local text = display.newText( group, " "..date, 0, 0, nil, 10 )
    text.anchorX = 0
    text.x = 100
    text.y = 20
    bigbox:insert( group )
    
    print( "", params )
 
end
 
 
function scene:show( event ) --イベントの登録
 
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

    elseif ( phase == "did" ) then
        button:addEventListener( "tap", onTap )
    end
end
 
 
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then --表示しているものの削除
         display.remove( bigbox )
         bigbox = nil
 
    end
end
 
 
function scene:destroy( event )
 
    local sceneGroup = self.view
 
end
 
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene