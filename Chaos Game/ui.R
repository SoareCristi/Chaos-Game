library(shinyBS)
library(shiny)

shinyUI(fluidPage(
  
  
  
  titlePanel("Chaos Game: hexagon"),
  
  sidebarLayout(

    sidebarPanel(
             
        sliderInput("fraction", label = "Fraction to hexagon vertex:",
                    min = 0.01,
                    max = .99,
                    value = .33,
                    step = .01),
        "Simularea default este cu fractia 1/3 (Hexagonul Sierpinski)",

        sliderInput("points",
                    "Number of points (n):",
                    min = 1,
                    max = 55000,
                    step = 30,
                    value = 1000,
                    animate = animationOptions(interval = 10)),
        
        checkboxInput("colorsCheckBox", "Color mode (slow)", value = FALSE, width = NULL),
        
        bsButton("gen", style = "secondary", label="Randomize")
         
    ),#sidebarPanel

    
    mainPanel(

      div(
          div(plotOutput("Plot"),
              style="width:500px",
              inline="TRUE"
          )
          ,align="center"
      )

    )#mainPanel

  )#sidebarLayout
)# fluidPage
)# shinyUI