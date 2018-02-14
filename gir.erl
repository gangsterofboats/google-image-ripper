#!/usr/bin/escript
-export([main/1]).

main(Args) ->
    io:format("~s\n", [string:join(Args, " ")]),
    Fnam0 = string:join(Args, "-"),
    Srch = string:join(Args, "+"),
    Fnam = string:concat(Fnam0, ".html"),
    
    file:write_file(Fnam, "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>", [write]),
    file:write_file(Fnam, "\n<br>\n", [append]),

    inets:start(),
    ssl:start(),
    lists:foreach(fun(N) ->
                          execute_search(Srch, N, Fnam)
                  end, lists:seq(0, 100, 20)),
    inets:stop(),
    ssl:stop().


execute_search(Search, Number, File) ->
    Uri = io_lib:format("http://www.google.com/search?q=~s&safe=off&tbm=isch&ijn=0&start=~B", [Search, Number]),
    {_, {{_, _, _}, _, Body}} = httpc:request(Uri),
    Content = re:replace(Body, "<", "\n<", [global, {return, list}]),
    Contlines = re:split(Content, "\n"),
    Cntlns = lists:filter(fun(Item) ->
                                  string:find(Item, "imgurl") /= nomatch end, Contlines),
    lists:foreach(fun(Item) ->
                          Item2 = re:replace(Item, ".*imgurl=", "<img src=\"", [global, {return, list}]),
                          Item3 = re:replace(Item2, "&amp.*", "\">", [global, {return, list}]),
                          file:write_file(File, Item3, [append]),
                          file:write_file(File, "\n", [append])
                  end, Cntlns).
