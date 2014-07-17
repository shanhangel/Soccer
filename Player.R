library(XML)

url <- paste("http://www.premierleague.com/en-gb/players/ea-sports-player-performance-index.html?paramSearchTerm=&paramClubId=&paramSeason=2013-2014&paramPosition=&paramEaBreakdownType=ACCUMULATIVE&paramGameWeek=1&paramItemsPerPage=100&paramSelectedPageIndex=", 1:6, sep="")
tbl <- readHTMLTable(url[1])[[1]]

for (i in 2:6){
    tbl <- rbind(tbl, readHTMLTable(url[i])[[1]], stringsAsFactors=FALSE)
}

name_1 <- strsplit(tbl[,4], " ")

name <- vector()
for (i in 1:531){
    name[i] <- tolower(paste(name_1[[i]][1], "-", name_1[[i]][2], sep=""))
}

playerurl <- paste("http://www.premierleague.com/en-gb/players/profile.overview.html/", 
                    name, sep="")

Age <- vector()
for (i in 1:10){
    Age[i] <- readLines(playerurl[i])[1907]
}

tbl[,2] <- Age
colnames(tbl)[2] <- "Age"



age <- readLines(playerurl[1])[1907]

