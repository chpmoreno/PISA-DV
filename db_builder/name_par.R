rm(list=ls())

source("setup.R")
setup("roger")
getwd()



#coeficients

par<-read.csv("parameters.csv")
param<-colnames(par)
#set the names
desc<-c("Intercept",
        "Nº of books: 11-25","Nº of books: 26-100", "Nº of books: 101-200", "Nº of books: 201-500", "Nº of books: More than 500",
        "Nº computers: One","Nº computers: Two","Nº computers: Three or more",
        "Math eff eq 1: Confident","Math eff eq 1: Not very confident", "Math eff eq 1: Not at all",
        "Mother education: High school", "Mother education: Lower secondary education", "Mother education: Primary education","Mother education: Not finished",
        "Math eff Discount TV: Confident", "Math eff Discount TV: Not very confident", "Math eff Discount TV: Not at all",
        "Internet: No", 
        "Father education: High school", "Father education: Lower secondary education", "Father education: Primary education","Father education: Not finished",
        "Internet connection at home: Yes, but not use it","Internet connection at home: No",
        "Nº cars: One","Nº cars: Two", "Nº cars: Three or more",
        "Printer at home: Yes, but not use it","Printer at home: No",
        "Familiar probability concepts: Heard once or twice", "Familiar probability concepts: Heard few times", "Familiar probability concepts: Heard it often", "Familiar probability concepts: Know it well",
        "Math self-concept not good: Agree","Math self-concept not good: Disagree", "Math self-concept not good: Strongly disagree",
        "Possess coumpter: No", 
        "Math eff train table: Confident","Math eff train table: Not very confident", "Math eff train table: Not at all",
        "Math eff sq meters: Confident","Math eff sq meters: Not very confident", "Math eff sq meters: Not at all",
        "Math concepts linear eq: Heard of it once or twice","Math concepts linear eq: Heard few times","Math concepts linear eq: Heard it often", "Math concepts linear eq: Know it well",
        "Perform poorly regardless: Agree","Perform poorly regardless: Disagree", "Perform poorly regardless: Strongly disagree",
        "Repeat primary school: Yes, once", "Repeat primary school: Yes, twice or more",
        "Attend preschool: Yes, one year or less","Attend preschool: Yes, more than a year",
        "Math concepts quadratic function: Heard it once or twice", "Math concepts quadratic function: Heard few times","Math concepts quadratic function: Heard it often", "Math concepts quadratic function: Know it well",
        "Teacher arrives late: Agree","Teacher arrives late: Disagree", "Teacher arrives late: Strongly disagree",
        "Math eff eq 2: Confident","Math eff eq 2: Not very confident", "Math eff eq 2: Not at all",
        "Rooms bath/shower: One","Rooms bath/shower: Two","Rooms bath/shower: Three or more",
        "Math anxiety tense: Agree","Math anxiety: Disagree","Math anxiety: Strongly disagree",
        "Math anxiety feel helpless: Agree","Feel helpless with maths: Disagree","Feel helpless with maths: Strongly disagree",
        "Math anxiety get very nervous: Agree","Math anxiety get very nervous: Disagree","Math anxiety get very nervous: Strongly disagree",
        "Understanding Graphs on News: Confident", "Understanding Graphs on News: not very confident", "Understanding Graphs on News: Not at all",
        "Shortage science lab equip school: Very little","Shortage science lab equip school: To some extend","Shortage science lab equip school: A lot",
        "First use of compters: 7-9 years old","First use of compters: 10-12 years old","First use of compters: 13 or more years old","First use of compters: Never",
        "Math concept polygon: Heard of it once or twice","Math concept polygon: Heard few times", "Math concept polygon: Heard it often", "Math concept polygon: Know it well",
        "Math concept cosine: Heard of it once or twice","Math concept cosine: Heard few times", "Math concept cosine: Heard it often", "Math concept cosine: Know it well",
        "Experience with Pure maths tasks: Sometimes","Experience with Pure maths tasks: Rarely","Experience with Pure maths tasks: Never",
        "Math anxiety Worry it will be difficult: Agree","Math anxiety Worry it will be difficult: Disagree","Math anxiety Worry it will be difficult: Strongly disagree",
        "Experience with Pure maths tasks eq 2: Sometimes","Experience with Pure maths tasks eq 2: Rarely","Experience with Pure maths tasks eq 2: Never",
        "Work in small groups: Most lessons","Work in small groups: Some lessons", "Work in small groups: Never",
        "Percieved poor performance: Agree","Percieved poor performance: Disagree", "Percieved poor performance: Strongly disagree",
        "Cellulars at home: One","Cellulars at home: Two","Cellulars at home: Three or more",
        "Math concepts divisor: Heard it once or twice","Math concepts divisor: Heard few times","Math concepts divisor: Heard it often","Math concepts divisor: Know it well",
        "Attitudes, too unreliable: Agree","Attitudes, too unreliable: Disagree", "Attitudes, too unreliable: Strongly disagree",
        "Complex project assigments: Most lessons","Complex project assigments: Some lessons","Complex project assigments: Never",
        "Mother job status: Working part-time", "Mother job status: Not working, looking for job", "Mother job status: Home duties",
        "Student transfer: Likely","Student transfer: Very likely",
        "Friends like math tests: Agree","Friends like math tests: Disagree", "Friends like math tests: Strongly disagree",
        "Teacher arrives early: Agree","Teacher arrives early: Disagree","Teacher arrives early: Strongly disagree",
        "Students truancy: Very little","Students truancy: To some extend", "Students truancy: A lot",
        "Experience applied math tasks: Sometimes","Experience applied math tasks: Rarely", "Experience applied math tasks: Never",
        "Math eff distance to scale: Confident","Math eff distance to scale: Not very confident", "Math eff distance to scale: Not at all",
        "Give up easily: Mostly like me","Give up easily: Somewhat like me","Give up easily: Not much like me", "Give up easily: Not at all like me",
        "Techincal reference book possession: No",
        "Shortage internet connectivity: Very little","Shortage internet connectivity: To some extend","Shortage internet connectivity: A lot")

