library(XML)

url <- paste("http://www.premierleague.com/en-gb/players/ea-sports-player-performance-index.html?paramSearchTerm=&paramClubId=&paramSeason=2013-2014&paramPosition=&paramEaBreakdownType=ACCUMULATIVE&paramGameWeek=1&paramItemsPerPage=100&paramSelectedPageIndex=", 1:6, sep="")
tbl <- readHTMLTable(url[1])[[1]]


for (i in 2:6){
    tbl <- rbind(tbl, readHTMLTable(url[i])[[1]])
}

## debug了几遍，发现问题出在两个方面：1.有些player的名字是非英文，如"Yaya Touré"对应
## 的url后缀为“yaya-toure”，所以要得到url不能用名字组合的方式，而应该从表格页面抓取。
## 用readLines函数可以读取那几页表格，找到对应的包含url的行数(特征是都含有“/en-gb/players/profile.overview.html/”）,
## 再以""符号分隔，得到类似"en-gb/players/profile.overview.html/luis-suarez"的元素，
## 问题1就解决了。


web_1 <- readLines(url[1])
playerurl_1 <- vector()
web_1 <- web_1[grep("/en-gb/players/profile.overview.html/", web_1)]
web_1 <- strsplit(web_1, '"')
for (i in 1:100){
       playerurl_1[i] <- web_1[[i]][4]
}

web_2 <- readLines(url[2])
playerurl_2 <- vector()
web_2 <- web_2[grep("/en-gb/players/profile.overview.html/", web_2)]
web_2 <- strsplit(web_2, '"')
for (i in 1:100){
    playerurl_2[i] <- web_2[[i]][4]
}

web_3 <- readLines(url[3])
playerurl_3 <- vector()
web_3 <- web_3[grep("/en-gb/players/profile.overview.html/", web_3)]
web_3 <- strsplit(web_3, '"')
for (i in 1:100){
    playerurl_3[i] <- web_3[[i]][4]
}

web_4 <- readLines(url[4])
playerurl_4 <- vector()
web_4 <- web_4[grep("/en-gb/players/profile.overview.html/", web_4)]
web_4 <- strsplit(web_4, '"')
for (i in 1:100){
    playerurl_4[i] <- web_4[[i]][4]
}

web_5 <- readLines(url[5])
playerurl_5 <- vector()
web_5 <- web_5[grep("/en-gb/players/profile.overview.html/", web_5)]
web_5 <- strsplit(web_5, '"')
for (i in 1:100){
    playerurl_5[i] <- web_5[[i]][4]
}

web_6 <- readLines(url[6])
playerurl_6 <- vector()
web_6 <- web_6[grep("/en-gb/players/profile.overview.html/", web_6)]
web_6 <- strsplit(web_6, '"')
for (i in 1:length(web_6)){
    playerurl_6[i] <- web_6[[i]][4]
}

## 以上几个重复代码可以用循环简化


wholeplayer <- c(playerurl_1, playerurl_2, playerurl_3, playerurl_4,
                       playerurl_5, playerurl_6)

playerurl <- paste("http://www.premierleague.com", wholeplayer, sep="")

## 有了整个playerurl以后用xpathSApply解析Age的值，共有531个页面
Age <- vector()
for (i in 1:531){
    Age[i] <- xpathSApply(htmlTreeParse(playerurl[i], useInternal=TRUE), 
                          "//td[@class='normal']", xmlValue)[3]
}
Age1 <- vector()
Age1 <- Age

## 问题2，有了531个playerurl以后，要访问531个页面，看起来网站并没有设限制，但是依然
## 在访问两百多页以后出现错误。可以采用两个解析html函数，第二个从第一
## 个函数结束的那个元素开始运行，再将两次的结果合并，就可以解决问题了

Age2 <- vector()
for (i in 228:531){
    Age[i] <- xpathSApply(htmlTreeParse(playerurl[i], useInternal=TRUE), 
                          "//td[@class='normal']", xmlValue)[3]
}

Age2 <- Age[228:531]
Age <- c(Age1, Age2)
Age <- Age[1:531]

index <- which(Age=="NULL")
Age[index] <- "NA"
Age <- unlist(Age)

tbl[,2] <- Age
colnames(tbl)[2] <- "Age"
write.csv(tbl, "playerppi.csv")
