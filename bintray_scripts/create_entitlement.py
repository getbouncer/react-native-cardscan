import base64
import json
import sys
import urllib
import urllib2

import creds

URL = "https://api.bintray.com/repos/bouncerpaid/react-native-cardscan/entitlements"

def main():
    if len(sys.argv) != 2:
        print('Usage {}: company'.format(sys.argv[0]))
        sys.exit(0)

    company = sys.argv[1]
    KEYS = ['{}@bouncerpaid'.format(company)]
    base64string = base64.b64encode('%s:%s' % (creds.user, creds.apikey))
    headers = {"Authorization": "Basic %s" % base64string,
               "Content-Type": "application/json"}
    data = json.dumps({
            "access": "r",
            "access_keys": [company]
            })
    request = urllib2.Request(URL, data, headers)
    response = urllib2.urlopen(request, timeout=60)

    result = json.loads(response.read())
    print(result)

if __name__ == '__main__':
    main()
