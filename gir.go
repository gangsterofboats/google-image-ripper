package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"regexp"
	"strings"
)

func main() {
	fmt.Printf("%s\n", strings.Join(os.Args[1:], " "))
	fnam := strings.Join(os.Args[1:], "-")
	srch := strings.Join(os.Args[1:], "+")
	fnam = fnam + ".html"

	fh, _ := os.Create(fnam)
	fh.WriteString("<h1>NOTICE: RMCCURDY.COM IS NOT RESPONSIBLE FOR ANY CONTENT ON THIS PAGE. THIS PAGE IS A RESULT OF IMAGES.GOOGLE.COM INDEXING AND NO CONTENT IS HOSTED ON THIS SITE. PLEASE SEND ANY COPYRIGHT NOTICE INFORMATION TO <a href=\"https://support.google.com/legal/contact/lr_dmca?dmca=images&product=imagesearch\">GOOGLE</a> OR THE OFFENDING WEBSITE</h1>")
	fh.WriteString("\n<br>\n")
	for i := 0; i <= 400; i = i + 20 {
		url := fmt.Sprintf("https://www.google.com/search?q=%s&safe=off&tbm=isch&ijn=0&start=%d", srch, i)
		resp, _ := http.Get(url)
		cnt, _ := ioutil.ReadAll(resp.Body)
		content := fmt.Sprintf("%s", cnt)
		reg, _ := regexp.Compile("<")
		content = reg.ReplaceAllString(content, "\n<")
		contlines := strings.Split(content, "\n")
		rgx, _ := regexp.Compile(".*imgurl=")
		rxp, _ := regexp.Compile("&amp.*")
		for _, sbs := range contlines {
			if strings.Contains(sbs, "imgurl") {
				sbs = rgx.ReplaceAllString(sbs, "<img src=\"")
				sbs = rxp.ReplaceAllString(sbs, "\">")
				fh.WriteString(sbs)
				fh.WriteString("\n")
			}
		}
		defer resp.Body.Close()
	}
	defer fh.Close()
}
