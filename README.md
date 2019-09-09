# Loop SFDC Package

In this package you will find the unmanaged package that we use to deploy the Loop Integration into organizations Salesforce.com instances.

## Setup Instructions

1. Install `ant` through `homebrew` (`brew install ant`)
    * You may need to run `brew cask install adoptopenjdk` if prompted. If you do, run the above command again.
1. Create a `build.properties` using the `example.build.properties` file with the username and password (including security token if needed).

## Commit Changes (Retrieve)

If for any reason you want to make changes in SFDC and then pull those changes into  this repo you can run the `ant Retrieve` command. This will create a folder called `retrieve` in which you can pull out your changes and commit.

## Install into an Org (Deploy)

1. Update the credentials in the `build.properties` file (create it if it doesn't exist) to point a the org the package should be installed to, with a user that has access (e.g. System Administrator). The contents of the `src` folder are deployed.
1. run `ant Deploy`
1. Configure the Package

### Configure the Package

1. In your Salesforce Org, click **Setup**
1. Type **"App Manager"** in the search bar
1. Find the **"Loop"** package and click the Options dropdown button. choose **Edit**
1. Make any updates to Branding (colors, logo, etc.) to suit your company's brand guidelines

### Assigning Permissions

#### Loop Connector View Media

The "Loop Connector View Media" permission set should be assigned to all users that shouldn't have an admin level of view access within the Loop content. This gives the users access to:

* A dedicated Loop app
* A tab to view all Media they have access to based on assigned Loop Groups

> A couple ways this permission set could be assigned are: manually after internal permissions approvals or, automate it when the Loop Groups on the User field is no longer null (possibly auto-remove when the field becomes empty again)

#### Loop Connector Integration Permissions

This Permission Set should be assigned to a single user designated as the integration user between Salesforce and Loop. This user will be used to sign into Salesforce from Loop, connecting the two systems. 

See below for more setup instructions

### Page Layouts

* **Loop Media Layout**: The standard layout to be used with a majority of users
* **Loop Media Admin Layout** An available admin layout that shows more information

> **Data does not sync from Salesforce to Loop.** It is a single direction sync from Loop to Salesforce. No permission should be given or used to change data unless it is an intentional change with the knowledge that the information between Salesforce and Loop **may be out of sync**.

### Connect Salesforce to Loop

#### Create a Connected App in your Salesforce Org

Purpose: A connected app in Salesforce defines the permissions and security an external application can have within a Salesforce instance. Creating a connected app for Loop, in Salesforce, is the first step in integrating the two.

1. Click Setup
1. Type **"App Manager"** in the search bar
1. Click **"New Connected App"** in the top-right corner
1. Fill in the following information and click **Save**

Setting | Value 
------- | ------- 
Connected App Name | Loop Salesforce Connector
API Name | _Use Default_
Contact Email | dev@meetmaestro.com
Enable OAuth Settings | `true`
Callback URL | https://www.myloopaccount.com/api/v1/admin/integrations/salesforce/auth-callback
Selected OAuth Scopes | Access and manage your data (api) <br> Access custom permissions (custom_permissions) <br> Allow access to your unique identifier (openid) <br> Perform requests on your behalf at any time (refresh_token, offline_access)
Require Secret for<br>Web Server Flow | `false`

> If your loop instance has a domain other than `www.myloopaccount.com` make sure to account for that in your **Callback URL**

A **Consumer Key** will have been generated. Keep note of this for the next step.

> As Salesforce states, it can take some time for the Connected App to become available. If you see an error page when authenticating to Salesforce in the next step, give it some time and then try again.

#### Designate an Integration User

Find or Create a user that will be used to log into Salesforce. Best practice states that a single integration should have a dedicated user to ensure proper usage of permissions.

**Recommendation**: Create a Standard User and assign the `Loop Connector Integration Permissions` Permission Set.

> This permission set has everything necessary to manage Loop Media and modify the `Loop_Groups__c` field on the User object.

#### Connect Loop and Salesforce

You will need the following information to connect the systems:

* The **Consumer Key** from the connected app
* The **Integration User's** Username and Password

1. Log into Loop with a Loop **Super Admin**
1. Switch to Admin View
1. Go to the **Config** section
1. Click **Integrations**
1. Select the Salesforce integration
1. Click **Setup**
1. Enter/paste your **Consumer Key** 
1. Click Connect
1. Fill in the credentials of the **Integration User** and accept the permissions
1. Click Continue

Salesforce and Loop are now connected though, not completely configured. Media can now be synced to Salesforce but Users' groups cannot. Before user groups can be synced to Salesforce, the Configuration step must be completed.

#### Configure the Salesforce integration

**User Fields**
Selecting a field from Salesforce and a field from Loop that would contain the same data, maps the users between Loop and Salesforce. These fields should contain unique data or it could cause data to become out of sync.

**Media "Available in Salesforce" by default**
This option will automatically select the "Available in Salesforce" option under the Share Settings when **creating** Media.
