<script>
//Test Urls
//'https://api.github.com/repos/grpc/grpc/issues/events?type=IssuesEvent&page=1';
//'https://api.github.com/repos/dotnet/netcorecli-fsc/issues/events?type=IssuesEvent&page=1&per_page=100';

//SpringBoot Urls
//'https://api.github.com/repos/spring-projects/spring-boot/issues/events?type=IssuesEvent&page=1&per_page=100'
//'https://api.github.com/repos/spring-projects/spring-boot/contributors?page=1';

var gitHubUrl = 'https://api.github.com/repos/google/guava/issues/events?type=IssuesEvent&page=1&per_page=100'
var contribUrl = 'https://api.github.com/repos/google/guava/contributors?page=1';
var userUrl = 'https://api.github.com/users/';
var token = "";
var firstRunIssue = true;

var issues =[];
var contributors = [];

var ajsponseIssues;
var ajsponseContributors;
var ajsponseUserDetails;
var count = 0;

buildIssueList = function(url) {
    ajsponseIssues = $.ajax({
        dataType: "json",
        type: 'GET',
        headers: {
            "Authorization" : "Bearer " + token
        },
        url: url,
          success: function(data){
              $.merge(issues, data);
              var link = ajsponseIssues.getResponseHeader("Link");
              console.log(count);
              if (link.indexOf("next") !== -1) {
                    if(firstRunIssue){
                        gitHubUrl=link.substring(link.indexOf("<") + 1,link.indexOf(">"));
                        firstRunIssue = false;
                        buildIssueList(gitHubUrl);
                        count++;
                    } else {
                        gitHubUrl = link.substring(link.indexOf(",")+3  ,link.indexOf('rel="next"')-3);
                        buildIssueList(gitHubUrl);
                        count++;
                    }
              }
              else{
                  saveTextAsFile(issues, "IssueDataGuava");
              }
          }
        })
}

getUserDetail = function(user) {
    ajsponseUserDetails = $.ajax({
        dataType: "json",
        type: 'GET',
        headers: {
            "Authorization" : "Bearer " + token
        },
        url: userUrl + user ,
          success: function(data){
            userList = userList.concat(data);
        }
    })
}

buildContributorsList = function(url) {
    ajsponseContributors = $.ajax({
        dataType: "json",
        type: 'GET',
        headers: {
            "Authorization" : "Bearer " + token
        },
        url: url,
          success: function(data){
              $.merge(contributors, data);
                saveTextAsFile(contributors, "ContributorDataGuava");
          }
        })
}

function saveTextAsFile(toSave, fileName) 
{
    var json = toSave;
    var fields = Object.keys(json[0]);
    var replacer = function(key, value) { return value === null ? '' : value } ;
    var csv = json.map(function(row){
        return fields.map(function(fieldName){
        return JSON.stringify(row[fieldName], replacer)
    }).join(',')});
    csv.unshift(fields.join(',')); // add header column
    csv = csv.join('\r\n');
    var blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    //var bytes = new TextEncoder().encode(stringifiedJson);
    //var textFileAsBlob = new Blob([bytes], {type:'application/json;charset=utf-8'});
    //var textFileAsBlob = new Blob([stringifiedJson], {type:'application/json; charset=utf-8'});

    var downloadLink = document.createElement("a");
    downloadLink.download = fileName;
    downloadLink.innerHTML = "Download File";
    if (window.webkitURL != null)
    {
        // Chrome allows the link to be clicked
        // without actually adding it to the DOM.
        downloadLink.href = window.webkitURL.createObjectURL(blob);
    }
    else
    {
        // Firefox requires the link to be added to the DOM
        // before it can be clicked.
        downloadLink.href = window.URL.createObjectURL(blob);
        downloadLink.onclick = destroyClickedElement;
        downloadLink.style.display = "none";
        document.body.appendChild(downloadLink);
    }

    downloadLink.click();
}

</script>