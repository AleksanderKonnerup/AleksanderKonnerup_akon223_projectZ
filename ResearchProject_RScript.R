# Reading the SpringBoot Data
library(readxl)
IssueDataSpringBootFormatted <- read_excel("~/UoA_Kandidat_3rd_semester/ResearchProject/Data/IssueDataSpringBootFormatted.xlsx")
ContributorDataSpringBootFormatted <- read_excel("~/UoA_Kandidat_3rd_semester/ResearchProject/Data/ContributorDataSpringBootFormatted.xlsx")

# Changing user and actor id to numeric and merging the two datasets on iss/user/id
IssueDataSpringBootFormatted$`issue/user/id` = as.numeric(IssueDataSpringBootFormatted$`issue/user/id`)
IssueDataSpringBoot <- merge(x=IssueDataSpringBootFormatted, y=ContributorDataSpringBootFormatted, by="issue/user/id")
IssueDataSpringBoot$`actor/id` = as.numeric(IssueDataSpringBoot$`actor/id`)

# Creating SelfAssigned field
IssueDataSpringBoot$SelfAssigned = IssueDataSpringBoot$`actor/id` == IssueDataSpringBoot$`issue/user/id`

# New dataframe to calculate Reassigned
Reassigned <- data.frame("issue/user/id" = IssueDataSpringBoot$`issue/user/id`, "actor/id" = IssueDataSpringBoot$`actor/id`, "issue/id" = IssueDataSpringBoot$`issue/id`)

Reassigned$dupliUserId <- duplicated(Reassigned$issue.user.id)
Reassigned$dupliActorId <- duplicated(Reassigned$actor.id)
Reassigned$HasBeenReassigned <- Reassigned$dupliUserId == TRUE & Reassigned$dupliActorId == FALSE

#Importing reassigned from reassigned-dataframe
IssueDataSpringBoot$Reassigned <- Reassigned$HasBeenReassigned

#Testing linear regression models on SPringBoot Data
lmSelfAssignedSpringBoot = lm(IssueDataSpringBoot$SelfAssigned~IssueDataSpringBoot$contributions)
Summary(lmSelfAssignedSpringBoot)

lmNotSelfAssignedSpringBoot = lm(IssueDataSpringBoot$SelfAssigned==FALSE~IssueDataSpringBoot$contributions)
Summary(lmNotSelfAssignedSpringBoot )

lmSelfAssignedSpringBoot = lm(IssueDataSpringBoot$SelfAssigned~IssueDataSpringBoot$contributions+IssueDataSpringBoot$Reassigned)

lmNotSelfAssignedSpringBoot = lm(IssueDataSpringBoot$SelfAssigned==FALSE~IssueDataSpringBoot$contributions+IssueDataSpringBoot$Reassigned)

View(lmNotSelfAssignedSpringBoot)
View(lmSelfAssignedSpringBoot)
View(lmSelfAssignedSpringBoot[["model"]])

#Same procedure with Guava, first read in files then data manipulation
library(readxl)
IssueDataGuavaFormatted <- read_excel("~/UoA_Kandidat_3rd_semester/ResearchProject/Data/IssueDataGuavaFormatted.xlsx")
ContributorDataGuavaFormatted <- read_excel("~/UoA_Kandidat_3rd_semester/ResearchProject/Data/ContributorDataGuavaFormatted.xlsx")

IssueDataGuavaFormatted$`issue/user/id` = as.numeric(IssueDataGuavaFormatted$`issue/user/id`)
IssueDataGuava <- merge(x=IssueDataGuavaFormatted, y=ContributorDataGuavaFormatted, by="issue/user/id")

IssueDataGuava$`actor/id` = as.numeric(IssueDataGuava$`actor/id`)
IssueDataGuava$SelfAssigned = IssueDataGuava$`actor/id` == IssueDataGuava$`issue/user/id`

ReassignedGuava <- data.frame("issue/user/id" = IssueDataGuava$`issue/user/id`, "actor/id" = IssueDataGuava$`actor/id`, "issue/id" = IssueDataGuava$`issue/id`)

