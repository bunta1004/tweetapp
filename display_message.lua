

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
--表示の作成
 
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

local date = event.params.date --送られて来たメッセージの取得
local datetext = display.newText( group, " "..date, 0, 0, nil, 10 )
datetext.anchorX = 0
datetext.x = 100
datetext.y = 20
bigbox:insert( group ) --全てが入ってるグループに登録

print( "", params )


button:addEventListener( "tap", onTap ) --ボタンイベントの登録


display.remove( bigbox ) --全ての削除
bigbox = nil
