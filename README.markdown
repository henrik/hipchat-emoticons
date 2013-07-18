# HipChat emoticons

A Sinatra app running on Heroku.

See it here: <http://hipchat-emoticons.nyh.name>

## Noticed an unlisted emoticon?

There is an update script to update the emoticon set. The process is semi-manual, so I run it about once a week.

If you notice new emoticons, feel free to [create a GitHub *issue*](https://github.com/henrik/hipchat-emoticons/issues/new) or [ping me on Twitter](http://twitter.com/henrik) and I'll probably update sooner.

*Pull requests* for new emoticons aren't necessary since I'll just use the update script.

Pull requests for other things are of course very welcome.


## Want to request a new emoticon?

This site just lists the emoticons that HipChat supports. Contact them if you want to suggest additions.

Or you can [upload custom emoticons](https://hipchat.com/admin/emoticons) that only work on your account.


## Running locally

Make sure you're running Ruby 1.9 or better.

    bundle install
    rackup
    open http://localhost:9292


## Updating emoticons.json

Run `rake` and follow its instructions.

The task will update `emoticons.json`. Commit and push.


## Credits and license

By [Henrik Nyh](http://henrik.nyh.se/) under the MIT license:

>  Copyright (c) 2011 Henrik Nyh
>
>  Permission is hereby granted, free of charge, to any person obtaining a copy
>  of this software and associated documentation files (the "Software"), to deal
>  in the Software without restriction, including without limitation the rights
>  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>  copies of the Software, and to permit persons to whom the Software is
>  furnished to do so, subject to the following conditions:
>
>  The above copyright notice and this permission notice shall be included in
>  all copies or substantial portions of the Software.
>
>  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>  THE SOFTWARE.
