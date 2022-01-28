#homework-2
library(shiny)
library(dplyr)
library(networkD3)
#数据处理
#Rwork.Rmd文件中对原数据进行了处理，并输出了MisLinks.csv，MisNode.csv文件
#这里进行读入
#如果要运行，这里filePath设置为你自己的path
MisLinks<-read.csv("/home/taolijie11111/Desktop/R-work/Rwork/MisLinks.csv",header = TRUE)
MisNodes<-read.csv("/home/taolijie11111/Desktop/R-work/Rwork/MisNodes.csv",header = TRUE)
MisLinks
MisNodes
#进行画图

#### Server ####
server <- function(input, output) {
     output$force <- renderForceNetwork(
          forceNetwork(MisLinks, MisNodes,"scoure", "target","value", "name", "size","group",
                       height = 960, width = 960,
                       colourScale = JS("d3.scaleOrdinal(d3.schemeCategory20);"), fontSize = 15,
                       fontFamily = "黑体", linkDistance = 300,
                       linkWidth = JS("function(d) { return Math.sqrt(d.value)*0.1; }"),
                       radiusCalculation = JS("Math.sqrt(d.nodesize)+6"), charge = -30,
                       linkColour = "#666", opacity = 1, zoom = FALSE, legend = FALSE,
                       arrows =TRUE, bounded = FALSE, opacityNoHover = 0.5,
                       clickAction = NULL)
     )
}

#### UI ####

ui <- shinyUI(fluidPage(
     
     titlePanel("Shiny networkD3 "),
     sidebarLayout(
          sidebarPanel(
               sliderInput("name", "Opacity (not for Sankey)", 0.6, min = 0.1,
                           max = 1, step = .1)
          ),
          mainPanel(
               tabsetPanel(
                    tabPanel("Force Network", forceNetworkOutput("force"))
               )
          )
     )
))

#### Run ####
shinyApp(ui = ui, server = server)