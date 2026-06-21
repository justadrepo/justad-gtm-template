___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_justad_pixel",
  "version": 1,
  "securityGroups": [],
  "displayName": "JustAd Pixel",
  "categories": ["ADVERTISING", "REMARKETING", "CONVERSIONS"],
  "brand": {
    "id": "brand_justad",
    "displayName": "JustAd"
  },
  "description": "Loads the JustAd Pixel SDK and initializes the global justad() command queue. Provide your Advertiser ID to start tracking with JustAd.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "advertiserId",
    "displayName": "Advertiser ID",
    "simpleValueType": true,
    "help": "Your JustAd Advertiser ID. This value is passed to the SDK as the \u003ccode\u003ea\u003c/code\u003e query parameter (https://sdk.just.ad/a.js?a=\u003cb\u003eAdvertiser ID\u003c/b\u003e).",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const createArgumentsQueue = require('createArgumentsQueue');
const injectScript = require('injectScript');
const encodeUriComponent = require('encodeUriComponent');
const log = require('logToConsole');

const advertiserId = data.advertiserId;

// Recreate the inline stub:
//   window.justad = window.justad || function () {
//     (window.justad.q = window.justad.q || []).push(arguments);
//   };
// createArgumentsQueue defines window.justad (if not already present) so that
// calling it pushes its arguments onto the window.justad.q queue.
createArgumentsQueue('justad', 'justad.q');

// Recreate the async SDK loader:
//   <script async src="https://sdk.just.ad/a.js?a={{Advertiser_id}}"></script>
const url = 'https://sdk.just.ad/a.js?a=' + encodeUriComponent(advertiserId);

injectScript(url, () => {
  data.gtmOnSuccess();
}, () => {
  log('JustAd Pixel: failed to load the SDK from ' + url);
  data.gtmOnFailure();
}, url);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "justad"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "justad.q"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://sdk.just.ad/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Injects the SDK with the encoded Advertiser ID
  code: |-
    const mockData = {
      advertiserId: 'ADV-123'
    };

    let injectedUrl;
    mock('injectScript', (url, onSuccess, onFailure, cacheToken) => {
      injectedUrl = url;
      onSuccess();
    });

    runCode(mockData);

    assertThat(injectedUrl).isEqualTo('https://sdk.just.ad/a.js?a=ADV-123');
    assertApi('gtmOnSuccess').wasCalled();
    assertApi('gtmOnFailure').wasNotCalled();
- name: Creates the justad arguments queue
  code: |-
    const mockData = {
      advertiserId: 'ADV-123'
    };

    let queueFnKey;
    let queueArrayKey;
    mock('createArgumentsQueue', (fnKey, arrayKey) => {
      queueFnKey = fnKey;
      queueArrayKey = arrayKey;
      return () => {};
    });
    mock('injectScript', (url, onSuccess) => {
      onSuccess();
    });

    runCode(mockData);

    assertThat(queueFnKey).isEqualTo('justad');
    assertThat(queueArrayKey).isEqualTo('justad.q');
- name: Calls gtmOnFailure when the SDK fails to load
  code: |-
    const mockData = {
      advertiserId: 'ADV-123'
    };

    mock('injectScript', (url, onSuccess, onFailure) => {
      onFailure();
    });

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();
    assertApi('gtmOnSuccess').wasNotCalled();
- name: URL-encodes special characters in the Advertiser ID
  code: |-
    const mockData = {
      advertiserId: 'a b&c'
    };

    let injectedUrl;
    mock('injectScript', (url, onSuccess) => {
      injectedUrl = url;
      onSuccess();
    });

    runCode(mockData);

    assertThat(injectedUrl).isEqualTo('https://sdk.just.ad/a.js?a=a%20b%26c');


___NOTES___

Created on 6/21/2026, 9:13:00 PM
