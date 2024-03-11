*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Keywords ***
Safety Sleep
  Sleep     1s 

Open Add Item Tab
  Safety Sleep
  Click Element    xpath://a[contains(@href,'add-item')]

Open Todo Tab
  Safety Sleep
  Click Element    xpath://a[contains(@href,'todo')]

Open Complete Tab
  Safety Sleep
  Click Element    xpath://a[contains(@href,'completed')]

Add Item
  [Arguments]    ${item}    ${todo_list}
  Input Text    id:new-task    ${item}
  Click Element    xpath://div[@id='add-item']//button
  Append To List    ${todo_list}    ${item}

Bulk Add Item
    [Arguments]    ${itemName}    ${itemLength}     ${todo_list}
    ${itemLength}=    Convert To Integer    ${itemLength}
    Open Add Item Tab
    FOR    ${index}    IN RANGE    1    ${itemLength + 1}
      Add Item    ${itemName}${index}    ${todo_list}
    END

Complete Item
  [Arguments]    ${itemIndex}    ${todo_list}    ${complete_list}
    ${itemIndex}=    Convert To Integer    ${itemIndex}
    Click Element    xpath://label[@for='${itemIndex + 1}']
    Append To List    ${complete_list}    ${todo_list[${itemIndex}]}
    Remove From List    ${todo_list}    ${itemIndex}

Delete Item From Complete
  [Arguments]    ${itemIndex}    ${complete_list} 
  ${itemIndex}=    Convert To Integer    ${itemIndex}
  Click Element    xpath://ul[@id="completed-tasks"]/li/button[@id="${itemIndex + 1}"]
  Remove From List    ${complete_list}    ${itemIndex}

Delete Item From Todo List
  [Arguments]    ${itemIndex}    ${todo_list}
  ${itemIndex}=    Convert To Integer    ${itemIndex}
  Click Element    xpath://ul[@id="incomplete-tasks"]/li/button[@id='${itemIndex + 1}']
  Remove From List    ${todo_list}    ${itemIndex}

Check Length Of Todo List
  [Arguments]    ${expectedLen}
  @{incomplate_li_elem}=    Get WebElements    xpath=//ul[@id='incomplete-tasks']/li
  Length Should Be     ${incomplate_li_elem}    ${expectedLen}

Check Length Of Complete List
  [Arguments]    ${expectedLen}
  @{complate_li_elem}=    Get WebElements    xpath=//ul[@id='completed-tasks']/li
  Length Should Be     ${complate_li_elem}    ${expectedLen}

Check ToDo In List Match With Website
  [Arguments]    ${todo_list}
  Open Todo Tab
  FOR    ${index}    IN RANGE    0    ${todo_list.__len__()}
    Element Text Should Be     xpath://span[@id='text-${index+1}']     ${todo_list[${index}]}
  END

Check Complete In List Match With Website
  [Arguments]    ${complete_list}
  Open Complete Tab
    @{span_elements}=    Get WebElements    xpath=//ul[@id='completed-tasks']/li/span
    FOR    ${index}    IN RANGE    0    ${span_elements.__len__()}  
        Element Should Contain    ${span_elements[${index}]}    ${complete_list[${index}]}
    END