par[2,]<-desc

write.csv(par,"parameters.csv")

#parameters per country
par_cnt<-as.data.frame(read.csv("parameters_cnt.csv"))
param_cnt<-colnames(par_cnt)


#set names
desc_cnt<-c("IDcountry","Intercept",
            "Nº of books: 11-25","Nº of books: 26-100", "Nº of books: 101-200", "Nº of books: 201-500", "Nº of books: More than 500",
            "Nº computers: One","Nº computers: Two","Nº computers: Three or more",
            "Math eff eq 1: Confident","Math eff eq 1: Not very confident", "Math eff eq 1: Not at all",
            "Mother education: High school", "Mother education: Lower secondary education", "Mother education: Primary education","Mother education: Not finished",
            "Math eff Discount TV: Confident", "Math eff Discount TV: Not very confident", "Math eff Discount TV: Not at all",
            "Internet: No", 
            "Father education: High school", "Father education: Lower secondary education", "Father education: Primary education","Father education: Not finished",
            "Internet connection at home: Yes, but not use it","Internet connection at home: No",
            "Nº cars: One","Nº cars: Two", "Nº cars: Three or more",
            "Printer at home: Yes, but not use it","Printer at home: No",
            "Familiar probability concepts: Heard once or twice", "Familiar probability concepts: Heard few times", "Familiar probability concepts: Heard it often", "Familiar probability concepts: Know it well",
            "Math self-concept not good: Agree","Math self-concept not good: Disagree", "Math self-concept not good: Strongly disagree",
            "Possess coumpter: No", 
            "Math eff train table: Confident","Math eff train table: Not very confident", "Math eff train table: Not at all",
            "Math eff sq meters: Confident","Math eff sq meters: Not very confident", "Math eff sq meters: Not at all",
            "Math concepts linear eq: Heard of it once or twice","Math concepts linear eq: Heard few times","Math concepts linear eq: Heard it often", "Math concepts linear eq: Know it well",
            "Perform poorly regardless: Agree","Perform poorly regardless: Disagree", "Perform poorly regardless: Strongly disagree",
            "Repeat primary school: Yes, once", "Repeat primary school: Yes, twice or more",
            "Attend preschool: Yes, one year or less","Attend preschool: Yes, more than a year",
            "Math concepts quadratic function: Heard it once or twice", "Math concepts quadratic function: Heard few times","Math concepts quadratic function: Heard it often", "Math concepts quadratic function: Know it well",
            "Teacher arrives late: Agree","Teacher arrives late: Disagree", "Teacher arrives late: Strongly disagree",
            "Math eff eq 2: Confident","Math eff eq 2: Not very confident", "Math eff eq 2: Not at all",
            "Rooms bath/shower: One","Rooms bath/shower: Two","Rooms bath/shower: Three or more",
            "Math anxiety tense: Agree","Math anxiety: Disagree","Math anxiety: Strongly disagree",
            "Math anxiety feel helpless: Agree","Feel helpless with maths: Disagree","Feel helpless with maths: Strongly disagree",
            "Math anxiety get very nervous: Agree","Math anxiety get very nervous: Disagree","Math anxiety get very nervous: Strongly disagree",
            "Understanding Graphs on News: Confident", "Understanding Graphs on News: not very confident", "Understanding Graphs on News: Not at all",
            "Shortage science lab equip school: Very little","Shortage science lab equip school: To some extend","Shortage science lab equip school: A lot",
            "First use of compters: 7-9 years old","First use of compters: 10-12 years old","First use of compters: 13 or more years old","First use of compters: Never",
            "Math concept polygon: Heard of it once or twice","Math concept polygon: Heard few times", "Math concept polygon: Heard it often", "Math concept polygon: Know it well",
            "Math concept cosine: Heard of it once or twice","Math concept cosine: Heard few times", "Math concept cosine: Heard it often", "Math concept cosine: Know it well",
            "Experience with Pure maths tasks: Sometimes","Experience with Pure maths tasks: Rarely","Experience with Pure maths tasks: Never",
            "Math anxiety Worry it will be difficult: Agree","Math anxiety Worry it will be difficult: Disagree","Math anxiety Worry it will be difficult: Strongly disagree",
            "Experience with Pure maths tasks eq 2: Sometimes","Experience with Pure maths tasks eq 2: Rarely","Experience with Pure maths tasks eq 2: Never",
            "Work in small groups: Most lessons","Work in small groups: Some lessons", "Work in small groups: Never",
            "Percieved poor performance: Agree","Percieved poor performance: Disagree", "Percieved poor performance: Strongly disagree",
            "Cellulars at home: One","Cellulars at home: Two","Cellulars at home: Three or more",
            "Math concepts divisor: Heard it once or twice","Math concepts divisor: Heard few times","Math concepts divisor: Heard it often","Math concepts divisor: Know it well",
            "Attitudes, too unreliable: Agree","Attitudes, too unreliable: Disagree", "Attitudes, too unreliable: Strongly disagree",
            "Complex project assigments: Most lessons","Complex project assigments: Some lessons","Complex project assigments: Never",
            "Mother job status: Working part-time", "Mother job status: Not working, looking for job", "Mother job status: Home duties",
            "Student transfer: Likely","Student transfer: Very likely",
            "Friends like math tests: Agree","Friends like math tests: Disagree", "Friends like math tests: Strongly disagree",
            "Teacher arrives early: Agree","Teacher arrives early: Disagree","Teacher arrives early: Strongly disagree",
            "Students truancy: Very little","Students truancy: To some extend", "Students truancy: A lot",
            "Experience applied math tasks: Sometimes","Experience applied math tasks: Rarely", "Experience applied math tasks: Never",
            "Math eff distance to scale: Confident","Math eff distance to scale: Not very confident", "Math eff distance to scale: Not at all",
            "Give up easily: Mostly like me","Give up easily: Somewhat like me","Give up easily: Not much like me", "Give up easily: Not at all like me",
            "Techincal reference book possession: No",
            "Shortage internet connectivity: Very little","Shortage internet connectivity: To some extend","Shortage internet connectivity: A lot")

par_cnt[,1]<-as.character(par_cnt[,1])
par_cnt[60,]<-desc_cnt

write.csv(par_cnt,"parameters_cnt.csv")

