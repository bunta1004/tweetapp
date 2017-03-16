


object = require( "object" )
local view = require( "view_tweet" )

local _W = display.contentWidth
local _H = display.contentHeight
local this = object.new()




local function listener( event ) --主に表示するものをここに分けて書いておく
    local self = {}
    local obj = {}

	local function tap( event ) --タップイベントが起きた時の処理
		this:dispatchEvent( { name = 'message_tap' } ) --タップイベントの送信
		return true	
	end

	local function handler( event )
		if event.name == "view_tap" then
			obj.back = display.newRect( obj.group, 150, -30, 350, 150 )
		    obj.back:setFillColor( 0, 0, 0.3 )

		    local tweet = event.data.tweet
		    obj.text = display.newText( obj.group, ": "..tweet, 0, 0, nil, 20 )
		    obj.text.anchorX = 0
		    obj.text.x = 30
		    obj.text.y = -30

		    local date = event.data.date
		    obj.datetext = display.newText( obj.group, " "..date, 0, 0, nil, 10 )
		    obj.datetext.anchorX = 0
		    obj.datetext.x = 100
		    obj.datetext.y = 20
		    obj.biggroup:insert( obj.group )
		end
	end

    function self.create() --最初に表示したいもの
    	if obj.biggroup == nil then
	        print( "単体コメントの表示" )
	        obj.biggroup = display.newGroup()
		    
		    obj.background = display.newRect( obj.biggroup, 0, 200, 600, 900 )
		    obj.background:setFillColor( 1, 1, 1 )

		    obj.button = display.newRect( obj.biggroup, 150, 400, 100, 50 )
		    obj.button:setFillColor( 0, 0, 0.8 )
		    obj.button:addEventListener( "tap", tap )

		    obj.button_text = display.newText( obj.biggroup, "back", 150, 400, nil, 20 )

		    obj.group = display.newGroup()
		    obj.group.x = 0
		    obj.group.y = 61

	        view:addEventListener( handler ) --メッセージの取得と表示	
	    end
	    return obj.biggroup
    end

    function self.destroy( event ) --削除するもの
        print( "単体コメントの削除" )

        display.remove( obj.biggroup )
        obj.biggroup = nil

        view:removeEventListener( handler )
    end


    return self --controllerでself.~を実行し表示する
end

function this.new() --object.new()をやってる
    return listener() --listener関数を呼び出し
end

return this