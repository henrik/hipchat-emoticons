## Hipchat emoticons Sinatra app on Heroku

## Updating emoticons.json:

Log into the chat in a browser and look for a XHR request like
https://accountname.hipchat.com/api/get_emoticons using a tool
like the Chrome Web Inspector.

That request will be made with certain group_id, user_id and token
parameters. Make a ~/.hipchat-emoticons file containing e.g.

    { "group_id": "12345", "user_id": "12345", "token": "F00" }

and then run

    rake

on the command line to update emoticons.json.

## Updating standard\_emoticons.json:

I just looked at the HTML and built the file manually.
If these ever change, do the same.

