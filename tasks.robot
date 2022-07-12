*** Settings ***
Documentation       Template robot main suite.

Library             DateTime
Library             FakerLibrary
Library             RPA.Robocorp.Vault
Library             Collections


*** Tasks ***
Minimal task
    ${currentPass}=    Get Current Password
    ${newPass}=    Create password
    #Change my password
    Store my password    ${currentPass}    ${newPass}
    Log    Done.


*** Keywords ***
Get Current Password
    [Documentation]    connect to Control Room Vault and loads the myURL secret
    ...    items to change for your environment
    ...    myURL = change to the secret name stored in your Vault

    ${secret}=    Get Secret    myURL
    RETURN    ${secret}

Create password
    [Documentation]    uses FakerLibrary to generate a new random password
    ...    if you do not need special characters, upper, lower, etc set those to False

    ${myPass}=    Password    length=10    special_chars=True    digits=True    upper_case=True    lower_case=True
    RETURN    ${myPass}

Change my password
    [Documentation]    Use this section to create the code
    ...    for logging into the site and changing the password
    [Arguments]    ${currentPass}    ${newPass}

Store my password
    [Documentation]    sets the password key to the new password generated then saves it back to Vault
    ...    the ${level} portion is used so the Robocorp Logs do not store your password
    ...    password = change to the key that stores your password
    [Arguments]    ${secret}    ${newSecret}

    ${level}=    Set Log Level    NONE
    Set To Dictionary    ${secret}    password    ${newSecret}
    Set Log Level    ${level}
    Set Secret    ${secret}
