dat<-readRDS("../data/HotsLogs_Data_2015_12_30_2016_01_29_combined.RDS")

sampleReplays<-function(dat, n){
	replays<-unique(dat$ReplayID)
	x<-sample(replays, size = n, replace = FALSE)
	return(subset(dat, ReplayID %in% x))
}


getDict<-function(dat){
	ptm<-proc.time()
	dat$ReplayID<-as.character(dat$ReplayID)
	replays<-unique(dat$ReplayID)
	dict<-list()
	for(i in 1:nrow(dat)){
		key <- dat$ReplayID[i]
		if(key %in% names(dict)){
			dict[[key]]<-c(dict[[key]], i)
		} else {
			dict[[key]]<-c(i)
		}
	}
	print(proc.time() -ptm)
	return(dict)
}

calcWinRateHero<-function(dat, dict, hero = "Gazlowe"){
	replays<-unique(as.character(dat$ReplayID))
	gamesOutcome<-sapply(replays, function(x){
		game<-dat[dict[[x]], ]
		gameHeroNum<-sum(game$HeroName == hero)
		if(gameHeroNum == 1){
			if(subset(game, HeroName == hero)[, "Is.Winner"] == "True") return(c(1,0))
			else return(c(0,1))
		} else 
			return(c(0,0))
		})
	gamesWin<-sum(gamesOutcome[1,])
	gamesLoss<-sum(gamesOutcome[2,])
	return(gamesWin/(gamesWin+gamesLoss))
	
}

dat.sub<-sampleReplays(dat = dat, n = 10000)
dat.sub.dict<-getDict(dat = dat.sub)
winrates<-list()
for(i in  unique(as.character(dat.sub$HeroName))){
	print(i)
	winrate_i<-calcWinRateHero(dat=dat.sub, dict =dat.sub.dict, hero = i)
	print(winrate_i)
	winrates[[i]]<-winrate_i
}


