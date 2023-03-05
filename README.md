# slack-messenger

A small Serverless AWS Lambda app (written in Ruby) that sends spam notifications to a Slack channel.

<img width="846" alt="Example of Slack message sent by this app" src="https://user-images.githubusercontent.com/43446888/222897225-f94303f0-3c3a-479f-939f-b825d42d3063.png">

## Running locally

To run the application locally, you will need to have [Ruby](https://www.ruby-lang.org/en/) installed. The app was written using version 2.7.7 (as that is a supported AWS Lambda runtime). To improve ease of setup and deployment, the app does not make use of any additional gems.

To invoke the function locally, you will need to have environment variables set for `SLACK_TOKEN` and `SLACK_CHANNEL_ID`, and then run
```
rake invoke
```
You can use `rake "channel_id[<channel-name>]"` (replacing `<channel-name>` with the correct channel name, excluding the `#`) if you have the name of the channel but not the ID. The token must be a Bot User OAuth Token that has the following scopes:
- `chat:write`
- `chat:write.public` (if you are using a public channel that the app has not been added to)
- `channels:read` (if you want to use the command to get the channel ID)

Use `rake test` to run the (admittedly limited) test suite.

## Deploy

To deploy the app, you will need to have [Serverless](https://www.serverless.com/) installed. [This Getting Started guide](https://www.serverless.com/framework/docs/getting-started) includes helpful installation steps.

Once you have serverless installed, it's as easy as setting `DEPLOYMENT_AWS_PROFILE` to the appropriate [AWS CLI profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) that you wish to use for deployment, and then run:
```
sls deploy
```
The above command will return a URL that can be used to trigger the slack notification.

A deployed version is available at `https://rm9n3v1o3i.execute-api.us-east-1.amazonaws.com/dev/spam-notification`, which will send the alert to my personal Slack workspace, and can be triggered by
```
curl -X POST -d '{ "Type": "SpamNotification", "Email": "zaphod@example.com", "Description": "From AWS" }' https://rm9n3v1o3i.execute-api.us-east-1.amazonaws.com/dev/spam-notification
```

## Design decisions

The first decision that I made when beginning this project was that I wanted to use AWS Lambda to run my code. As the project is essentially just one function, the low cost and low complexity of AWS Lambda seemed ideal.

The next decision was to make use of the Serverless framework. I decided to use that as it would help me get up and running as quickly as possible, with very few hurdles and manual implementations needed.

Next, I had to choose the language that I wanted to write the function in. In my current role I mostly work with TypeScript, so that was what my mind jumped to first, but in the end I decided to go with Ruby. I
wanted to showcase my Ruby experience, and I wanted to gain something personally from the project, so I was happy to sharpen my Ruby skills again. It's also very quick to get a new codebase off the ground using Ruby, which is a good fit for this project. I had a lot of fun working with Ruby!

The layout off the codebase itself is very straightforward, as there is not a lot of complexity in the task itself. I decided to create a Slack API helper class to contain the integration with Slack, and then I added a Spam Notification class to contain the business logic (of which there ended up being very little, only formatting the text required for the Slack message using the incoming spam notification data).

## What I would do next

If I had no time limit on this project, these are the next things that I would look at:
- I would like to refactor the `get` and `post` methods in the `SlackApi` class to be more consistent.
- I would look at adding more information to the Slack message and format it nicely (only if additional info would add additional value, I don't want to create unnecessary noise).
- I would like to add proper unit tests.
