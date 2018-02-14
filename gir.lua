local http = require("socket.http")

print(table.concat(arg, " "))
fnam = table.concat(arg, "-")
srch = table.concat(arg, "+")
fnam = fnam .. ".html"

file = io.open(fnam, "w")
file:write("<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>")
file:write("\n<br>\n")
for i = 0,400,20 do
   uri = string.format("https://www.google.com/search?q=%s&safe=off&tbm=isch&ijn=0&start=%s", srch, i)
   content = http.request(uri)
   content = content:gsub("<", "\n<")
   contlines = {}
   for lns in content:gmatch("[^\n]+") do
      table.insert(contlines, lns)
   end
   for i = 1, #contlines, 1 do
      if string.find(contlines[i], "imgurl") == nil then
         contlines[i] = nil
      end
   end
   for key,value in pairs(contlines) do
      value = string.gsub(value, ".*imgurl=", "<img src=\"")
      value = string.gsub(value, "&amp.*", "\">")
      file:write(value, "\n")
   end
end

file:close()
