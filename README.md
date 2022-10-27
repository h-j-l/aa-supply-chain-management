
# Automation Anywhere Labs - Supply Chain Management

[Link](https://developer.automationanywhere.com/challenges/automationanywherelabs-supplychainmanagement.html)

The goal of the challenge is to fill in purchase order details for given *PO Numbers*.

*Ship Date* and *Order Total* can be found from [Procurement Anywhere](https://developer.automationanywhere.com/challenges/AutomationAnywhereLabs-POTrackingLogin.html) (*PA*).  
For *Assigned Agent* we'll need to retrieve the PO Number's *State* from *PA* and use it to find the agent's *Full Name* from the provided Excel file.

## Steps

1. Open the challenge page in any available browser
2. Download the Excel file
3. Sign in to *Procurement Anywhere*
4. Read the *PO Number* from the challenge page
5. Search for the *PO Number* in *Procurement Anywhere*
6. Retrieve PO Number's details
7. Read the agent's *Full Name* from the Excel file
8. Enter *Ship Date*, *Order Total* and *Assigned Agent* into the challenge page's form fields
9. Submit and process any remaining *PO Numbers*
10. Read and save the score
11. Log out from *PA* and close browser windows