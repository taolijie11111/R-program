clickJS <- "
d3.selectAll('.xtooltip').remove(); 
d3.select('body').append('div')
  .attr('class', 'xtooltip')
  .style('position', 'absolute')
  .style('border', '1px solid #999')
  .style('border-radius', '3px')
  .style('padding', '5px')
  .style('opacity', '0.85')
  .style('background-color', '#fff')
  .style('box-shadow', '2px 2px 6px #888888')
  .html('name: ' + d.name + '<br>' + 'group: ' + d.group)
  .style('left', (d3.event.pageX) + 'px')
  .style('top', (d3.event.pageY - 28) + 'px');
"

library(shiny)
library(networkD3)

server <- function(input, output) {
     output$simple <- renderSimpleNetwork({
          src <- c("A", "A", "A", "A", "B", "B", "C", "C", "D")
          target <- c("B", "C", "D", "J", "E", "F", "G", "H", "I")
          
          node_names <- factor(sort(unique(c(as.character(src), 
                                             as.character(target)))))
          nodes <- data.frame(name = node_names, group = 1, size = 8)
          links <- data.frame(source = match(src, node_names) - 1, 
                              target = match(target, node_names) - 1, 
                              value = 1)
          
          forceNetwork(Links = links, Nodes = nodes, Source = "source",
                       Target = "target", Value = "value", NodeID = "name",
                       Group = "group", clickAction = clickJS)
     })
}

ui <- shinyUI(fluidPage(simpleNetworkOutput("simple")))
shinyApp(ui = ui, server = server)