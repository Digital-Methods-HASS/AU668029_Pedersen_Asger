library(tidyverse)

kongs <- read_csv("./Data/Exerxice-1-Ark1.csv")
kongs$Duration <- kongs$End_of_Reign-kongs$Beginning_of_Reign
kongs[30,1:6]
kongs1 <- kongs[-c(30,40),]

mean(kongs1$Duration,na.rm=T)
class(kongs1$Duration)

kongs1 %>% 
  select(Duration , Sovereign) %>% 
  filter(Duration > 10) %>% 
  count()

kongs1$AboveAverage <- kongs1$Duration<mean(kongs1$Duration,na.rm=T)

kongs1 %>% 
  mutate(AboveAverage1=Duration>mean(kongs1$Duration,na.rm=T)) %>% 
  group_by(AboveAverage1) %>% 
  tally()

kongs1 %>% 
  select(Duration) %>% 
  arrange(desc(Duration))

kongs1 %>% 
  mutate(Days=Duration*365)

kongs1 %>% 
  filter(Christian)
