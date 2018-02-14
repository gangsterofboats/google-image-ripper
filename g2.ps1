# amount extended location size time
Param
(
    [int]$amount = 100,
    [switch]$extended = $false,
    [string]$location = ".com",
    [string]$size,
    [string]$time
)


Write-Output "$args"
$search = $args -join "+"
$filename = $args -join "-"
$filename = "$filename.html"

'<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href="https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>' | Out-File -FilePath $filename
'<br>' | Out-File -FilePath $filename -Append

For ($i=0; $i -le 100; $i = $i + 20)
{
    $content = Invoke-WebRequest -Uri ("https://www.google.com/search?q=" + $search + "&safe=off&tbm=isch&ijn=0&start=" + $i)
    $content = $content -replace "<", "`n<"
    $contlines = $content -split "`n"
    Foreach ($line in $contlines)
    {
        if ($line -like '*imgurl*')
        {
            $line = $line -replace ".*imgurl=",'<img src="'
            $line = $line -replace "&amp.*",'">'
            $line | Out-File -FilePath $filename -Append
        }
    }
}
#ijn = something to do with google ajax
