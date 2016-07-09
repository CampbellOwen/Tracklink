import urllib.request
import webbrowser
import json
import time

lattitude = 49.371062
longitude = -123.270967

#lattitude = 49.145099
#longitude = -122.812058

API_KEY = "QUprTm0ALxtTt4npEjl6"

radius = 2000

longdiff = 0.015060*2
latdiff = 0.008983*2

def createURL(API_KEY, lattitude, longitude, radius):
    return "http://api.translink.ca/rttiapi/v1/stops?apikey=" + API_KEY + "&lat=" + str(lattitude) + "&long=" + str(longitude) + "&radius=" + str(radius)

def savefile(API_KEY, lattitude, longitude, radius):
    url = createURL(API_KEY, lattitude, longitude, radius)
    req = urllib.request.Request(url, headers={"Accept": "application/JSON"})
    jsonret = urllib.request.urlopen(req).read().decode("utf-8")
    jsonobj = json.loads(jsonret)
    file = open(str(lattitude) + "_" + str(longitude) + ".output", 'w')
    file.write(json.dumps(jsonobj, indent=4))
    file.close()

t = 0
for i in range(30):
    for j in range(20):
        t = t+1
        print(str(t)+": "+createURL(API_KEY,round(lattitude - (i*latdiff), 6),round(longitude+(j*longdiff), 6), radius), end=" ")
        time.sleep(1.5)
        try:
            savefile(API_KEY, round(lattitude - (i*latdiff), 6), round(longitude+(j*longdiff), 6), radius)
        except urllib.error.HTTPError as e:
                print("\n\t" + str(e.code), end="")

        print("")
