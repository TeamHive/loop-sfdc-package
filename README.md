### Loop SFDC PAckage

In this package you will find the unmanaged package that we use to deploy the Loop Integration into organizations Salesforce.com instances.

#### Setup Instructions
1. Install `ant` through `homebrew` (`brew install ant`)
2. Create a `build.properties` using the `example.build.properties` file with the username and password (including security token if needed).


#### Deploy
1. Once the setup instructions have been completed, you just need to run `ant Deploy`

#### Retrieve
If for any reason you want to make changes in SFDC and then pull those changes into  this repo you can run the `ant Retrieve` command. This will create a folder called `retrieve` in which you can pull out your changes and commit.