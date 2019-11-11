import base64
import json
import sys
import urllib
import urllib2

import creds

URL = "https://api.bintray.com/orgs/bouncerpaid/access_keys"

def main():
    if len(sys.argv) != 2:
        print("Usage {}: new_key".format(sys.argv[0]))
        sys.exit(0)

    key = sys.argv[1]
    base64string = base64.b64encode('%s:%s' % (creds.user, creds.apikey))
    headers = {"Authorization": "Basic %s" % base64string,
               "Content-Type": "application/json"}
    #data = urllib.urlencode({'id' : key})
    data = json.dumps({'id': key})
    request = urllib2.Request(URL, data, headers)
    response = urllib2.urlopen(request, timeout=60)

    result = json.loads(response.read())
    print(result)

if __name__ == '__main__':
    main()
