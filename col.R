
n <- 100

r <- seq(from=0,to=1,length=n)   # radian
theta <- seq(from=0, to = 2 * pi, length = n)  # angle

par(mfrow=c(2,2))

for ( j in c(0.3,.6,.8,1)){
  plot(x=c(0,2), y=c(0,2),type='n'
       ,xaxt = 'n'
       ,yaxt = 'n'
       ,xlab = ''
       ,ylab = ''
       ,frame.plot = FALSE)
  
  for (i in r) {
    x <-  i * cos(theta) + 1
    y <-  i * sin(theta) + 1
    
    pals <- hsv(r,i,j)
    
    points(x,y,col=pals, pch = 21)
    title(sprintf( "color scheme using hsv, v = %f", j))
  }
}



