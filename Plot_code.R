library(ggplot2)
library(readxl)
library(tidyr) # This library is necessary for converting the dataframe from long to wide format (pivot_wider function)

setwd("C:/Users/RDEL1CMC/Desktop/Congressional_Ad_Projects/Dreissenid_Mussel_Model/Results") # set to your working directory

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
    aes(ymin = Run5, ymax = Run1), fill = "blue", alpha = 0.25
  ) +
  geom_line(aes(y = infested,
                color = RunNumber),
            lwd  = 0.5, )  +
  scale_linetype_manual(name = "", values = c("dotted", "solid", "dashed")) +
  scale_color_manual(name = "", values = c("black", "black", "black")) +
  ylab("Number of lakes infested") + xlab("Timestep") +
  
  theme_bw() +
  theme(legend.position = c(0.15, 0.75), legend.background = element_blank())

#ggsave("Boat_Threshold.jpg", height=10, width=8)


