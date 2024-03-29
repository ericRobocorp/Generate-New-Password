*** Settings ***
Documentation
...                 This robot uses the provided work item to select a site secret
...                 and then log into that site and set a new password. The website
...                 implementation is not complete and should be done by the user of
...                 this template.

Library             FakerLibrary
Library             RPA.Robocorp.Vault
Library             Collections
Library             RPA.Robocorp.WorkItems


*** Tasks ***
Change site password
    ${password_options}=    Get work item variables
    ${current_pass}=    Get current password    ${password_options}[site_secret]
    ${new_pass}=    Create password
    ...    ${password_options}[length]
    ...    ${password_options}[special_chars]
    ...    ${password_options}[digits]
    ...    ${password_options}[upper_case]
    ...    ${password_options}[lower_case]
    Change my password    ${password_options}[site_secret]    ${current_pass}    ${new_pass}
    Store my password    ${current_pass}    ${new_pass}
    Log    Done.


*** Keywords ***
Get current password
    [Documentation]
    ...    Using the work item variable ``site_secret``, this keyword pulls down the
    ...    associated secret from the Control Room Vault. Provide the name of the vault
    ...    item in that work item variable. The Vault item should have the password
    ...    stored in the value ``password``.
    [Arguments]    ${site_secret}

    ${secret}=    Get Secret    ${site_secret}
    RETURN    ${secret}

Create password
    [Documentation]
    ...    Uses FakerLibrary to generate a new random password of the provided
    ...    ``length`` (defaults to 10 characters long). if you do not need special
    ...    characters, upper, lower, etc set those to False
    [Arguments]    ${length}=10    ${special_chars}=${True}    ${digits}=${True}
    ...    ${upper_case}=${True}    ${lower_case}=${True}

    ${num_length}=    Convert to number    ${length}
    ${my_pass}=    Password
    ...    length=${num_length}
    ...    special_chars=${special_chars}
    ...    digits=${digits}
    ...    upper_case=${upper_case}
    ...    lower_case=${lower_case}
    RETURN    ${my_pass}

Change my password
    [Documentation]
    ...    Use this section to create the code
    ...    for logging into the site and changing the password
    [Arguments]    ${site_secret}    ${current_pass}    ${new_pass}
    # This keyword should be updated to perform the appropriate functions for the provided site.
    # It could be possible to create multiple keywords for different sites and then select them
    # based on the provided ``site_secret``, so this bot could be more versatile.
    ${site_credentials}=    Get secret    ${site_secret}
    Log    Navigating to ${site_secret} at url: ${site_credentials}[site_url]
    Log    Logging in with username ${site_credentials}[username] and password

Store my password
    [Documentation]
    ...    Sets the password key to the new password generated then saves it back to Vault
    ...    the ``level`` portion is used so the Robocorp Logs do not store your password
    ...    password = change to the key that stores your password
    [Arguments]    ${secret}    ${new_secret}

    ${level}=    Set Log Level    NONE
    Set To Dictionary    ${secret}    password    ${new_secret}
    Set Log Level    ${level}
    Set Secret    ${secret}
