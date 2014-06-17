#COURSERA Class June 2014: "Getting and cleaning data"   - Peer reviewed project



#Load the feature list into R as character strings and format it into valide variable names
feature <- read.table(file="UCI HAR Dataset/features.txt",header=FALSE,stringsAsFactors=FALSE)
feature <- feature$V2

#Function that loads the subject, measurements and activity datasets into R
#for the  named splits ("train" or "test").
construct <- function(name){
        #Load the subjects
        subject <- read.table(file=paste("UCI HAR Dataset/",name,"/subject_",name,".txt",sep="")
                              ,header=FALSE)
        #Load all the measurement
        X <- read.table(file=paste("UCI HAR Dataset/",name,"/X_",name,".txt",sep="")
                        ,header=FALSE)
        #Load the activities
        y <- read.table(file=paste("UCI HAR Dataset/",name,"/y_",name,".txt",sep="")
                        ,header=FALSE)
        #Build the dataframe to return
        dataset <- data.frame(subject,X,y)
        #Name the dataframe variables
        names(dataset)=c("subject",feature,"activity")
        #Return the desired dataframe
        return(dataset)
}

#Build the combined data frame from the loaded training split and the test split
accelerometry=rbind(construct("train"),construct("test"))

#Extract the variables of interest: "subject","activity" 
#and the mean or standard deviations of other values.
#A regular expression is given to grepl to select the columns.
regexp="(subject)|(activity)|([Mm]ean)|(std)"
variableL=grepl(pattern=regexp,x=names(accelerometry))
accelerometry=accelerometry[,variableL]

#Reclass the activity variable from interger to factor
#and eventually rename these factors in a human friendly way.
#based on "./data/dataset/activity_labels.txt"
accelerometry$activity=as.factor(accelerometry$activity)
levels(accelerometry$activity)=tolower(c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                                 "SITTING","STANDING","LAYING"))


#Split the data by subject and by activity
variableL=!names(accelerometry) %in% c("activity","subject")
acc.split=split(x=accelerometry[,variableL],f=list(accelerometry$activity,accelerometry$subject),drop=FALSE)

#Create the tidy data set. It is currently empty.
average.measurements=data.frame(measurement=character(),activity=character(),subject=character(),average=character())

#Caculate the mean of each variable split by subject and by activity and appends it 
#to the tidy dataset average.measurements
for (i in seq_along(acc.split)){
        activity_subject=strsplit(x=names(acc.split)[i],split="[.]")
        average=colMeans(acc.split[[i]])
        for (j in seq_along(average)){
                average.measurements=rbind(average.measurements,
                                           data.frame(
                                                   measurement=names(average)[j],
                                                   activity=activity_subject[[1]][1],
                                                   subject=activity_subject[[1]][2],
                                                   average=average[j])
                                           )
        }
}

#Remove the names of the rows i.e. sets them to 1,2,3,...
row.names(average.measurements)=NULL

#Write the resulting data.frame into the long awaited tidy set in csv format
write.csv(x=average.measurements,file="tidydataset.txt",row.names=FALSE)
