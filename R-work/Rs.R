# Load packages
library(shiny)
library(dplyr)
library(readr)
library(networkD3)


# Load data
MisLinks<-read.csv("/home/taolijie11111/Desktop/R-work/Rwork/MisLinks.csv",header = TRUE)
MisNodes<-read.csv("/home/taolijie11111/Desktop/R-work/Rwork/MisNodes.csv",header = TRUE)
MisNodes$link_id <- 1:nrow(MisNodes) - 1
MisLinks
MisNodes
# Define UI
ui <- fluidPage(
               # Select type of trend to plot
                selectInput(inputId = "name", label = strong("Please input your number"),
                            choices = MisNodes$name,
                            selected = "name"),
                
                 mainPanel(forceNetworkOutput(outputId = "force", height = "700px"))
               
)


# Define server function
server <- function(input, output) {
     #初步得到subnodes
     subnodes0<-reactive(MisNodes[MisNodes$name ==input$name, ])
     
     #初步得到sublinks
     r<-reactive(subnodes0()$link_id)
     a<-reactive(which(MisLinks$scoure==r()))
     b<-reactive(which(MisLinks$target==r()))    
     c<-reactive({
          if (length(a)==0) {
               c<-b
          }else if(length(b)==0){
               c<-a
          }else {
               c<-cbind(a,b)
          }
     })
     sublinks0<-reactive(MisLinks[c(),])
    
     x<-reactive(MisNodes[sublinks0$scoure+1,])
     y<-reactive(MisNodes[sublinks0$target+1,])
     subnodes<-reactive({
          unique(rbind(x(),y())) 
          subnodes$Number<-c(0:(length(z$name)-1))
     })
     
   #3
     z<-reactive({
          z<-subnodes()
          z$scoure<-z$link_id
          z$target<-z$link_id
     })
     D1<-reactive(inner_join(sublinks0(),z(),by="scoure"))
     D2<-reactive(inner_join(sublinks0(),z(),by="target"))
     sublinks<-reactive({
          sublinks<-sublinks0()
          sublinks$scoure <- D1$Number
          sublinks$target <- D2$Number
     })   
     
     
     output$force <- renderForceNetwork(        #画图
          forceNetwork(sublinks(), subnodes(),"scoure", "target","value", "name", "size","group",
                       height = 960, width = 960,
                       colourScale = JS("d3.scaleOrdinal(d3.schemeCategory20);"), fontSize = 15,
                       fontFamily = "黑体", linkDistance = 300,
                       linkWidth = JS("function(d) { return Math.sqrt(d.value); }"),
                       radiusCalculation = JS("Math.sqrt(d.nodesize)+6"), charge = -30,
                       linkColour = "#666", opacity = 1, zoom = FALSE, legend = FALSE,
                       arrows =TRUE, bounded = FALSE, opacityNoHover = 0.5,
                       clickAction = NULL)
     )
}

# Create Shiny object
shinyApp(ui = ui, server = server)
