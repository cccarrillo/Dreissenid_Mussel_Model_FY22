library(ggplot2)
library(readxl)
library(tidyr) # This library is necessary for converting the dataframe from long to wide format (pivot_wider function)

setwd("C:/Users/RDEL1CMC/Desktop/Congressional_Ad_Projects/Dreissenid_Mussel_Model/Results/") # set to your working directory

dat <- read_excel("Test_Sensitivity_Results.xlsx")

dat <- dat[c(1,3:4)] # I dropped the "parameter" variable -- necessary to use pivot_wider
dat$RunNumber <- paste("Run",dat$RunNumber, sep="") # Converting from number type to string
# pivot_wider makes a column for each RunNumber
# This way you can select min/max for the geom_ribbon function
dat %>% 
  ggplot(aes(x = TimeStep)) +
  #ylim(0,325) +
  scale_x_continuous(limits = c(1,7), expand = c(0,0)) +
  scale_y_continuous(limits = c(0,350), expand = c(0,0), breaks = seq(0, 350, 50)) +
  geom_ribbon(
    data = ~ pivot_wider(., names_from = RunNumber, values_from = infested),
    aes(ymin = Run6, ymax = Run10), fill = "blue", alpha = 0.25
  ) +
  geom_line(aes(y = infested,
                linetype=RunNumber), # added line type back inside "aes"
            color= "black", # added color outside "aes" so all would be black
            lwd  = 0.5, )  +
  scale_linetype_manual(name = "", values = c("dashed", "dotted", "solid")) + 
  ylab("Number of lakes infested") + xlab("Timestep") +
  
  theme_bw() +
  theme(legend.position = "none") +# this takes out the legend
  theme(axis.text=element_text(size=12), axis.title=element_text(size=14))+ # Changes the font size of axes labels
  theme(panel.grid.minor = element_blank()) # takes out the minor grid lines -- I did this because you don't have 0.5 timesteps

ggsave("HSI_12222022.jpg", height=10, width=8)


