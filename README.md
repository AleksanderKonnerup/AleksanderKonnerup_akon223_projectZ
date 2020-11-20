# AleksanderKonnerup_akon223_projectZ
Aleksander Konnerup
Master of Engineering studies - Software Engineering
University of Auckland
Research Project Z

This repository contains
- .html file used to run the JavaScript data collection script, requires starting a local server on the machine running it, explained in detail in section 1.
- JavaScript file, only the script used to download data in .js format
- R studio script, used to manipulate data and apply Linear regression and VIF, explained in detail in section 2.
- The datasets downloaded from the GitHub API, both in .json format and in .xcl format

# Section 1 - Running the data collection Script
To run the data collection file it will need to be opened through a local server on your machine. The following steps details how to run it:
- Open the .html file using an IDE, i.e. visual studie code 
- First insert your own OAuth token in the code, this is due to GitHub not allowing the public sharing of OAuth tokens and it therefore can be shared in this repository, a tutorial on how to create one can be found on: https://docs.github.com/en/free-pro-team@latest/developers/apps/building-oauth-apps
- Now the GitHub Api call can be modified in the code depending on the desired data to download, the commented lines contain the springboot data and test data from smaller repositories.

- Next open a terminal window
- Navigate to the folder in which the .html file has been stored using the "cd" command
- Once standing in the folder type in "http-server -p 8080"
- Now navigate to localhost:8080 in either google chrome or firefox
- Doubleclick on the .html file and you should be able to interact with the web page
- Now click the buttons on the page to download the data pertaining to the chosen GitHub Api call

# Section 2 - The R studio Script
The R script can not directly be imported into R studio and run. It requires a small modification before it can be used:
- In the script where the datasets are imported, the current file-path points to my folder system and will not be applicable to other machines. Therefore, the filepath in the script needs to be changed to import the dataset files from the repository, the files should be imported in the following order, IssueDataSpringBootFormatted, ContributorDataSpringBootFormatted, IssueDataGuavaFormatted,ContributorDataGuavaFormatted. 
- Once that is done the script should be able to run, it may require the installation of some external libraries, i.e. library(car). R's command prompt should be able to guide in how to install these if needed.

