rm(list = ls())
if(!is.null(dev.list())) dev.off()   #### it clears the plots

############# Hald's Cement Data: Backward method

#cem=data.frame(cement,row.check.names=T);cem
g<-lm(y~. , cement)
summary(g)
g1<-update(g, ~. -x3)
summary(g1)
g2<-update(g1, ~. -x4)
summary(g2)

########### Forward and setpwise as an Exercise ??????


#######################Example 1.1

Fishes=data.frame(y=c(100,388,755,1288,230,0,551,345,0,348),
                      x1=c(14.3,19.1,54.6,28.8,16.1,10.0,28.5,13.8,10.7,25.9),
                      x2=c(15.0,29.4,58.0,42.6,15.9,56.4,95.1,60.6,35.2,52.0),
                      x3=c(12.2,26.0,24.2,26.1,31.6,23.3,13.0,7.5,40.3,40.3),
                      x4=c(48.0,152.2,469.7,485.9,87.6,6.9,192.9,105.8,0.0,116.6))
fit<-lm(y~x1+x2+x3+x4,data=Fishes)
(AIC1=AIC(update(fit,.~.-x4)))
(AIC2=AIC(update(fit,.~.-x1)))
(BIC1=BIC(update(fit,.~.-x4)))
(BIC2=BIC(update(fit,.~.-x1)))

attach(Fishes)
n=length(y)
p=4
(mse=anova(fit)[5,3]) ### row 5 column 3 from the anova output

(sse1=anova(update(fit,.~.-x4))[4,2])
(sse2=anova(update(fit,.~.-x1))[4,2])

(cp1=sse1/mse-n+2*p)
(cp2=sse2/mse-n+2*p)
###############################################Exapmle 1.2 and  Example 1.3

### Hald's Cement Data

library(MASS)
data("cement")
str(cement)
head(cement)
library(leaps)
l<- regsubsets(y ~ x1+x2+x3+x4, data=cement,
                 int=TRUE, nbest=6)
### display the plot for all sub-models using Mallows' Cp
plot (l, scale = "Cp")
### display the plot for all sub-models using R^2
plot (l, scale="r2")


 
###############################################Example 1.4
X
rm(list = ls())
if(!is.null(dev.list())) dev.off()   #### it clears the plots

ChemicalData=data.frame(y=c(41.5, 33.8, 27.7, 21.7, 19.9, 15, 12.2,
                            4.3, 19.3, 6.4, 37.6, 18, 26.3, 9.9, 25, 14.1, 15.2, 15.9, 19.6),
                        x1=c(162, 162, 162, 162, 172, 172, 172, 172, 167, 177, 157, 167,
                             167, 167, 167, 177, 177, 160, 160), x2=c(23, 23, 30, 30, 25, 25,
                                                                      30, 30, 27.5, 27.5, 27.5, 32.5, 22.5, 27.5, 27.5, 20, 20, 34, 34),
                        x3=c(3, 8, 5, 8, 5, 8, 5, 8, 6.5, 6.5, 6.5, 6.5, 6.5, 9.5, 3.5, 6.5,
                             6.5, 7.5, 7.5))
library(DAAG)
fit=lm(y~x1+x2+x3,data=ChemicalData)
CVlm(data=ChemicalData,fit,m=3)

###############################################Example 1.5

library(qpcR)
PRESS=PRESS(fit <- lm(y~x1+x2+x3,data=ChemicalData))
PRESS$stat;  PRESS$P.square

residuals=residuals(fit)
OutPut=data.frame(residuals,PRESS$residuals)
head(OutPut)

###############################################Example 1.6





###############################################Example 1.7


rm(list = ls())
if(!is.null(dev.list())) dev.off()   #### it clears the plots

library(MASS)
data(cement)
fit<-lm(y ~ x1 + x2 + x3 + x4, data = cement)
e=residuals(fit)
X=model.matrix(fit)
H=X%*%solve(t(X)%*%X)%*%t(X)
ep=e/(1-diag(H))
(press<-t(ep)%*%ep)

library(MPV)
PRESS(fit)

PRESS(update(fit,~.-x4))
PRESS(update(fit,~.-x3))
PRESS(update(fit,~.-x2))
PRESS(update(fit,~.-x3-x4))

###############################################Example 1.8



library(genridge)
data(Acetylene)
head(Acetylene)
?Acetylene
amod0 <- lm(yield ~ temp + ratio + time + I(time^2) + temp:time, data=Acetylene)
summary(amod0)


##########

library(genridge)
attach(Acetylene)
time
P=yield
T=(temp-mean(temp))/sd(temp)
H=(ratio-mean(ratio))/sd(ratio)
C=(time-mean(time))/sd(time)

