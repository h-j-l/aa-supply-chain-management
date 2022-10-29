*** Settings ***
Documentation       Automation Anywhere Labs - Supply Chain Management

Library             RPA.Browser.Selenium
Library             RPA.Excel.Files
Library             RPA.FileSystem
Library             RPA.HTTP
Library             RPA.Tables
Library             String


*** Variables ***
${BUTTON_DOWNLOAD_EXCEL}            css:div[class="challenge-intro"] > div > a[class="btn"]
${EXCEL_FILE}                       ${OUTPUT_DIR}${/}StateAssignments.xlsx
${CHALLENGE_URL}
...                                 https://developer.automationanywhere.com/challenges/automationanywherelabs-supplychainmanagement.html
${CHALLENGE_ALIAS}                  BrowserC
${PROCUREMENT_ANYWHERE_URL}
...                                 https://developer.automationanywhere.com/challenges/AutomationAnywhereLabs-POTrackingLogin.html
${PROCUREMENT_ANYWHERE_ALIAS}       BrowserPA
${PA_USERNAME}                      admin@procurementanywhere.com
${PA_PASSWORD}                      paypacksh!p
${SCORE}                            ${OUTPUT_DIR}${/}score.txt
${SCORE_SCREENSHOT}                 ${OUTPUT_DIR}${/}score.png


*** Tasks ***
Do the challenge
    Open the challenge page
    Download the Excel file
    Open Procurement Anywhere
    Sign in to Procurement Anywhere
    Process PO Numbers
    Submit form
    Read and save the score
    Log out from Procurement Anywhere
    [Teardown]    End challenge


*** Keywords ***
Open the challenge page
    ${test}=    Open Available Browser    ${CHALLENGE_URL}    alias=${CHALLENGE_ALIAS}    maximized=True

Download the Excel file
    Switch Browser    ${CHALLENGE_ALIAS}
    Wait Until Page Contains Element    ${BUTTON_DOWNLOAD_EXCEL}
    ${excel_url}=    Get Element Attribute    ${BUTTON_DOWNLOAD_EXCEL}    attribute=href
    Download    ${excel_url}    target_file=${EXCEL_FILE}    overwrite=True

Read PO Number from the challenge page with given ID
    [Arguments]    ${id}
    Switch Browser    ${CHALLENGE_ALIAS}
    ${poNumber}=    Get Value    id:PONumber${id}
    RETURN    ${poNumber}

Open Procurement Anywhere
    Open Available Browser    ${PROCUREMENT_ANYWHERE_URL}    alias=${PROCUREMENT_ANYWHERE_ALIAS}    maximized=True

Sign in to Procurement Anywhere
    Switch Browser    ${PROCUREMENT_ANYWHERE_ALIAS}
    Close cookie popup
    Execute Javascript
    ...    document.querySelector("input[id='inputEmail']").value = "${PA_USERNAME}";
    ...    document.querySelector("input[id='inputPassword']").value = "${PA_PASSWORD}";
    ...    document.querySelector("button[class='btn btn-lg btn-primary btn-block text-uppercase']").click();
    Wait Until Page Contains Element    id:dtBasicExample_filter

Close cookie popup
    ${accept_all_cookies_button}=    Set Variable    id:onetrust-accept-btn-handler
    Switch Browser    ${PROCUREMENT_ANYWHERE_ALIAS}
    TRY
        Wait Until Page Contains Element    ${accept_all_cookies_button}
        Execute Javascript    document.querySelector("button[id='onetrust-accept-btn-handler']").click();
        Wait Until Element Is Not Visible    ${accept_all_cookies_button}
    EXCEPT
        Log    Failed to close cookie popup.
    END

Process PO Numbers
    ${current_id}=
    ...    Set Variable    ${1}
    ${last_id}=
    ...    Set Variable    ${7}
    Open Workbook    ${EXCEL_FILE}    read_only=True
    ${stateAssignments}=    Read Worksheet As Table    header=True
    Close Workbook
    Switch Browser    ${CHALLENGE_ALIAS}
    # The page is reloaded to reset the timer.
    Reload Page
    WHILE    ${current_id} <= ${last_id}
        ${poNumber}=    Read PO Number from the challenge page with given ID    ${current_id}
        Search for PO Number in Procurement Anywhere    ${poNumber}
        ${details}=    Read PO Number's details from Procurement Anywhere
        ${agentRow}=    Find Table Rows    ${stateAssignments}    State    ==    ${details}[0]
        ${assignedAgent}=    RPA.Tables.Get Table Cell
        ...    table=${agentRow}
        ...    row=0
        ...    column=Full Name
        Input data for one PO Number    ${current_id}    ${details}[1]    ${details}[2]    ${assignedAgent}
        ${current_id}=    Set Variable    ${current_id + 1}
    END

Search for PO Number in Procurement Anywhere
    [Arguments]    ${po_number}
    ${search_field}=    Set Variable    css:div[id="dtBasicExample_filter"] > label > input[type="search"]
    Switch Browser    ${PROCUREMENT_ANYWHERE_ALIAS}
    Wait Until Page Contains Element    ${search_field}
    Input Text    ${search_field}    ${po_number}    clear=True

Read PO Number's details from Procurement Anywhere
    Switch Browser    ${PROCUREMENT_ANYWHERE_ALIAS}
    Wait Until Page Contains Element    id:dtBasicExample
    ${state}=    RPA.Browser.Selenium.Get Table Cell    id:dtBasicExample    2    5
    ${shipDate}=    RPA.Browser.Selenium.Get Table Cell    id:dtBasicExample    2    7
    ${orderTotal}=    RPA.Browser.Selenium.Get Table Cell    id:dtBasicExample    2    8
    ${orderTotal}=    Replace String    ${orderTotal}    $    ${EMPTY}
    @{details}=    Set Variable    ${state}    ${shipDate}    ${orderTotal}
    RETURN    @{details}

Input data for one PO Number
    [Arguments]
    ...    ${id}
    ...    ${shipDate}
    ...    ${orderTotal}
    ...    ${assignedAgent}
    Switch Browser    ${CHALLENGE_ALIAS}
    Execute Javascript
    ...    document.querySelector("input[id='shipDate${id}']").value = "${shipDate}";
    ...    document.querySelector("input[id='orderTotal${id}']").value = "${orderTotal}";
    ...    document.querySelector("select[id='agent${id}']").value = "${assignedAgent}";

Read and save the score
    Switch Browser    ${CHALLENGE_ALIAS}
    Wait Until Page Contains Element    id:processing-time
    ${time}=    Get Text    id:processing-time
    ${accuracy}=    Get Text    id:accuracy
    Create File    ${SCORE}    overwrite=True    content=Time: ${time}${\n}Accuracy: ${accuracy}
    Screenshot    class:modal-body    ${SCORE_SCREENSHOT}

Log out from Procurement Anywhere
    Switch Browser    ${PROCUREMENT_ANYWHERE_ALIAS}
    Execute Javascript
    ...    document.querySelector("span[class='signed_in_user'] a").click();
    Wait Until Page Contains Element    id:inputEmail
    Close Browser

Submit form
    Switch Browser    ${CHALLENGE_ALIAS}
    Execute Javascript
    ...    document.querySelector("button[id='submitbutton']").click();

End challenge
    Switch Browser    ${CHALLENGE_ALIAS}
    Close Browser
