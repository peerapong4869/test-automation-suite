*** Settings ***
Library    RequestsLibrary

*** Test Cases ***
Example Test
    ${response}=    GET  https://www.google.com

Quick Get Request With Parameters Test
    ${response}=    GET  https://www.google.com/search  params=query=ciao  expected_status=200