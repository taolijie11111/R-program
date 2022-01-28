library(shiny)
library(networkD3)
library(dplyr)
# Load data
MisLinks<-read.csv("/home/taolijie11111/Desktop/R-work/Rwork/MisLinks.csv",header = TRUE)
MisNodes<-read.csv("/home/taolijie11111/Desktop/R-work/Rwork/MisNodes.csv",header = TRUE)
MisNodes$link_id <- 1:nrow(MisNodes) - 1
MisLinks
MisNodes

ui <- fluidPage(
     # Select type of trend to plot
     selectInput(inputId = "name", label = strong("Please input your number"),
                 choices = MisNodes$name,
                 selected = "name"),
     
     mainPanel(forceNetworkOutput(outputId = "force", height = "700px"))
)

server <- function(input, output) {
     
     dat <- reactive({
          MisNodes %>% #这里的结果只能是一个
               filter(next_schname %in% input$name) %>%
               mutate(schname = factor(schname),
                      next_schname = factor(next_schname))#创建新变量
     })
     
     links <- reactive({
          data.frame(source = dat()$schname,
                     target = dat()$next_schname,
                     value  = dat()$count)
     })
     
     nodes <- reactive({
          data.frame(name = c(as.character(links()$source),
                              as.character(links()$target)) %>%
                          unique) 
     })
     
     
     
     links2 <-reactive({
          links <- links()
          links$IDsource <- match(links$source, nodes()$name) - 1
          links$IDtarget <- match(links$target, nodes()$name) - 1
          
          links %>%
               filter(source == input$school)
     })
     
     
     output$force <- renderForceNetwork(
          forceNetwork(sublinks(), subnodes(),"scoure", "target","value", "name", "size","group",
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

shinyApp(ui = ui, server = server)