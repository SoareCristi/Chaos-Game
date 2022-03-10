library(shiny)

shinyServer (function(input, output, session){
  
  coord_lists <- reactive({
    
      ratio <- input$fraction*(input$gen>-1)
      
      # maximum number of points to be drawn
      len <- 55000 
      
      # vertices_coord matrix which contains all endpoints
      vertices_coord <- matrix(NA, ncol=3, nrow=6)
      
      # constants
      y_const <- 0.5
      x_const  <- 0.75
      
      # coords for the 6 points that forms a hexagonal shape
      vertices_coord[1,] <- c(1,0,2*y_const) #up
      vertices_coord[2,] <- c(2,x_const,0.5) #up-right
      vertices_coord[3,] <- c(3,x_const,-0.5) #down-right
      vertices_coord[4,] <- c(4,0,-2*y_const) #down
      vertices_coord[5,] <- c(5,-x_const,-0.5) #down-left
      vertices_coord[6,] <- c(6,-x_const,0.5) #up-left
      
      # coords matrix which contains all coords for all of the points
      coords <- matrix(NA,ncol=2,nrow=(len+1))

      # first point is always random in the plot
      coords[1,] <- c(runif(1,-x_const,x_const),runif(1,-2*y_const,2*y_const))
      
      for (i in 1:len){
        row <- i+1
        a <- sample(1:6, 1)
        #random generated number for the direction of the new point
        x <- vertices_coord[a,2]
        y <- vertices_coord[a,3]
        x.new <- (1-ratio)*x + (ratio)*coords[i,1]
        y.new <- (1-ratio)*y + (ratio)*coords[i,2]
        # new coords for the next point
        coords[row,]<-c(x.new,y.new)
      }
      
      return(list(vertices_coord,coords))
  })  
  
  
  output$Plot <- renderPlot({
    
    vertices_coord      <- coord_lists()[[1]]
    coords              <- coord_lists()[[2]]
      
    y_const <- 0.5
    x_const  <- sqrt(3)/2

    par(mar = c(0.5,0.5,0.5,0.5))
    plot(0,
         0,
         xlim = c(-x_const, x_const),
         ylim = c(-2*y_const, 2*y_const),
         col = 0,
         yaxt = "none",
         xaxt = "none"
         )
    
    # colored simulation
    if(input$colorsCheckBox == TRUE){
      if (input$points != 0){
        # displaying as many points as selected with slider and switching the color after an amount of points drawn
        for(i in 1:input$points){  
          if (i > 40000)
            points(coords[i,1], coords[i,2], pch = ".", cex = 0.1, col = "red")
          else if (i > 10000)
            points(coords[i,1], coords[i,2], pch = ".", cex = 1, col = "green")
          else
            points(coords[i,1], coords[i,2], pch = ".", cex = 4, col = "black")
          
        }
      }
    }
    # non-color simulation
    else
      points(coords[1:input$points,1], coords[1:input$points,2], pch=".", cex= 0.2, col = "black")
    
    # drawing 6 endpoints in hexagonal shape using the coords from above
    points(vertices_coord[,2], vertices_coord[,3], pch = ".", cex = 5, col = "blue")
    
  })# renderPlot
 
})# shinyServer