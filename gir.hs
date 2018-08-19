{-
Google Image Ripper - compile links from Google image searches into an HTML file
Copyright (C) 2018 Michael Wiseman

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <https://www.gnu.org/licenses/>.
-}

import Control.Lens
import Control.Monad
import Data.List
import Data.Typeable
import Network.Wreq
import System.Environment
import System.IO
import Text.Regex

import qualified Data.ByteString.Lazy.Char8 as C
import qualified System.IO.Strict as S

main = do
  args <- getArgs
  putStrLn (intercalate " " args)
  let fnam = intercalate "-" args
  let srch = intercalate "+" args
  fnam <- return $ fnam ++ ".html"

  writeFile fnam "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>"
  appendFile fnam "\n<br>\n"
  forM_ [0,20..100] $ \i -> do
    let uri = "https://www.google.com/search?q=" ++ srch ++ "&safe=off&tbm=isch&ijn=0&start=" ++ show i
    resp <- get uri
    let content = resp ^. responseBody
    content <- return $ subRegex (mkRegex "<") (C.unpack content) "\n<"
    let contlines = splitRegex (mkRegex "\n") content
    contlines <- return $ filter (isInfixOf "imgurl") contlines
    forM_ contlines $ \s -> do
      s <- return $ subRegex (mkRegex ".*imgurl=") s "<img src=\""
      s <- return $ subRegex (mkRegex "&amp.*") s "\">"
      appendFile fnam s
      appendFile fnam "\n"

  fs <- S.readFile fnam
  let fo = splitRegex (mkRegex "\n") fs
  fo <- return $ nub fo
  let fs = intercalate "\n" fo
  writeFile fnam fs
