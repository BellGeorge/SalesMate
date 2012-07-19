# Sales Mate

Sales Mate is a native iOS application that utilizes the Salesforce Mobile SDK. It authenticates via OAuth and utilizes Core Location, Core Data, Push Notifications, and the Streaming API.

### Overview

Once authenticated, Sales Mate queries Salesforce for all Opportunity and Lead information including related Contacts and Accounts. All data is stored in Core Data allowing offline access to all downloaded information. Sales Mate also connects to the Streaming API and listens for new Lead creations.

### Limitations

- Push Notifications only occur on new Lead creation with a Web source.
- Streaming API only alerts users to new Leads created with a Web Source.
- There is currently no editing.
- For maps to work properly geolocation coordinates must be provided as a field on the Account, Contact, and Lead.
- Leads Near Me only displays the Lead's Name and Company.

### To Do

- Core Data currently doesn't remove any information. If a lead is deleted it will remain on the device and may be visible to the user.
- Allow user to edit information.
- Open Leads from Leads Near Me tab.