library(leaps)
formula=P~T+H+C+T*H+T*C+H*C+I(T^2)+I(H^2)+I(C^2)
sub=regsubsets(formula,nbest=3,int=TRUE,data=Acetylene)

plot(sub,scale="r2")
plot(sub,scale="adjr2")
plot(sub,scale="Cp")

fit=lm(P~T+H+C+T*H+T*C+H*C+I(T^2)+I(H^2)+I(C^2))
summary(fit)

library(MPV)
PRESS(update(fit,~.-T^2-C))
PRESS(update(fit,~.-T:C-C))
PRESS(lm(P~T+H+T*H+I(T^2)))



###############################################Example 1.9

rm(list = ls())
if(!is.null(dev.list())) dev.off()   #### it clears the plots

library(MASS)
data(cement)
head(cement)
X=cbind(1,cement$x1,cement$x2,cement$x3,cement$x4); y=cement$y
X=X-matrix(rep(apply(X,2,mean),each=nrow(X)),nrow(X),ncol(X))
y=y-mean(y)

#####install.packages("lars")

library(lars)
l=lars(X, y, type="lasso")
coef(l)
summary(l)

################# lasso betahat based on Cp criteria

coef(l)[4,]
coef(l)[which.min(summary(l)$Cp),]


################# AIC, BIC criterias

n=length(y)
betahats=coef(l)

(yhat1=X%*%coef(l)[2,])

yhats=X%*%t(betahats)
ys=matrix(rep(y,ncol(yhats)),n,ncol(yhats))
rs=ys-yhats

SSEs=colSums(rs^2)
dfs=l$df
AICs=n*log(SSEs/n)+2*dfs ;AICs
coef(l)[which.min(AICs),]

BICs=n*log(SSEs/n)+log(n)*dfs
coef(l)[which.min(BICs),]

### PRESS

H=X%*%ginv(t(X)%*%X)%*%t(X)
dHs=matrix(rep(diag(H),5),13,5)
eps=rs/(1-dHs)
PRESSs=colSums(eps^2)
coef(l)[which.min(PRESSs),]



###############################################Example 1.10
#### Longley's Data Set
library(stats)
data(longley)
head(longley)
colnames(longley)
longley.n.df=longley

colnames(longley.n.df)=c("x6","x5","x4","x3","x2","x1","y")

fit <- lm(formula = y ~ x6 + x5 + x4 + x3 + x2 + x1, data = longley.n.df)
summary(fit)
(stp<-step(fit,direction="both",test="F",trace=0))
summary(stp)$coefficients

############ lasso selection

X=model.matrix(fit)
y=longley.n.df[,7]
lfit<-lars(X,y,type="lasso")
coef(lfit)
summary(lfit)
round(coef(lfit)[which.min(summary(lfit)$Cp),],3)


############################## Faraway lasso 
##############################

#### install.packages("faraway")
library(faraway)

require(lars)
data(state)
statedata <- data.frame(state.x77,row.names=state.abb)
head(statedata)
lmod <- lars(as.matrix(statedata[,-4]),statedata$Life)
coef(lmod)
summary(lmod)
round(coef(lfit)[which.min(summary(lmod)$Cp),],3)
plot(lmod)


##################

set.seed(123)
cvlmod <- cv.lars(as.matrix(statedata[,-4]),statedata$Life)
cvlmod$index[which.min(cvlmod$cv)]

data(fat,package="faraway")
predict(lmod,s=0.65657,type="coef",mode="fraction")$coef
coef(lm(Life.Exp ~ Population+Murder+HS.Grad+Frost, statedata))


data(meatspec, package="faraway")
trainmeat <- meatspec[1:172,]
testmeat <- meatspec[173:215,]
modlm <- lm(fat ~ ., trainmeat)
trainy <- trainmeat$fat
trainx <- as.matrix(trainmeat[,-101])
lassomod <- lars(trainx,trainy)
set.seed(123)
cvout <- cv.lars(trainx,trainy)
cvout$index[which.min(cvout$cv)]
testx <- as.matrix(testmeat[,-101])
predlars <- predict(lassomod,testx,s=0.0101,mode="fraction")

rmse <- function(x,y) sqrt(mean((x-y)^2))
rmse(testmeat$fat, predlars$fit)
predlars <- predict(lassomod, s=0.0101, type="coef", mode="fraction")
plot(predlars$coef,type="h",ylab="Coefficient")
sum(predlars$coef != 0)

######################## Faraway Model selection 

library(faraway)
data(state)
head(state)
statedata <- data.frame(state.x77,row.names=state.abb,check.names=T)





