library(XML)

url <- paste("http://www.premierleague.com/en-gb/players/ea-sports-player-performance-index.html?paramSearchTerm=&paramClubId=&paramSeason=2013-2014&paramPosition=&paramEaBreakdownType=ACCUMULATIVE&paramGameWeek=1&paramItemsPerPage=100&paramSelectedPageIndex=", 1:6, sep="")
tbl <- readHTMLTable(url[1])[[1]]


for (i in 2:6){
    tbl <- rbind(tbl, readHTMLTable(url[i])[[1]])
}

## debug�˼��飬������������������棺1.��Щplayer�������Ƿ�Ӣ�ģ���"Yaya Tour��"��Ӧ
## ��url��׺Ϊ��yaya-toure��������Ҫ�õ�url������������ϵķ�ʽ����Ӧ�ôӱ���ҳ��ץȡ��
## ��readLines�������Զ�ȡ�Ǽ�ҳ�����ҵ���Ӧ�İ���url������(�����Ƕ����С�/en-gb/players/profile.overview.html/����,
## ����""���ŷָ����õ�����"en-gb/players/profile.overview.html/luis-suarez"��Ԫ�أ�
## ����1�ͽ���ˡ�


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

## ���ϼ����ظ����������ѭ����


wholeplayer <- c(playerurl_1, playerurl_2, playerurl_3, playerurl_4,
                       playerurl_5, playerurl_6)

playerurl <- paste("http://www.premierleague.com", wholeplayer, sep="")

## ��������playerurl�Ժ���xpathSApply����Age��ֵ������531��ҳ��
Age <- vector()
for (i in 1:531){
    Age[i] <- xpathSApply(htmlTreeParse(playerurl[i], useInternal=TRUE), 
                          "//td[@class='normal']", xmlValue)[3]
}
Age1 <- vector()
Age1 <- Age

## ����2������531��playerurl�Ժ�Ҫ����531��ҳ�棬��������վ��û�������ƣ�������Ȼ
## �ڷ������ٶ�ҳ�Ժ���ִ��󡣿��Բ�����������html�������ڶ����ӵ�һ
## �������������Ǹ�Ԫ�ؿ�ʼ���У��ٽ����εĽ���ϲ����Ϳ��Խ��������

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