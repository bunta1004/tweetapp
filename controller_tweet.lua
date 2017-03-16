
display.setStatusBar( display.HiddenStatusBar )

object = require( "object" )

local model  = require( "model_tweet" )
local view = require( "view_tweet" )
local composer = require( "composer" )

local seen = {}
local scene = composer.newScene()

seen.page_view = view.new()
local view_delete
local view_obj

local function viewHandler( event ) --色々なイベントを拾って来て処理する
	if event.name == "view_tap" then --タップされた時のイベント
		local options = { effect = "fade", time = 0, params = tap_data }
	    composer.removeHidden()
	    composer.gotoScene( "controller_message", options )
	end

	if event.name == "input_text" then
		view_delete = seen.page_view.destroy() --ページの削除
		view_obj = seen.page_view.create() --ページの更新
		model.getlist()
	end

	if event.name == "top_limit" then
		view_delete = seen.page_view.destroy() --ページの削除
		view_obj = seen.page_view.create() --ページの更新
		model.getlist()
	end

	if event.name == "get_list" then

	end
end


function scene:create( event ) --表示するものなど
	view_obj = seen.page_view.create()
	model.getlist()
end
 

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then --イベント登録など
    	view:addEventListener( viewHandler ) --viewから送られて来たdispachに対して
		model:addEventListener( viewHandler ) --modelから送られて来たdispachに対して
    end

end

 
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then --ページの表示しているものの削除
	    local view_delete = seen.page_view.destroy()
	    view:removeEventListener( viewHandler )
	    model:removeEventListener( viewHandler )
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


