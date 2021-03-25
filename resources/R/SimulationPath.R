## ---- pathPractical1
library('CircStats')
library('tidyverse')


ggplot_save <- function(...) ggplot2::ggplot(...) 
ggplot <- function(...) ggplot2::ggplot(...) + scale_fill_manual(values = wesanderson::wes_palette(name = "Darjeeling1")) + scale_color_manual(values = wesanderson::wes_palette(name = "Darjeeling1")) 
#remotes::install_github('MarieEtienne/coursesdata', force = TRUE)

set.seed(123)
N <- 1e5

# Parameters Section ------------------------------------------------------
gamma.wc <- c(0.99, 0.9)
mu.wc <- c(0, 0)  

mu.ln <- c(-5, -4)
sigma.ln <- c(0.3, 0.3)

trans.mat <- matrix(c(0.999, 0.005, 0.001, 0.995), ncol=2)
State <- rep(1,N)
for(i in 1:(N-1))
{
  State[i+1]<- sample(1:2, size=1, prob = trans.mat[State[i],])
}

# simulation Section ------------------------------------------------------

movement <- tibble(phi = sapply(1:N, function(d){rwrpcauchy(1, location=mu.wc[State[d]], rho=gamma.wc[State[d]])}) ,
                   V= exp(rnorm(N, mean=mu.ln[State]-sigma.ln[State]^2/2, sigma.ln[State])),
                   State = factor(State))

p1 <- movement %>% ggplot + geom_histogram(aes(x = phi, fill = State), alpha = 0.6, 
                                     position = 'identity') + labs(x = 'Turning angle')
p2 <- movement %>% ggplot + geom_histogram(aes(x = V, fill = State), alpha = 0.6, 
                                     position = 'identity') + labs(x = 'Speed')

p3 <- movement %>% ggplot + geom_point(aes(x = phi, y = V, col = State)) + 
  labs(x = 'Turning angle', y = 'Speed', col ='State')


## ---- pathPractical2
movement <- movement %>% 
  mutate(x = cumsum(c(cos(cumsum(phi))*V)),
         y = cumsum(c(sin(cumsum(phi))*V)), 
         date = as.POSIXlt(Sys.time()-12*24*3600 + cumsum(c(rep(10, N))), origin = "GMT")) %>%
  add_row(x=0, y= 0, date = Sys.time()-12*24*3600, State = 'Start') %>% 
  arrange(date) %>% 
  rowid_to_column("ID")

                    

# Plot section ------------------------------------------------------------
movement %>% 
  ggplot() + geom_path(aes(x=x, y = y))  +
  geom_point(data = filter(movement, State== 'Start'), size =1.5,
             mapping = aes(x=x, y=y), col = wesanderson::wes_palette('Darjeeling1')[3])


## ---- pathPractical3
movement %>% 
  ggplot() + geom_path(aes(x=x, y = y), alpha = 0.8)+
  geom_point(aes(x=x, y = y, col = State), size = 0.2)+
  geom_point(data = filter(movement, State== 'Start'),
             size = 2, 
             mapping = aes(x=x, y=y, col = State)) +
  theme(legend.position = 'bottom')

# Sampling section --------------------------------------------------------
sample.path <- function( initial.path, acquisition.step=1)
{
  initial.path %>% slice( seq(1,n(), by = acquisition.step))
}

## ---- pathPractical4


l_plot_movement <- lapply( c(1, 5, 10, 15, 20, 30, 60), function(s){
   sampled.path <- sample.path(initial.path = movement, acquisition.step=6*s)
   p <- sampled.path  %>% 
     ggplot() + geom_path(aes(x=x, y = y))+
     geom_point(data = filter(movement, State== 'Start'),
                size = 2, 
                mapping = aes(x=x, y=y, col = State)) +
     ggtitle(paste0('One position every ', s,' mn' ))
   print(p)
   p
 })
  
## ---- pathPractical5
s <- 5
l_plot_movement[[s]]


## ---- pathPractical6

## ---- pathPractical7
s <- 10
l_plot_movement[[s]]


# Observed Data -----------------------------------------------------------
s <- 15
observed.path<- sample.path(initial.path = movement, acquisition.step=6*s)
observed.path  %>% 
  ggplot() + geom_point(aes(x=x, y = y), size = 0.2)+
  geom_point(data = filter(movement, State== 'Start'),
             size = 2, 
             mapping = aes(x=x, y=y, col = State))


save(list = c("movement", "observed.path"), file = "trajEx.Rd")

ggplot <- ggplot_save()