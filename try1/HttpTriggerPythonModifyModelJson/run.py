import os
import json
import string

data = json.loads(open(os.environ['req']).read())
response = open(os.environ['res'], 'w')

theData = data['theData']

oldContainer = data['oldContainer']
trueName = data['trueName']
trueContainer = data['trueContainer']

data = theData

data['name'] = trueName
ents = data['entities']

locString = ents[0]['partitions'][0]['location']
locString = locString.replace(oldContainer,trueContainer)
ents[0]['partitions'][0]['location'] = locString
data['entities']= ents



json.dump(data, response)
response.close()