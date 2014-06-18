Weight Lifting Exercise Recognition 
========================================================
Background
========================================================
This research focuses on the problem of investigating "how (well)" a weight lifting activity was performed by a participant. The "how (well)" investigation has only received little attention so far, even though it potentially provides useful information for a large variety of applications,such as sports training.


Six young health participants were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions: exactly according to the specification (Class A), throwing the elbows to the front (Class B), lifting the dumbbell only halfway (Class C), lowering the dumbbell only halfway (Class D) and throwing the hips to the front (Class E). 

Class A corresponds to the specified execution of the exercise, while the other 4 classes correspond to common mistakes. Participants were supervised by an experienced weight lifter to make sure the execution complied to the manner they were supposed to simulate.


Data Gathering
=====================================================
Data were gathered using accelerometer, gyroscope and magnetometer on the belt, dumbell, arm and glove of the participants. For each reading the mean, variance, standard deviation, max, min, amplitude, kurtosis and skewness were calculated leading to a total of 160 derived feature sets.

Preprocessing
===============================================================
The number of features in the dataset is too high for a machine learning algorithm to be used efficiently so we need to perform some preprocessing to reduce the number of features used in our prediction model and identify the most significant ones. 

First, we examine the dataset for any features that have zero or no variation and therefore cannot give much information on the variation of the activities. We identify 59 variables that have small variation and remove these from the dataset. 

Subsequently we find any missing values and use the knnImpute to fill them using their nearest neighbors. We proceed by finding features that are closely related and remove them since one of them can give us enough information about the variation. We remove any features that have a corellation higher than 80%. The following graph shows two features that are closely related.


```
## Warning: Removed 19216 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1.png) 


Finally we use Principal Component Analysis to reduce the number of features further. We keep the number of features that explain 90% of the variance. Below you can see the plot of the features and the proportion of Variance the explain.

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2.png) 


Model Selection and Error Estimate
===================================================================================
Our final model prediction features using the preprocessing steps have been reduced to 22. We train our model on this feature set. For the training we have tried various algorithms and compared their in-sample error. We have concluded that the best algorithm to use was the Gradient Boosting Algorithm. 

The algorithm was trained using k-fold validation. The train set was split into 10 folds and the model was trained on the 9 folds and tested for its error on the 10th for all the combinations. The average in-sample error was 17.3%. Below we give the table of the average accuracy of our algorithm on the training set and the accuracy on each Class.


```
##         A       B       C       D       E
## A 0.88010 0.05545 0.03002 0.02048 0.01395
## B 0.04217 0.81624 0.05071 0.02621 0.06467
## C 0.04811 0.09721 0.71087 0.08574 0.05808
## D 0.06180 0.03602 0.04068 0.81149 0.05000
## E 0.01741 0.03482 0.02829 0.01585 0.90364
```



We expect the out of sample error to be larger since we expect the algorithm to pick some noise and have a better accuracy on the train set. We tested our algorithm on the train set and we got 25% error which is larger but not by much. This suggests that our algorithm can give a good generalised prediction.   

Our complete code for the Preprocessing, the Model Training and the Prediction is given in the R code file in the Githup repo.
