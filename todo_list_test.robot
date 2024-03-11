*** Settings ***
Library    SeleniumLibrary
Resource   keyword.resource

*** Variables ***
${URL}    https://abhigyank.github.io/To-Do-List/
${BROWSER}    Safari
@{todo_list}     # Empty List
@{complete_list}     # Empty List
${normal_number}    20
${large_number}    800

*** Test Cases ***
Open To-Do List Website
  Open Browser    ${URL}    browser=${BROWSER}
  Title Should Be     To-Do List
  
# check for normal case
Can Add Item To To-Do List
  # loop add item 
  Bulk Add Item    test    ${normal_number}    ${todo_list}
  Check Length Of Todo List    ${normal_number}
  Check Length Of Complete List    0

Data In To-Do List Display Correctly
  # check is data display collectly
  Open Todo Tab
  Check ToDo In List Match With Website     ${todo_list}

Can Complete All To-Do List
  FOR    ${index}    IN RANGE    0    ${todo_list.__len__()}
    Complete Item    0    ${todo_list}    ${complete_list}
  END
  Check Length Of Complete List    ${normal_number}
  Check Length Of Todo List    0 

Data In Complete List Display Correctly
    Open Complete Tab
    Check Complete In List Match With Website    ${complete_list}

Delete All Complete Item
    FOR    ${index}    IN RANGE    0    ${complete_list.__len__()}  
        Delete Item From Complete    0    ${complete_list}
    END

    Check Length Of Todo List    0
    Check Length Of Complete List    0
  
Delete Item From Incomplete Task
  Bulk Add Item    test    5    ${todo_list}
  Open Todo Tab

  FOR    ${index}    IN RANGE    0    ${todo_list.__len__()}
      Delete Item From Todo List    0    ${todo_list}
  END

  Check Length Of Todo List    0
  Check Length Of Complete List    0

Delete To-Do List In Middle
  Bulk Add Item    test    9    ${todo_list}
  Open Todo Tab
  ${selected_index}=    Convert To Integer    ${todo_list.__len__()/2}
  Delete Item From Todo List    ${selected_index}    ${todo_list}
  Check ToDo In List Match With Website     ${todo_list}

Complete To-Do List In Middle 
  ${selected_index}=    Convert To Integer    ${todo_list.__len__()/2}
  Complete Item    ${selected_index}    ${todo_list}    ${complete_list}
  ${selected_index}=    Convert To Integer    ${todo_list.__len__()/2}
  Complete Item    ${selected_index}    ${todo_list}    ${complete_list}
  ${selected_index}=    Convert To Integer    ${todo_list.__len__()/2}
  Complete Item    ${selected_index}    ${todo_list}    ${complete_list}

  Check ToDo In List Match With Website     ${todo_list}
  Check Complete In List Match With Website    ${complete_list}

Delete Complete List In Middle
  ${selected_index}=    Convert To Integer    ${complete_list.__len__()/2}
  Open Complete Tab
  Delete Item From Complete    ${selected_index}    ${complete_list}
  Check Complete In List Match With Website    ${complete_list}

Check Data After Refresh
    Reload Page
    Check ToDo In List Match With Website    ${todo_list}
    Check Complete In List Match With Website    ${complete_list}

Remove All Data
  Open Todo Tab
  FOR    ${index}    IN RANGE    0    ${todo_list.__len__()}
      Delete Item From Todo List    0    ${todo_list}
  END
  Open Complete Tab
  FOR    ${index}    IN RANGE    0    ${complete_list.__len__()}  
      Delete Item From Complete    0    ${complete_list}
  END
  Check Length Of Todo List    0
  Check Length Of Complete List    0

# check large data case 
Can Add Large Item List To To-Do List
  Bulk Add Item    test    ${large_number}    ${todo_list}
  Check Length Of Todo List    ${large_number}
  Check Length Of Complete List    0
  Check ToDo In List Match With Website    ${todo_list}
  Check Complete In List Match With Website    ${complete_list}

Complete Large To-Do List To Complete List
  Open Todo Tab
  FOR    ${index}    IN RANGE    0    ${todo_list.__len__()}
    Complete Item    0    ${todo_list}    ${complete_list}
  END
  Check Length Of Complete List    ${large_number}
  Check Length Of Todo List    0
  Check Complete In List Match With Website    ${complete_list}

Delete All Complete List 
  Open Complete Tab
  FOR    ${index}    IN RANGE    0    ${complete_list.__len__()}  
      Delete Item From Complete    0    ${complete_list}
  END
  Check Length Of Todo List    0
  Check Length Of Complete List    0