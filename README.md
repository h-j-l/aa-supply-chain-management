# Automation Anywhere Labs - Supply Chain Management

[Link](https://developer.automationanywhere.com/challenges/automationanywherelabs-supplychainmanagement.html)

The goal of the challenge is to fill in purchase order details for given *PO Numbers*.

*Ship Date* and *Order Total* can be found from [Procurement Anywhere](https://developer.automationanywhere.com/challenges/AutomationAnywhereLabs-POTrackingLogin.html) (*PA*).  
For *Assigned Agent* we'll need to retrieve the PO Number's *State* from PA and use it to find the agent's *Full Name* from the provided Excel file.

## Steps

1. Open the challenge page in any available browser
2. Download the Excel file
3. Open PA and sign in
4. Read a PO Number from the challenge page
5. Perform a search in PA with the PO Number
6. Retrieve the PO Number's details
7. Find the agent's *Full Name* from the Excel file based on the agent's *State*
8. Enter *Ship Date*, *Order Total* and *Assigned Agent* (Full Name) into the challenge page's form fields
9. Submit and process next PO Number
10. When finished, save the score
11. Log out from PA and close both browser windows