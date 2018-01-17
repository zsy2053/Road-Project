# README

## Ruby and Rails Versions

This application requires Ruby version >= 2.4.3 and Rails version >= 5.1.4

## Environment Variables

### Database

* DB_ADAPTER
* DB_HOST
* DB_PORT
* DB_NAME
* DB_USER
* DB_PASS

### Secret Base
* SECRET_KEY_BASE

### Email Settings

_production_ assumes a GMail account is being used to send mail as follows:

* GMAIL_ADDRESS
* GMAIL_PORT
* GMAIL_DOMAIN
* GMAIL_USER_NAME
* GMAIL_PASSWORD
* GMAIL_AUTHENTICATION
* GMAIL_ENABLE_STARTTLS_AUTO

_development_ has been configured to use the {mailcatcher}[http://mailcatcher.me/] gem. See page on how to install and use to collect emails.

### Web Application URL

* WEB_APP_URL - for example <i>http://localhost:3000</i>, NOTE: no trailing slash 
* URL_PROTOCOL 
* URL_DOMAIN 
* URL_PORT 

### AWS

* AWS_ACCESS_KEY
* AWS_SECRET_KEY
* S3_BUCKET_NAME - name of buckt where uploads will go -- will use prefix _uploads/_
* AWS_BUCKET_REGION - code for region where bucket was created

Additionally, in _development_ and _test_ the following is used to keep developer work separate -- leave blank in other environments
* S3_PREFIX -- username with trailing slash, for example _spai/_

---

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
