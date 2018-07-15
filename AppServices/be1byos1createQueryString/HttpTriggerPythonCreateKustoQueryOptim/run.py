import os
import json

alldata = json.loads(open(os.environ['req']).read())
data = alldata['entities']

FULL_QUERY_MAKE = True
NUM_DAYS = alldata['userParam1']
MAX_RESOURCES = alldata['userParam2']


queryStr1 = """event 
| where event_Name == "PBI.Visual.ApiUsage"
| where device_OSVersion !has "GomezAgent" and device_OSVersion !has "Googlebot" 
| where (app_Name != "pbi_web_preprod" and app_Name != "pbi_addin_preprod" and app_Name != "pbi_mobile_preprod" and app_Name != "pbi_web_dev" and app_Name != "pbi_mobile_dev") 
| where timestamp < startofday(ago(0d)) """

queryStr2 =  "| where timestamp > endofday(ago(" + str(NUM_DAYS) + 'd))'


queryStr5 = """| where tostring(customDimensions["custom"]) == "true"
| extend customProperties = parsejson(customDimensions) 
| extend Cluster = tolower(tostring(customProperties.cluster)) 
| extend VisualName = tostring(customProperties.name) """



queryStr8 = """| where (Cluster != "https://df-mevent | sit-scus.analysis.windows.net" and Cluster != "https://df-msit-scus-redirect.analysis.windows.net" and Cluster != "https://df-msit-scus.analysis.windows.net/") 
 | extend SessionSource = tostring(customProperties.sessionSource) 
 | where SessionSource != "Embed" | extend UserId = tostring(customProperties.userId) 
 | extend TenantId = tostring(customProperties.tenantId) 
 | extend VisualVersion = tostring(customProperties.visualVersion) 
 | extend ApiVersion = tostring(customProperties.apiVersion) 
 | extend ClusterName = tostring(customProperties.cluster) 
 | extend SessionId = tostring(customProperties.sessionId) 
 | extend BuildNumber = tostring(iif(isnull(customProperties.build), customProperties.buildNumber, customProperties.build)) 
| extend isCustom = tostring(customProperties.custom)
| extend Cluster = tolower(tostring(customProperties.cluster)) 
 | where (Cluster != "https://df-mevent | sit-scus.analysis.windows.net" and Cluster != "https://df-msit-scus-redirect.analysis.windows.net" and Cluster != "https://df-msit-scus.analysis.windows.net/") 
 | extend SessionSource = tostring(customProperties.sessionSource) 
 | where SessionSource != "Embed" | extend UserId = tostring(customProperties.userId) 
 | extend TenantId = tostring(customProperties.tenantId) 
 | extend VisualVersion = tostring(customProperties.visualVersion) 
 | extend ApiVersion = tostring(customProperties.apiVersion) 
 | extend ClusterName = tostring(customProperties.cluster) 
 | extend SessionId = tostring(customProperties.sessionId) 
 | extend BuildNumber = tostring(iif(isnull(customProperties.build), customProperties.buildNumber, customProperties.build)) 
 | summarize userCount = dcount(UserId), tenantCount = dcount(TenantId), sessionCount = dcount(SessionId) by bin(timestamp, 1d), app_Name, VisualName, VisualVersion, ApiVersion, BuildNumber, location_City, location_StateOrProvince, location_Country
 | extend app_Name = iff(app_Name == "pbi_addin_dev", "Power BI Desktop", app_Name) 
| extend app_Name = iff(app_Name == "pbi_web_prod", "Power BI web", app_Name) 
| extend app_Name = iff(app_Name == "Power BI Ship (iOS) - iOS", "Power BI Mobile - iOS", app_Name) 
| extend app_Name = iff(app_Name == "Power BI Ship (Android) - Android", "Power BI Mobile - Android", app_Name)
| extend app_Name = iff(app_Name == "Power BI Ship (Windows) - Windows", "Power BI Mobile - Windows", app_Name) 
| extend app_Name = iff(app_Name == "Power BI Ship (WP) - Windows Phone", "Power BI Mobile - Windows Phone", app_Name)"""


#where (VisualName == ""RHTML_FUNNEL_978302916642"" or VisualName == ""PBI_CV_9D783E0D_2610_4C22_9576_88AD092AB59E"")
myStr = myStr2 = myStr3 = conct = ""
countInd = 0



for d in data:
    if(countInd):
        conct = " or "
    myStr = myStr + conct + 'VisualName == "' + d['GUID'] + '"'
    myStr2 = myStr2 + conct + 'customDimensions has  "' + d['GUID'] + '"'
    myStr3 = myStr3 + ' | extend VisualName = iff(VisualName == "' +  d['GUID'] + '", "' + d['DisplayName'] + '", VisualName)'
    countInd = countInd + 1
    if (countInd == MAX_RESOURCES) :
        break

myStr = ' | where (' + myStr + ')'
myStr2 = ' | where (' + myStr2 + ')'



if(FULL_QUERY_MAKE):
    myStr = queryStr1 + queryStr2  + myStr2 + queryStr5  + myStr + myStr3  + queryStr8



response = open(os.environ['res'], 'w')
response.write(myStr)
response.close()