___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "DD ConsentManager.net Consent State (Unofficial)",
  "categories": [
    "TAG_MANAGEMENT"
  ],
  "description": "Use with the ConsentManager.net CMP to identify the individual website user\u0027s consent state and configure when tags should execute.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "consentmanagernetConsentStateCheckType",
    "displayName": "Select Consent State Check Type",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "consentmanagernetAllConsentState",
        "displayValue": "All Consent State Check"
      },
      {
        "value": "consentmanagernetSpecificConsentState",
        "displayValue": "Specific Consent State"
      }
    ],
    "simpleValueType": true,
    "help": "Select the type of consent state check you want to perform—either a specific consent category or all consent categories, available in your ConsentManager.net Consent Banner."
  },
  {
    "type": "TEXT",
    "name": "consentmanagernetConsentCategoryCheck",
    "displayName": "Insert The ConsentManager.Net Category Name",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "consentmanagernetConsentStateCheckType",
        "paramValue": "consentmanagernetSpecificConsentState",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "Since consent category names can vary across ConsentManager.net banners, specify the category name here.",
    "valueHint": "e.g., Measurement"
  },
  {
    "type": "TEXT",
    "name": "consentmanagernetPurposeId",
    "displayName": "Enter Purpose ID Number",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "valueHint": "e.g., c1",
    "help": "Here is where you enter the purpose ID number that relates to the consent category",
    "enablingConditions": [
      {
        "paramName": "consentmanagernetConsentStateCheckType",
        "paramValue": "consentmanagernetSpecificConsentState",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "consentmanagernetEnableOptionalConfig",
    "checkboxText": "Enable Optional Output Transformation",
    "simpleValueType": true
  },
  {
    "type": "GROUP",
    "name": "consentmanagernetOptionalConfig",
    "displayName": "ConsentManager.net Consent State Value Transformation",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SELECT",
        "name": "consentmanagernetTrue",
        "displayName": "Transform \"True\"",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "consentmanagernetTrueGranted",
            "displayValue": "granted"
          },
          {
            "value": "consentmanagernetTrueAccept",
            "displayValue": "accept"
          }
        ],
        "simpleValueType": true
      },
      {
        "type": "SELECT",
        "name": "consentmanagernetFalse",
        "displayName": "Transform \"False\"",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "consentmanagernetFalseDenied",
            "displayValue": "denied"
          },
          {
            "value": "consentmanagernetFalseDeny",
            "displayValue": "deny"
          }
        ],
        "simpleValueType": true
      },
      {
        "type": "CHECKBOX",
        "name": "consentmanagernetUndefined",
        "checkboxText": "Also transform \"undefined\" to \"denied\"",
        "simpleValueType": true
      }
    ],
    "enablingConditions": [
      {
        "paramName": "consentmanagernetEnableOptionalConfig",
        "paramValue": true,
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "consentmanagernet",
    "checkboxText": "Include Consent Category Name with Purpose ID",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "consentmanagernetConsentStateCheckType",
        "paramValue": "consentmanagernetAllConsentState",
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const callInWindow = require('callInWindow');
const getType = require('getType');

const checkType = data.consentmanagernetConsentStateCheckType;
const customPurposeId = data.consentmanagernetPurposeId;
const customCategoryName = data.consentmanagernetConsentCategoryCheck;
const includeCategory = data.consentmanagernet;

const enableTransform = data.consentmanagernetEnableOptionalConfig;
const transformTrue = data.consentmanagernetTrue;
const transformFalse = data.consentmanagernetFalse;
const transformUndefined = data.consentmanagernetUndefined;

function transformValue(val) {
  if (getType(val) === 'undefined' && transformUndefined) val = false;
  if (!enableTransform) return val;

  if (val === true) {
    return transformTrue === 'consentmanagernetTrueGranted' ? 'granted' : 'accept';
  }
  if (val === false) {
    return transformFalse === 'consentmanagernetFalseDenied' ? 'denied' : 'deny';
  }
  return val;
}

function getCMPData() {
  const cmpData = callInWindow('__cmp', 'getCMPData');
  if (getType(cmpData) !== 'object') return undefined;
  const purposesList = cmpData.purposesList;
  const purposeConsents = cmpData.purposeConsents;
  if (getType(purposesList) !== 'array' || getType(purposeConsents) !== 'object') return undefined;
  return {
    purposesList: purposesList,
    purposeConsents: purposeConsents
  };
}

function getAllConsentStates() {
  const cmp = getCMPData();
  if (!cmp) return undefined;
  const purposesList = cmp.purposesList;
  const purposeConsents = cmp.purposeConsents;

  const result = {};
  for (let i = 0; i < purposesList.length; i++) {
    const entry = purposesList[i];
    const pid = entry.id;
    const cname = entry.name;
    let state = getType(purposeConsents[pid]) !== 'undefined' ? purposeConsents[pid] : false;
    const value = transformValue(state);
    result[pid] = includeCategory ? { category: cname, consent: value } : value;
  }
  return result;
}

function getSpecificConsentState() {
  const cmp = getCMPData();
  if (!cmp) return undefined;
  const purposesList = cmp.purposesList;
  const purposeConsents = cmp.purposeConsents;

  const purposeId = customPurposeId;
  const match = purposesList.filter(function(p) { return p.id === purposeId; });
  if (match.length === 0) return undefined;

  let value = getType(purposeConsents[purposeId]) !== 'undefined' ? purposeConsents[purposeId] : false;
  return transformValue(value);
}

if (checkType === 'consentmanagernetAllConsentState') {
  return getAllConsentStates();
}

if (checkType === 'consentmanagernetSpecificConsentState') {
  return getSpecificConsentState();
}

return undefined;


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
                    "string": "__cmp"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
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
                    "string": "__cmpData"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
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
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 5/20/2025, 9:47:26 AM


