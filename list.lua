

display.setStatusBar( display.HiddenStatusBar )


local widget = require( "widget" )
local json = require( "json" )
local composer = require( "composer" )


local defaultField , inputtext, tweetgroup , str, scrollListener, networkListenerget, scrollView
--テキストフィールド、入力したテキスト、ツイートを入れるグループ、取得したツイート、スクロールの関数、get関数、スクロール画面

local bigbox = display.newGroup()
local scene = composer.newScene()
 

function scrollListener( event ) --画面を触っている時の処理
    local phase = event.phase
 
    if ( event.limitReached ) then
        if ( event.direction == "down" ) then 
            print( "Reached top limit" ) --限界まで引っ張った時
            
            network.request( "http://afreep.com/realTime/tweet.php?first=1", "GET", networkListenerget ) --表示の更新
        end
    end
    return true
end


local function onTap( event ) --タップイベントの登録と表示
    local t = event.target
    local data = t.params
    local options = {
    effect = "fade",
    time = 0,
    params = data
    }
    composer.removeHidden()
    composer.gotoScene( "displaycommet", options )
end


local function networkListenerpost( event ) --データを送信する時の処理
    if ( event.isError ) then --ネットにエラーが出た時
        print( "Network error: ", event.response )
    else --ポストがちゃんと出来た時
        print( "posted", event.response )
    end
end


local json_get, _data
function networkListenerget( event ) --データを表示する時の処理
        if ( tweetgroup ~= nil ) then
        display.remove( tweetgroup )
        tweetgroup = nil
        end

    tweetgroup = display.newGroup()
    if ( event.isError ) then
        print( "Network error: ", event.response )
    else
        json_get = event.response --文字を取得
        _data = json.decode( json_get ) --jsonを変換

        for k,v in pairs( _data ) do --データ全体に対して
            str = _data[k].tweet or 'Hello Corona!!!'

            print( "display:", str )

            local group = display.newGroup()
            group.x = 0
            group.y = k * 61
            local back = display.newRect( group, 150, -30, 350, 60 )
            back:setFillColor( 0, 0, 0.3 )
            back.params = _data[k]            
            back:addEventListener( "tap", onTap )

            local text = display.newText( group, ": "..str, 0, 0, nil, 20 )
            text.anchorX = 0
            text.x = 25
            text.y = -30
            tweetgroup:insert( group )
            scrollView:insert( tweetgroup )
        end
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

        network.request( "http://afreep.com/realTime/post.php", "POST", networkListenerpost, params ) --post関数の実行
        network.request( "http://afreep.com/realTime/tweet.php?first=1", "GET", networkListenerget ) --表示の更新
    end
end


function scene:create( event ) --表示するものなど
 
    local sceneGroup = self.view
    --スクロール画面を作成
    scrollView = widget.newScrollView(
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
    bigbox:insert( scrollView )

end
 

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then --イベント登録など
        network.request( "http://afreep.com/realTime/tweet.php?first=1", "GET", networkListenerget ) --get関数の実行

        defaultField = native.newTextField( 160, 470, 270, 25 ) --テキストフィールド作成
        bigbox:insert( defaultField )
        defaultField:addEventListener( "userInput", textListener ) --ユーザーイベントを登録
    end

end
 
 
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then --ページの表示しているものの削除
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


