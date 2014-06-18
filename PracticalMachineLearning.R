library(caret)
library(plyr)



data<-read.csv("pml-training.csv")
test<-read.csv("pml-testing.csv")




## Remove tha user name and number from the data ## 

newdata<-data[,8:160]
test<-test[,8:160]

## Turn all data except from the class into numeric##

for(i in 1:152){
        
        newdata[,i]<-as.numeric(newdata[,i])
        test[,i]<-as.numeric(test[,i])
}

## turn date column to be read as date##
#newdata[,3] <-as.Date(newdata[,3],format="%d/%m/%Y %h:%m")
#test[,3]<-as.Date(test[,3],format="%d/%m/%Y %h:%m")



set.seed(125)




#preproc<-preProcess(imputedata[,-153], method="pca")

###                                                    ###
###                                                    ###
###                          PREPROCESS STEPS          ###
###                                                    ###     
###                                                    ###



## Find near zero variance variables and remove them from the data##
nzv <- nearZeroVar(newdata, saveMetrics = TRUE)

newdata<-newdata[,nzv$nzv==FALSE]
test<-test[,nzv$nzv==FALSE]

## Impute data using knnImpute for replacing missing values ##

impute<-preProcess(newdata[,-length(newdata)],method="knnImpute")

imputedata<-predict(impute,newdata[,-length(newdata)])
testnew<-predict(impute,test[,-length(test)])

set.seed(135)

## Find highly correllated columns and remove them ##
Corellation <- cor(imputedata)
highcorellation<-findCorrelation(Corellation, cutoff = 0.8)

imputedata<-imputedata[,-highcorellation]
testnew<-testnew[,-highcorellation]


## standardise data ##

standard<-preProcess(imputedata,method=c("center","scale"))
training<-predict(standard,imputedata)
testing<-predict(standard,testnew)

set.seed(12335)
preproc<-preProcess(training,method="pca",thres=0.9)
trainfinal<-predict(preproc,training)
testfinal<-predict(preproc,testing)


##Tune model##
gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 10),
                        n.trees = (1:30)*50,
                        shrinkage = 0.1)

#define the parameters for the training
fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated ten times
  repeats = 1,
  classProbs = TRUE)

algoname="gbm"
  
set.seed(250)

model <- train(newdata[,length(newdata)] ~ ., data = trainfinal,
                   method = algoname,
                   trControl = fitControl,
                   metric = "Accuracy")
                   
                  
  
predict<-predict(model,trainfinal)

accuracy<-confusionMatrix(predict,newdata[,length(newdata)])


results<-predict(model,testfinal)

pml_write_files = function(x){
        n = length(x)
        for(i in 1:n){
                filename = paste0("problem_id_",i,".txt")
                write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
        }
}

pml_write_files(results) 




