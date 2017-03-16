

local json = require( "json" )


local self = object.new()

function self.getlist( event ) --データ一覧を表示する時の処理
	local function listener( event ) --データ一覧を表示する時の処理

		local json_get, data

	    -- tweetgroup = display.newGroup()
	    if ( event.isError ) then
	        print( "Network error: ", event.response )
	    else
	    	
	        json_get = event.response --文字を取得
	        data = json.decode( json_get ) --jsonを変換

	        self:dispatchEvent( { name = 'model-getlist', data = data } )
	    end
	end
	network.request( "http://afreep.com/realTime/tweet.php?first=1", "GET", listener ) --一覧の表示
end

return self


