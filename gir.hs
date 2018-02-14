import Control.Monad
import Data.Either.Unwrap
import Data.List
import Network.Download
import System.Environment
import System.IO
import Text.Regex

main = do
  args <- getArgs
  putStrLn (intercalate " " args)
  let fnam = intercalate "-" args
  let srch = intercalate "+" args
  fnam <- return $ fnam ++ ".html"

  fh <- openFile fnam WriteMode
  hPutStrLn fh "<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>"
  hPutStrLn fh "<br>"
  forM_ [0,20..400] $ \i -> do
    let url = "http://www.google.com/search?q=" ++ srch ++ "&safe=off&tbm=isch&ijn=0&start=" ++ show i
    resp <- openURIString url
    let content = fromRight resp
    content <- return $ subRegex (mkRegex "<") content "\n<"
    let contlines = splitRegex (mkRegex "\n") content
    contlines <- return $ filter (isInfixOf "imgurl") contlines
    forM_ contlines $ \s -> do
      s <- return $ subRegex (mkRegex ".*imgurl=") s "<img src=\""
      s <- return $ subRegex (mkRegex "&amp.*") s "\">"
      hPutStrLn fh s
  hClose fh
