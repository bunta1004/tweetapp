

local model = require( "model_tweet" )
local widget = require( "widget" )
object = require( "object" )


local this = object.new()
local object = {}

local _W = display.contentWidth
local _H = display.contentHeight


local function listener( event ) --主に表示するものをここに分けて書いておく
    local self = {}

    local function scrollListener( event ) --画面を触っている時の処理
 
    if ( event.limitReached ) then
        if ( event.direction == "down" ) then 
            print( "Reached top limit" ) --限界まで引っ張った時
            this:dispatchEvent( { name = 'top_limit', data = data } )
        end
    end
    return true
    end


    local function tap( event ) --タップイベントが起きた時の処理
        local t = event.target
        local data = t.params

        this:dispatchEvent( { name = 'view_tap', data = data } ) --タップイベントの送信
        return true
    end


    local function handler( event ) --ツイート一覧の表示
        if ( object.tweetgroup ~= nil ) then
               display.remove( object.tweetgroup )
               object.tweetgroup = nil
        end

        object.tweetgroup = display.newGroup()

        local model_data = {}
        model_data = event.data

        for k,v in pairs( model_data ) do --データ全体に対して
            object.str = model_data[k].tweet or 'Hello Corona!!!'

            print( "", object.str )

            object.group = display.newGroup()
            object.group.x = 0
            object.group.y = k * 61

            object.back = display.newRect( object.group, 150, -30, 350, 60 )
            object.back:setFillColor( 0, 0, 0.3 )
            object.back.params = model_data[k]            
            object.back:addEventListener( "tap", tap )

            object.text = display.newText( object.group, ": "..object.str, 0, 0, nil, 20 )
            object.text.anchorX = 0
            object.text.x = 25
            object.text.y = -30

            object.tweetgroup:insert( object.group )
            object.scrollView:insert( object.tweetgroup )
        end
    end

    local function listenerpost( event ) --データを送信する時の処理
        if ( event.isError ) then --ネットにエラーが出た時
            print( "Network error: ", event.response )
        else --ポストがちゃんと出来た時
            print( "posted", event.response )
        end
    end

    local function textListener( event ) --テキスト入力の時の処理
        if ( event.phase == "submitted" ) then
            print( event.target.text )

            inputtext = event.target.text --入力テキストを代入

            local headers = {}
            headers["Content-Type"] = "application/x-www-form-urlencoded"
            headers["Accept-Language"] = "en-US"

            local body 
            body = "tweet="..inputtext

            local params = {}
            params.headers = headers
            params.body = body
            
            print( "body:", body )

            network.request( "http://afreep.com/realTime/post.php", "POST", listenerpost, params ) --post関数の実行
            this:dispatchEvent( { name = 'input_text' } )
        end
    end

    function self.create() --最初に表示したいもの
        if object.bigbox == nil then
            print( "create" )
            object.bigbox = display.newGroup()

            object.inputfield = native.newTextField( 0, 0, _W-50, 25 ) --テキストフィールド作成
            object.inputfield.x = _W * 0.5
            object.inputfield.y = _H - 10
            object.bigbox:insert( object.inputfield )
            object.inputfield:addEventListener( "userInput", textListener ) --ユーザーイベントを登録

            --スクロール画面を作成
            object.scrollView = widget.newScrollView(
                {
                    top = 0,
                    left = 10,
                    width = 300,
                    height = 900,
                    scrollWidth = 600,
                    scrollHeight = 900,
                    listener = scrollListener,
                }
            )
            object.bigbox:insert( object.scrollView )

            model:addEventListener( handler ) --getの一覧の表示
        end
        return object.bigbox
    end

    function self.destroy( event ) --削除するもの
        print( "コメントリストの削除" )
        display.remove( object.bigbox )
        object.bigbox = nil
        model:removeEventListener( handler )
    end

    

    return self --controllerでself.~を実行し表示する
end

function this.new() --object.new()をやってる
    return listener() --listener関数を呼び出し
end

return this