ReassignedGuava$dupliUserId <- duplicated(ReassignedGuava$issue.user.id)
ReassignedGuava$dupliActorId <- duplicated(ReassignedGuava$actor.id)
ReassignedGuava$HasBeenReassigned <- ReassignedGuava$dupliUserId == TRUE & ReassignedGuava$dupliActorId == FALSE
IssueDataGuava$Reassigned <- ReassignedGuava$HasBeenReassigned

#Testing linear regression models on Guava data, and SprinBoot again for summary
lmSelfAssignedGuava = lm(IssueDataGuava$SelfAssigned~IssueDataGuava$contributions+IssueDataGuava$Reassigned)
Summary(lmSelfAssignedGuava)

lmNotSelfAssignedGuava = lm(IssueDataGuava$SelfAssigned==FALSE~IssueDataGuava$contributions+IssueDataGuava$Reassigned)
Summary(lmNotSelfAssignedGuava)

lmSelfAssignedReassignedFalseSpringBoot = lm(IssueDataSpringBoot$SelfAssigned~!(IssueDataSpringBoot$Reassigned) + IssueDataSpringBoot$contributions)

lmNotSelfAssignedReassignedFalseSpringBoot = lm(IssueDataSpringBoot$SelfAssigned==FALSE~!IssueDataSpringBoot$Reassigned + IssueDataSpringBoot$contributions)

lmSelfAssignedReassignedFalseGuava = lm(IssueDataGuava$SelfAssigned~IssueDataGuava$contributions+ !IssueDataGuava$Reassigned)

lmNotSelfAssignedReassignedFalseGuava = lm(IssueDataGuava$SelfAssigned==FALSE~IssueDataGuava$contributions+!IssueDataGuava$Reassigned)

Summary(lmSelfAssignedGuava)
summary(lmSelfAssignedGuava)
summary(lmNotSelfAssignedGuava)
summary(lmSelfAssignedReassignedFalseGuava)
summary(lmNotSelfAssignedReassignedFalseGuava)
summary(lmSelfAssignedSpringBoot)
summary(lmNotSelfAssignedSpringBoot)
summary(lmSelfAssignedReassignedFalseSpringBoot)
summary(lmNotSelfAssignedReassignedFalseSpringBoot)

#Renaming columns for Guava so that vif can be applied on the regression models
names(IssueDataGuava)[names(IssueDataGuava) == "issue/user/id"] <- "issue_user_id"
names(IssueDataGuava)[names(IssueDataGuava) == "actor/login"] <- "actor_login"
names(IssueDataGuava)[names(IssueDataGuava) == "actor/id"] <- "actor_id"
names(IssueDataGuava)[names(IssueDataGuava) == "issue/id"] <- "issue_id"
names(IssueDataGuava)[names(IssueDataGuava) == "issue/number"] <- "issue_number"
names(IssueDataGuava)[names(IssueDataGuava) == "issue/title"] <- "issue_title"
names(IssueDataGuava)[names(IssueDataGuava) == "issue/user/login"] <- "issue_user_login"
names(IssueDataGuava)[names(IssueDataGuava) == "issue/state"] <- "issue_state"
names(IssueDataGuava)[names(IssueDataGuava) == "issue/comments"] <- "issue_comments"
names(IssueDataGuava)[names(IssueDataGuava) == "issue/created_at"] <- "issue_created_at"
names(IssueDataGuava)[names(IssueDataGuava) == "issue/updated_at"] <- "issue_updated_at"
names(IssueDataGuava)[names(IssueDataGuava) == "issue/closed_at"] <- "issue_closed_at"
names(IssueDataGuava)[names(IssueDataGuava) == "issue/author_association"] <- "issue_author_association"

