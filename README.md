# SiteStatusDetector

Simple application for detecting site status (200 or something else) and send
notification to the email when status changed.

## Installation

Clone this repository and create `.gmail_credentials.yml` in the application root directory (for smtp authentication)

```
/.gmail_credentials

username: 'username@gmail.com'
password: 'password'
```

And then

    $ bundle install

## Usage

    $ rake start['https://list_of_urls.com https://splitted_by_space.com','target@email.com']
