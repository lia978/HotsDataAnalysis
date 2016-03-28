
#data download from:
# https://d1i1jxrdh2kvwy.cloudfront.net/Data/HOTSLogs%20Data%202015-12-30%20-%202016-01-29.zip
#reddit post:https://www.reddit.com/r/heroesofthestorm/comments/43q3jc/hots_logs_data_export_19_million_games/

dat.hero<-read.csv("../data/HotsLogs_Data_2015_12_30_2016_01_29_Folder/HeroIDAndMapID_2015-12-30-2016-01-29.csv")
dat.replay<-read.csv("../data/HotsLogs_Data_2015_12_30_2016_01_29_Folder/Replays_2015-12-30-2016-01-29.csv")
dat.characters<-read.csv("../data/HotsLogs_Data_2015_12_30_2016_01_29_Folder/ReplayCharacters_2015-12-30-2016-01-29.csv")

library(plyr)
dat.join<-join(dat.characters, dat.replay, by = "ReplayID")

dat.heroid<-subset(dat.hero, ID %in% 0:47)
dat.heroid$HeroID<-dat.heroid$ID
dat.heroid$HeroName<-dat.heroid$Name
dat.heroid<-dat.heroid[, c("HeroID", "HeroName", "Group", "SubGroup")]
dat.mapid<-subset(dat.hero, !(ID %in% 0:47))
dat.mapid$MapID<-dat.mapid$ID
dat.mapid$MapName<-dat.mapid$Name
dat.mapid<-dat.mapid[, c("MapID", "MapName")]


dat.join<-join(dat.join, dat.heroid, by = "HeroID")
dat.join<-join(dat.join, dat.mapid, by = "MapID")


saveRDS(dat.join, "../data/HotsLogs_Data_2015_12_30_2016_01_29_combined.RDS")

#dat<-readRDS("../data/HotsLogs_Data_2015_12_30_2016_01_29_combined.RDS")
