# Download financial report from Sina

getsheets <- function(symbol,type,file){
  pre="http://money.finance.sina.com.cn/corp/go.php/vDOWN_";
  mid="/displaytype/4/stockid/";
  end="/ctrl/all.phtml";
  
  if(type=="BS"){
    url=paste(pre,"BalanceSheet",mid,symbol,end,sep="");
    destfile=paste(file,"BalanceSheet_",symbol,".xls",sep="");
  }
  if(type=="PS"){
    url=paste(pre,"ProfitStatement",mid,symbol,end,sep="");
    destfile=paste(file,"ProfitStatement_",symbol,".xls",sep="");
  }
  if(type=="CF"){
    url=paste(pre,"CashFlow",mid,symbol,end,sep="");
    destfile=paste(file,"CashFlow_",symbol,".xls",sep="");
  }
  download.file(url, destfile);
}

stocksymbols <- c('惠达卫浴' = '603385' 
                  ,'海鸥住工' = '002084' 
                  ,'建霖家居' = '603408' 
                  ,'松霖科技' = '603992' 
                  ,'瑞尔特' = '002790'
                  )


# Download 
for (i in stocksymbols) {
  for (j in c('CF','BS','PS')) {
    getsheets(i,j,"D://temp//fs//")
  }
}

# compile the fs

files <- list.files("D:/temp/fs")
i <- "ProfitStatement_603992.xls"

for (i in files) {
  s <- unlist(strsplit(i,split="_"))
  s[2] <- substr(s[2],1,6)
  
  f <- read.csv(file.path("D:/temp/fs/",i),sep="\t")
  
  nc <- ncol(f) 
  tmp <- reshape(f
                 ,varying = list(2:nc)  # from 2nd column on
                 ,direction = 'long'    # from wide to long format
                 )
  cnames <- colnames(f)[2:nc]
  tmp["period"] <- cnames[tmp$time]
  tmp["company"] <- s[2]
  tmp["report"] <- s[1]
  
  if(exists('res') && is.data.frame(get('res'))) {
    res <- rbind(res, tmp)
  }
  else {
    res <- tmp
  }
}

res <- res[,c(1,3:7)]
colnames(res) <- c('item', 'amount','sortid','period','company','report')
res$period <- substr(res$period,2,9)
res$amount <- as.numeric(res$amount)
res <- res[!is.na(res$amount),]
res <- res[!res$period=="19700101",]

fye <- res[substr(res$period,5,8)=='1231',]



write.csv(fye,file="D:/temp/fs.csv")
