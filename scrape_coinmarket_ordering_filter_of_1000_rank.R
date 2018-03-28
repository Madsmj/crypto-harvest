
#install.packages(c("curl", "httr"))


library(XML)
library(jsonlite)

setwd("/home/mmj/tools/R/crypto_scripts/dump/")

rd1 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR")
#rd2 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&start=100")
#rd3 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&start=200")
#rd4 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&start=300")
#rd5 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&start=400")
#rd6 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&start=500")
#rd7 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&start=600")
#rd8 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&start=700")
#rd9 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&start=800")
#rd10 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&start=900")
#rd11 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&start=1000")
#rd12 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&start=1100")
#rd13 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&start=1200")
#rd14 <- fromJSON("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&start=1300")


#rdSum <- rbind(rd1, rd2, rd3, rd4, rd5, rd6, rd7, rd8, rd9, rd10)
#rd <- rbind(rd1, rd2, rd3, rd4, rd5)
rdSum <- rbind(rd1)

#L <- t(read.csv(file='cryptolist2.csv', header = FALSE))

L <- c('bitcoin', 'litecoin', 'monero', 'ripple', 'ethereum',	'bitcoin-cash',	'iota', 'dash', 'nem', 'bitcoin-gold',	'qtum', 'neo',	'stellar',	'lisk',	'verge',	'bitconnect',	'nxt', 'zcash', 'augur', 'dogecoin', 'tether', 'ark', 'salt', 'zcoin', 'tenx', 'vechain', 'steem', 'siacoin', 'ardor', 'tron')

rd <- subset(rdSum, id %in% L)  
#rd <- rdSum


marketcap_u <- data.frame(rd$market_cap_usd)
tradevol_u <- data.frame(rd$'24h_volume_usd')
currentDate <- Sys.Date()

colnames(marketcap_u) <- Sys.time()
colnames(tradevol_u) <- Sys.time()

marketcap_rows_u <-data.frame(t(marketcap_u))
tradevol_rows_u <-data.frame(t(tradevol_u))

colnames(marketcap_rows_u) <- rd$id
caplistFilename <-paste(currentDate,'cap_list.Rda')
if (file.exists(caplistFilename)) {
  yesterday <- readRDS(file=caplistFilename)
  newdf <- rbind(yesterday, marketcap_rows_u)
} else {
  newdf <- marketcap_rows_u
}
rank(newdf)
saveRDS(newdf, file=caplistFilename)
write.csv(newdf, file = paste(currentDate, "output.csv"))


colnames(tradevol_rows_u) <- rd$id
captradevioFilename <-paste(currentDate,'cap_trade_vol.Rda')
if (file.exists(captradevioFilename)) {
  yesterdaytradevol <- readRDS(file=captradevioFilename)
  newtradevoldf <- rbind(yesterdaytradevol, tradevol_rows_u)
} else {
  newtradevoldf <- tradevol_rows_u
}
rank(newtradevoldf)
saveRDS(newtradevoldf, file=captradevioFilename)
write.csv(newtradevoldf, file = paste(currentDate, "tradevol.csv"))

