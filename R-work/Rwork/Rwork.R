# Load packages
library(shiny)
library(dplyr)
library(readr)
library(networkD3)


# Load data
MisLinks<-read.csv("/home/taolijie11111/Desktop/R-work/Rwork/MisLinks.csv",header = TRUE)
MisNodes<-read.csv("/home/taolijie11111/Desktop/R-work/Rwork/MisNodes.csv",header = TRUE)
MisNodes$link_id <- 1:nrow(MisNodes) - 1

print("Please select the choice:\n 1:input number \n 2:view all numbers")
Chioces<-readline(prompt = "your choice: ")
if(Chioces==1){
     number<-readline(prompt = "please input your number: ")
     #ceshi 
     subnodes<-MisNodes[MisNodes$name ==number, ]
     if(length(subnodes$name)==0){
          print("i don't have this number，please run this file and input again. ")   
     }else{
          r<-subnodes$link_id
          a<-which(MisLinks$scoure==r)
          b<-which(MisLinks$target==r)
          if (length(a)==0) {
               c<-b
          }else if(length(b)==0){
               c<-a
          }else {
               c<-cbind(a,b)
          }
          sublinks<-MisLinks[c,]
          x<-MisNodes[sublinks$scoure+1,]
          y<-MisNodes[sublinks$target+1,]
          z<-rbind(x,y)
          z<-unique(z)
          subnodes<-z
          subnodes  #这里就可以得到subnodes了
          
          subnodes$Number<-c(0:(length(z$name)-1))
          z<-subnodes
          names(z)[names(z) == "link_id"] <- "scoure"
          D1<-inner_join(sublinks,z,by="scoure")
          sublinks$scoure <- D1$Number
          names(z)[names(z) == "scoure"] <- "target"
          D1<-inner_join(sublinks,z,by="target")
          sublinks$target <- D1$Number
          
          forceNetwork(sublinks, subnodes,"scoure", "target","value", "name", "size","group",
                       height = 960, width = 960,
                       colourScale = JS("d3.scaleOrdinal(d3.schemeCategory20);"), fontSize = 15,
                       fontFamily = "黑体", linkDistance = 300,
                       linkWidth = JS("function(d) { return Math.sqrt(d.value)*0.8; }"),
                       radiusCalculation = JS("Math.sqrt(d.nodesize)+6"), charge = -30,
                       linkColour = "#666", opacity = 1, zoom = FALSE, legend = FALSE,
                       arrows =TRUE, bounded = FALSE, opacityNoHover = 0.5,
                       clickAction = NULL)
     }
    
     
}else if(Chioces==2){
     forceNetwork(MisLinks, MisNodes,"scoure", "target","value", "name", "size","group",
                  height = 960, width = 960,
                  colourScale = JS("d3.scaleOrdinal(d3.schemeCategory20);"), fontSize = 15,
                  fontFamily = "黑体", linkDistance = 300,
                  linkWidth = JS("function(d) { return Math.sqrt(d.value)*0.8; }"),
                  radiusCalculation = JS("Math.sqrt(d.nodesize)+6"), charge = -30,
                  linkColour = "#666", opacity = 1, zoom = FALSE, legend = FALSE,
                  arrows =TRUE, bounded = FALSE, opacityNoHover = 0.5,
                  clickAction = NULL)
}else{
     print("i don't have this choice，please run this file and input again. ")
}

