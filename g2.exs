#!/usr/bin/elixir

def generate_uri(search, options, extended, start) do
  uri = "https://www.google#{options[:location]}/search?q=#{search}&safe=off&tbm=isch"

  cond do
    options[:size] and options[:time] ->
      uri = uri <> "&tbs=#{options[:size]},#{options[:time]}"
    options[:size] ->
      uri = uri <> "&tbs=#{options[:size]}"
    options[:time] ->
      uri = uri <> "&tbs=#{options[:time]}"
  end

  uri = uri <> "&ijn=#{extended}&start=#{start}"
  to_charlist(uri)
end

def execute_search(uri) do
  {_, {{_, _, _}, _, body}} = :httpc.request(uri)
  body = to_string body
  body = String.replace(body, "<", "\n<")
  content = String.split(body, "\n")
  content = Enum.filter(content, fn(item) -> String.contains? item, "imgurl" end)
end

{opts, search, _} = OptionParser.parse(System.argv(), aliases: [a: :amount, e: :extended, l: :location, s: :size, t: :time], switches: [amount: :integer, extended: :boolean, location: :string, size: :string, time: :string])
sarg = Enum.join(search, " ")
IO.puts "#{sarg}"
srch = Enum.join(search, "+")
fnam = Enum.join(search, "-")
fnam = fnam <> ".html"

File.write(fnam, "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>", [:write])
File.write(fnam, "\n<br>\n", [:append])

:inets.start
:ssl.start

if opts[:extended] do
  for i <- Enum.take_every(0..100, 20),
    j <- 0..9 do
      uri = generate_uri(srch, opts, j, i)
      IO.puts "#{uri}"
      # content = execute_search(uri)
      # for line <- content do
        # line = Regex.replace(~r/.*imgurl=/, line, "<img src=\"")
        # line = Regex.replace(~r/&amp.*/, line, "\">")
        # File.write(fnam, line, [:append])
        # File.write(fnam, "\n", [:append])
      # end
  end
else
  for i <- Enum.take_every(0..100, 20) do
    uri = generate_uri(srch, opts, 0, i)
    IO.puts "#{uri}"
    # content = execute_search(uri)
    # for line <- content do
      # line = Regex.replace(~r/.*imgurl=/, line, "<img src=\"")
      # line = Regex.replace(~r/&amp.*/, line, "\">")
      # File.write(fnam, line, [:append])
      # File.write(fnam, "\n", [:append])
    # end
  end
end
:ssl.stop
:inets.stop