#Renaming columns for SpringBoot so that vif can be applied on the regression models
names(IssueDataSpringBoot)[names(IssueDataSpringBoot) == "issue/user/id"] <- "issue_user_id"
names(IssueDataSpringBoot)[names(IssueDataSpringBoot) == "actor/login"] <- "actor_login"
names(IssueDataSpringBoot)[names(IssueDataSpringBoot) == "issue/author_association"] <- "issue_author_association"
names(IssueDataSpringBoot)[names(IssueDataSpringBoot) == "issue/closed_at"] <- "issue_closed_at"
names(IssueDataSpringBoot)[names(IssueDataSpringBoot) == "issue/updated_at"] <- "issue_updated_at"
names(IssueDataSpringBoot)[names(IssueDataSpringBoot) == "issue/created_at"] <- "issue_created_at"
names(IssueDataSpringBoot)[names(IssueDataSpringBoot) == "issue/comments"] <- "issue_comments"
names(IssueDataSpringBoot)[names(IssueDataSpringBoot) == "issue/state"] <- "issue_state"
names(IssueDataSpringBoot)[names(IssueDataSpringBoot) == "issue/user/login"] <- "issue_user_login"
names(IssueDataSpringBoot)[names(IssueDataSpringBoot) == "issue/title"] <- "issue_title"
names(IssueDataSpringBoot)[names(IssueDataSpringBoot) == "issue/number"] <- "issue_number"
names(IssueDataSpringBoot)[names(IssueDataSpringBoot) == "issue/id"] <- "issue_id"
names(IssueDataSpringBoot)[names(IssueDataSpringBoot) == "actor/id"] <- "actor_id"

library(car)
#VIF applied to SpringBoot self-assigned = True, all possible variables
vif(lmAllVariablesSelfAssignedSpringBoot)
lmAllVariablesSelfAssignedSpringBoot = lm(SelfAssigned~event+issue_id+issue_number+issue_state+contributions+Reassigned,IssueDataSpringBoot, singular.ok = FALSE)
summary(lmAllVariablesSelfAssignedSpringBoot)

#SpringBoot, self-assigned = True, reduced variables
vif(lmAllVariablesSelfAssignedSpringBoot)
lmAllVariablesSelfAssignedGuava = lm(SelfAssigned~event+issue_state+contributions+Reassigned,IssueDataGuava, singular.ok = FALSE)
summary(lmAllVariablesSelfAssignedGuava)

#VIF applied to SpringBoot self-assigned = False, all possible variables
vif(lmAllVariablesNotSelfAssignedSpringBoot)
lmAllVariablesNotSelfAssignedGuava = lm(SelfAssigned==FALSE~event+issue_id+issue_number+issue_state+contributions+Reassigned,IssueDataGuava, singular.ok = FALSE)
summary(lmAllVariablesNotSelfAssignedGuava)

#SpringBoot, self-Assigned = False, reduced variables
vif(lmAllVariablesNotSelfAssignedSpringBoot)
lmAllVariablesNotSelfAssignedSpringBoot = lm(SelfAssigned==FALSE~event+issue_state+contributions+Reassigned,IssueDataSpringBoot, singular.ok = FALSE)
summary(lmAllVariablesNotSelfAssignedSpringBoot)

#VIF applied to Guava self-Assigned = True, all possible variables
vif(lmAllVariablesSelfAssignedGuava)
lmAllVariablesSelfAssignedGuava = lm(SelfAssigned~event+issue_id+issue_number+issue_state+contributions+Reassigned+!Reassigned,IssueDataGuava, singular.ok = FALSE)
summary(lmAllVariablesSelfAssignedGuava)

#Guava, self-assigned = True, reduced variables
vif(lmAllVariablesSelfAssignedGuava)
lmAllVariablesSelfAssignedGuava = lm(SelfAssigned~event+issue_state+contributions+Reassigned,IssueDataGuava, singular.ok = FALSE)
summary(lmAllVariablesSelfAssignedGuava)

#VIF applied to Guava self-assigned = False, all possible variables
vif(lmAllVariablesNotSelfAssignedGuava)
lmAllVariablesNotSelfAssignedGuava = lm(SelfAssigned==FALSE~event+issue_id+issue_number+issue_state+contributions+Reassigned,IssueDataGuava, singular.ok = FALSE)
summary(lmAllVariablesNotSelfAssignedGuava)

#Guava, self-assigned = False, reduced variables
vif(lmAllVariablesNotSelfAssignedGuava)
lmAllVariablesNotSelfAssignedGuava = lm(SelfAssigned==FALSE~event+issue_state+contributions+Reassigned,IssueDataGuava, singular.ok = FALSE)
summary(lmAllVariablesNotSelfAssignedGuava)
