library(ggplot2)  # Adding libraries 
library(gridExtra)
library(dplyr)
library(markdown)
library(shiny)
library(shinythemes)
library(tidyverse)
library(RColorBrewer)
shinyUI(fluidPage(theme = shinytheme("flatly"),  # Adding a shiny theme
                  
                  
  navbarPage("IPL",  # Adding navigation bar
  tabPanel("Batting Analysis",  # Adding batting tab for navigation
                                      
                                      
  sidebarLayout(
   sidebarPanel(  
                                          
                                         
                                          
    selectInput("team", label = h3("Team"),  # Widget for selecting team
                choices = list("Kings XI Punjab",
                               "Rising Pune Supergiants",
                               "Gujarat Lions",
                               "Kolkata Knight Riders",
                               "Royal Challengers Bangalore",
                               "Delhi Daredevils",
                               "Sunrisers Hyderabad",
                               "Mumbai Indians",
                               "Chennai Super Kings",
                               "Gujarat Lions",
                               "Rajasthan Royals"),
                selected = "Chennai Super Kings"),            
                                                      
    
    radioButtons("season",   # Widget for selecting season
                 label = h3("Season"), 
                 choices = list("Season 1 (2008)" = 2008, 
                                "Season 2 (2009)" = 2009, 
                                "Season 3 (2010)" = 2010,
                                "Season 4 (2011)" = 2011,
                                "Season 5 (2012)" = 2012,
                                "Season 6 (2013)" = 2013,
                                "Season 7 (2014)" = 2014,
                                "Season 8 (2015)" = 2015,
                                "Season 9 (2016)" = 2016),
                 selected = 2008),
    helpText("Note: Team did not compete for the season where the chart doesn't show up")
    
    
    
    
    ,width = 3 ),
    
  
   
   mainPanel(
     tabsetPanel(
       tabPanel("Rankings",  # Adding subset tabs
                
                plotOutput("Batsman_plot")  # Calling batsman plot 
                ),
     
       tabPanel("Over Analysis",  # Adding subset tabs
                
                plotOutput("overbatsman_plot")  # Calling batsman plot     
                
       ))))),
     
   
   
   
   
  
  
  tabPanel("Bowling Analysis",  # Adding bowling tab for navigation
           
           
           sidebarLayout(
             sidebarPanel(
               
               selectInput("teambw", label = h3("Team"),  # Widget for selecting team
                           choices = list("Kings XI Punjab",
                                          "Rising Pune Supergiants",
                                          "Gujarat Lions",
                                          "Kolkata Knight Riders",
                                          "Royal Challengers Bangalore",
                                          "Delhi Daredevils",
                                          "Sunrisers Hyderabad",
                                          "Mumbai Indians",
                                          "Chennai Super Kings",
                                          "Gujarat Lions",
                                          "Rajasthan Royals"),
                           selected = "Chennai Super Kings"),
               
               
               radioButtons("seasonbw",  # Widget for selecting season
                            label = h3("Season"), 
                            choices = list("Season 1 (2008)" = 2008, 
                                           "Season 2 (2009)" = 2009, 
                                           "Season 3 (2010)" = 2010,
                                           "Season 4 (2011)" = 2011,
                                           "Season 5 (2012)" = 2012,
                                           "Season 6 (2013)" = 2013,
                                           "Season 7 (2014)" = 2014,
                                           "Season 8 (2015)" = 2015,
                                           "Season 9 (2016)" = 2016),
                            
                            
                            selected = 2008),
               helpText("Note: Team did not compete for the season where the chart doesn't show up")
               
               ,width = 3  ),
             
             mainPanel(
               
               tabsetPanel(
                 tabPanel("Rankings",  # Adding subset tabs
                          
                          
                          plotOutput("Bowler_plot")  #  Calling bowler plot
                 ),
                 
                 tabPanel("Over Analysis",  # Adding subset tabs
                          plotOutput("bowlerana_plot"))  #  Calling bowler plot
                          
                          
               
               )
           ))
  ),
  
  tabPanel("Strength/Weakness Analysis",  # Adding strength/weaknesstab for navigation
           
           
           sidebarLayout(
             sidebarPanel(
               
               radioButtons("player", label = h3("Top Performers"), # Widget for selecting top performer
                           choices = list("SK Raina",
                                          "RG Sharma",
                                          "V Kohli",
                                          "G Gambhir",
                                          "MS Dhoni",
                                          "DA Warner",
                                          "RV Uthappa",
                                          "CH Gayle",
                                          "S Dhawan",
                                          "AB de Villiers"),
                                          
                                          selected = "SK Raina"),
               
               sliderInput("seasonsw", label = h3("Season"), min = 2008,  # Widget for selecting season
                           max = 2016, value = 2008, step = 1,
                           animate = animationOptions(loop = FALSE, interval = 2000)),  # Animation
               
               
               helpText("Note: Player did not compete for the season where the chart doesn't show up")
               
               
               ,width = 3),
             
             mainPanel(plotOutput("SW_plot") )  #  Calling strength/weakness plot
             )
           )))
)
  
             
             
