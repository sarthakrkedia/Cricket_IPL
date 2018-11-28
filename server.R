library(ggplot2)  # Added all the required libraries
library(gridExtra)
library(dplyr)
library(shiny)
library(shinythemes)
library(tidyverse)
library(RColorBrewer)

shinyServer(function(input, output) {  
  file1<-read.csv("deliveries.csv")  # Reading CSV files
  file2<-read.csv("matches.csv")
  m_data<-merge(file2, file1, by.x = "id", by.y = "match_id")  # Merging both the files
  
  
  output$Batsman_plot <- renderPlot({  # Plot for batsman rankings
    
    limited_col<-select(m_data, batting_team, season,batsman, batsman_runs)  # Selecting required columns from whole data
    grp_data <- group_by(limited_col, batting_team, season, batsman)  # Grouping data
    summ_data<-summarise(grp_data, batsman_runs= sum(batsman_runs, na.rm = TRUE))  # Aggregating data
    filt_data<-filter(summ_data, season == input$season, batting_team == input$team)  # Filtering data based on the input
    
    final_data <- filt_data[order(-filt_data$batsman_runs),]  # Sorting the data
    
    ggplot(final_data[1:10,], aes(reorder(batsman, batsman_runs),batsman_runs,label=batsman_runs))+ #Plot for batsman rankings
      geom_bar(aes(fill = -batsman_runs),stat = 'identity')+
      labs(x = 'Batsman', y = 'Runs Scored',title='Top 10 Batsmen', subtitle="Total Runs scored by the Batsman in that season")+
      geom_text(color="white", size=5,hjust = 1.5)+
      coord_flip()+ 
      theme_minimal(base_size = 12)
  })
  
  output$overbatsman_plot <- renderPlot ({
    
    a1<-select(m_data, batting_team, season,batsman, batsman_runs)
    b1<- group_by(a1, batting_team, season, batsman)
    c1<-summarise(b1, batsman_runs= sum(batsman_runs, na.rm = TRUE))
    d1<-filter(c1, season == input$season, batting_team == input$team)
    e1 <- d1[order(-d1$batsman_runs),]
    top6batsman <- e1$batsman[1:10]
    
    f1<-select(m_data, season, batting_team, batsman,over, batsman_runs)
    g1 <- group_by(f1, season, batting_team,over, batsman)
    h1<-summarise(g1, batsman_runs= mean(batsman_runs, na.rm = TRUE))
    i1<-filter(h1, season == input$season, batting_team == input$team, batsman==top6batsman[1] |
                 batsman==top6batsman[2]|batsman==top6batsman[3]|batsman==top6batsman[4]|batsman==top6batsman[5]|
                 batsman==top6batsman[6]|batsman==top6batsman[7]|batsman==top6batsman[8] |batsman==top6batsman[9] )
    
    sp <- ggplot(i1, aes(x=over, y=batsman_runs)) + geom_point(colour=" navy blue", size=2, fill="navy blue") +geom_line(colour=" navy blue")
    sp + facet_wrap( ~batsman, ncol=3) +labs(x = "Over", y = 'Average Runs Scored for the Season',title='Over by Over Analysis of Top Run Scorers', subtitle="Chart presenting the style of batting for the batsman in that season")+
       theme_minimal(base_size = 12)
    
  },height = 500, width = 900)
  
  
  output$bowlerana_plot <- renderPlot({ 
    aa<-select(m_data, bowling_team, season,bowler,ball,total_runs)
  mmm1<-filter(aa, ball==1 | ball==2| ball==3| ball==4| ball==5| ball==6)
  bb <- group_by(mmm1, bowling_team, season, bowler, ball)
  dddd<-summarise(bb, Runs= mean(total_runs), na.rm = TRUE)
  eee<-filter(dddd, season == input$seasonbw, bowling_team == input$teambw)
  fff <- eee[order(-eee$ball),]
 
  ggplot(fff, aes(ball, bowler) )+ geom_tile(aes(fill = Runs),colour = "white")+ scale_fill_gradient(low = "white", high = "steelblue")+theme_minimal(base_size = 12)+labs(x= "Ball in an Over", y ="Bowler", title="Runs Conceded by a Bowler in an Over",subtitle="Heat map presenting ball by ball analysis of the bowler. Each ball represents runs conceded by the bowler in that ball.")
  
    
    
  },height = 500, width = 900)
  
  
  
  
  output$Bowler_plot <- renderPlot ({
    aa<-select(m_data, bowling_team, season,bowler, count)
    bb <- group_by(aa, bowling_team, season, bowler)
    dddd<-summarise(bb, wickets= sum(count), na.rm = TRUE)
    eee<-filter(dddd, season == input$seasonbw, bowling_team == input$teambw)
    fff <- eee[order(-eee$wickets),]
    
    ggplot(fff[1:10,], aes(reorder(bowler, wickets),wickets, label=wickets, color=-wickets)) + 
      geom_point(stat='identity', size=9) + 
      geom_segment(aes(x=bowler, 
                       xend=bowler, 
                       y=0, 
                       yend=wickets, color=-wickets)) + geom_text(color="white", size=5)+
      labs(x = 'Bowler', y = 'Wickets',title="Bowler Rankings", 
           subtitle="Bowler Vs. Wickets - Shows the top ten wicket takers for the team" 
      ) + coord_flip()+
      theme_minimal(base_size = 14)
    
    
  })
  
  output$SW_plot <- renderPlot({
    
    limcol<-select(m_data, season, batting_team, batsman,bowler, batsman_runs)
    by_day <- group_by(limcol, season, batting_team, batsman,bowler)
    mm1<-summarise(by_day, Avg_batsman_runs= mean(batsman_runs, na.rm = TRUE))
    pm<-filter(mm1, season == input$seasonsw,  batsman == input$player)
    mm<-pm[ order(-pm[,5]), ]
    mm$Avg_batsman_runs <- round((mm$Avg_batsman_runs - mean(mm$Avg_batsman_runs))/sd(mm$Avg_batsman_runs), 2)  
    mm$bowler_type <- ifelse(mm$Avg_batsman_runs < 0, "below", "above") 
    mm <- mm[order(mm$Avg_batsman_runs), ]  # sort
    mm$bowler <- factor(mm$bowler, levels = mm$bowler) 
    
    
    
    ggplot(mm, aes(x=mm$bowler, y=Avg_batsman_runs, label=Avg_batsman_runs)) + 
      geom_point(stat='identity', aes(col=bowler_type), size=10)  +
      scale_color_manual( name = "Category",
                         labels = c("Strength", "Weakness"), 
                         values = c("above"="#004C99", "below"="#990000")) + 
      geom_text(color="white", size=4) +
      labs(x = 'Normalised Runs Scored', y = 'Bowler', title="Analysing Strength/Weakness of a Batsman", 
           subtitle="Normalised Runs scored against Bowlers") + 
      ylim(-2.5, 2.5) +
      coord_flip()+theme_minimal(base_size = 14)
    
    
    
  },height = 550, width = 900)
  
})            


