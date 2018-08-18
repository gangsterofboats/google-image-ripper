#!/usr/bin/env elixir
####################################################################################
# Google Image Ripper - compile links from Google image searches into an HTML file #
# Copyright (C) 2018 Michael Wiseman                                               #
#                                                                                  #
# This program is free software: you can redistribute it and/or modify it under    #
# the terms of the GNU General Public License as published by the Free Software    #
# Foundation, either version 3 of the License, or (at your option) any later       #
# version.                                                                         #
#                                                                                  #
# This program is distributed in the hope that it will be useful, but WITHOUT ANY  #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A  #
# PARTICULAR PURPOSE.  See the GNU General Public License for more details.        #
#                                                                                  #
# You should have received a copy of the GNU General Public License along with     #
# this program.  If not, see <https://www.gnu.org/licenses/>.                      #
####################################################################################

# Two function module
defmodule Gir do
  def execute_search(uri) do
    {_, response} = Tesla.get(uri)
    body = response.body
    body = String.replace(body, "<", "\n<")
    content = String.split(body, "\n")
    Enum.filter(content, fn(item) -> String.contains? item, "imgurl" end)
  end

  def generate_uri(search, options, extended, start) do
    # Ensure location has a value
    location = cond do
      options[:location] -> options[:location]
      true -> ".com"
    end
    uri = "https://www.google#{location}/search?q=#{search}&safe=off&tbm=isch"

    uri = cond do
      options[:size] && options[:time] -> uri <> "&tbs=#{options[:size]},#{options[:time]}"
      options[:size] -> uri <> "&tbs=#{options[:size]}"
      options[:time] -> uri <> "&tbs=#{options[:time]}"
      true -> uri
    end

    uri <> "&ijn=#{extended}&start=#{start}"
  end
end

{options, args, _} = OptionParser.parse(System.argv(), switches: [amount: :integer, extended: :boolean, location: :string, size: :string, time: :string, uniquify: :boolean], aliases: [a: :amount, e: :extended, l: :location, s: :size, t: :time, u: :uniquify])

# Ensure amount has a value
amount = cond do
  options[:amount] -> options[:amount]
  true -> 100
end

IO.puts Enum.join(args, " ")
search = Enum.join(args, "+")
filename = Enum.join(args, "-")
filename = filename <> ".html"

File.write(filename, "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>", [:write])
File.write(filename, "\n<br>\n", [:append])

if options[:extended] do
  for i <- Enum.take_every(0..amount, 20) do
    for j <- 0..9 do
      uri = Gir.generate_uri(search, options, j, i)
      content = Gir.execute_search(uri)
      for line <- content do
        line = Regex.replace(~r/.*imgurl=/, line, "<img src=\"")
        line = Regex.replace(~r/&amp.*/, line, "\">")
        File.write(filename, line, [:append])
        File.write(filename, "\n", [:append])
      end
    end
  end
else
  for i <- Enum.take_every(0..amount, 20) do
    uri = Gir.generate_uri(search, options, 0, i)
    content = Gir.execute_search(uri)
    for line <- content do
      line = Regex.replace(~r/.*imgurl=/, line, "<img src=\"")
      line = Regex.replace(~r/&amp.*/, line, "\">")
      File.write(filename, line, [:append])
      File.write(filename, "\n", [:append])
    end
  end
end

if options[:uniquify] do
  fs = File.read! fnam
  fo = String.split(fs, "\n")
  fo = Enum.uniq(fo)
  fs = Enum.join(fo, "\n")
  File.write(fnam, fs)
end
