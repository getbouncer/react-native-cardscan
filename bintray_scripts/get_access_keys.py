import base64
import json
import sys
import urllib
import urllib2

import creds

URL = "https://api.bintray.com/orgs/bouncerpaid/access_keys"

def main():
    base64string = base64.b64encode('%s:%s' % (creds.user, creds.apikey))
    request = urllib2.Request(URL)
    request.add_header("Authorization", "Basic %s" % base64string)
    response = urllib2.urlopen(request, timeout=60)

    result = json.loads(response.read())
    for access_key in result['access_keys']:
        request = urllib2.Request(URL + '/{}'.format(access_key))
        request.add_header("Authorization", "Basic %s" % base64string)
        response = urllib2.urlopen(request, timeout=60)
        
        print(response.read())
        #result = json.load(response.read())
        #print(json.dumps(result, indent=4))

if __name__ == '__main__':
    main()
