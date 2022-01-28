#homework-2
#使用visnetwork库尝试
library(visNetwork)
nodes<-read.csv("/home/taolijie11111/Desktop/R-work/Rwork/MisNodes.csv",header = TRUE)
edges<-read.csv("/home/taolijie11111/Desktop/R-work/Rwork/edges.csv",header = TRUE)
nodes<-data.frame(id=nodes$name,value=nodes$size,group=nodes$group,label=nodes$name)
edges<-data.frame(from=edges$From,to=edges$TO,value=edges$SizeEdge)
visNetwork(nodes, edges,width = "100%",height = "500px")%>%     # square for all nodes
     visEdges(arrows ="to") %>% 
     visOptions(nodesIdSelection = TRUE) %>%
     visNodes(label = nodes$label )%>%
     visEvents(selectNode = "function(properties) {
      alert('selected nodes ' + this.body.data.nodes.get(properties.nodes[0]).id);}")

visSave(network, file = "virnetwork.html")