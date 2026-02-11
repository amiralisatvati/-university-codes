library(shiny)
library(ggplot2)
library(car)
library(lmtest)
library(readr)

ui <- fluidPage(
  titlePanel("Advanced Regression Diagnostics"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Upload CSV File", accept = ".csv"),
      selectInput("dependent", "Select Dependent Variable", choices = NULL),
      uiOutput("independent_vars_ui"),
      actionButton("analyze", "Analyze"),
      hr(),
      downloadButton("downloadCSV", "Download Diagnostics CSV")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Cook's Distance", plotOutput("cooksPlot")),
        tabPanel("Leverage", plotOutput("leveragePlot")),
        tabPanel("Leverage vs Cook's", plotOutput("levCookPlot")),
        tabPanel("DFFITS", plotOutput("dffitsPlot")),
        tabPanel("Summary Table", tableOutput("diagTable"))
      )
    )
  )
)

server <- function(input, output, session) {
  data <- reactive({
    req(input$file1)
    read.csv(input$file1$datapath)
  })
  
  observe({
    req(data())
    updateSelectInput(session, "dependent", choices = names(data()))
    output$independent_vars_ui <- renderUI({
      checkboxGroupInput("independent_vars", "Select Independent Variables", choices = names(data()))
    })
  })
  
  model <- eventReactive(input$analyze, {
    req(data(), input$dependent, input$independent_vars)
    formula <- as.formula(paste(input$dependent, "~", paste(input$independent_vars, collapse = "+")))
    lm(formula, data = data())
  })
  
  diagnostics <- reactive({
    req(model())
    m <- model()
    n <- length(resid(m))
    p <- length(coef(m))
    
    data.frame(
      Observation = 1:n,
      Cooks_Distance = cooks.distance(m),
      Leverage = hatvalues(m),
      DFFITS = dffits(m),
      Residuals = residuals(m),
      Fitted = fitted.values(m)
    )
  })
  
  output$cooksPlot <- renderPlot({
    req(model())
    plot(cooks.distance(model()), type = "h", main = "Cook's Distance", ylab = "Cook's Distance")
    abline(h = 4/(length(resid(model())) - length(coef(model())) - 1), col = "red", lty = 2)
  })
  
  output$leveragePlot <- renderPlot({
    req(model())
    plot(hatvalues(model()), type = "h", main = "Leverage (Hat Values)", ylab = "Leverage")
    abline(h = 2 * length(coef(model())) / length(resid(model())), col = "red", lty = 2)
  })
  
  output$levCookPlot <- renderPlot({
    req(model())
    plot(hatvalues(model()), cooks.distance(model()), 
         xlab = "Leverage", ylab = "Cook's Distance",
         main = "Leverage vs Cook's Distance")
    abline(h = 4/(length(resid(model())) - length(coef(model())) - 1), col = "red", lty = 2)
    abline(v = 2 * length(coef(model())) / length(resid(model())), col = "red", lty = 2)
  })
  
  output$dffitsPlot <- renderPlot({
    req(model())
    plot(dffits(model()), type = "h", main = "DFFITS", ylab = "DFFITS")
    abline(h = c(-2, 2) * sqrt(length(coef(model())) / length(resid(model()))), col = "red", lty = 2)
  })
  
  output$diagTable <- renderTable({
    head(diagnostics(), 20)
  })
  
  output$downloadCSV <- downloadHandler(
    filename = function() { "regression_diagnostics.csv" },
    content = function(file) {
      write.csv(diagnostics(), file)
    }
  )
}

shinyApp(ui = ui, server = server)
