# README

## Developer Statement
Warehouse is a personal project of mine that I've created for a multiple of reasons. First and foremost, I've created it to serve as a portfolio project so I can show examples of my work to potential employers and/or clients. It will also serve as a playground, running in a live environment, to help in learning new (to me) Ruby on Rails features, front-end frameworks, and DevOps practices. In the distant future, I might even use it as a target to learn pentesting. 

At the time of writing this, the project is sitting in a private repository, which will soon change. This makes me nervous and excited. At this time, I don't plan on actively promoting this project anywhere, so it's likely nobody will see it. But the questions still linger in my head: will it prompt feedback? Could it inspire? Might it help someone as an example for their own learning? 

## Design Motivations/Decisions
Over time, I've learned both Ruby and Rails from official guides, API documentation, books, blogposts, video tutorials, and conference talks. My CS degree taught me fundamental concepts and abstractions, but most of my specialized programming knowledge has come from the greater community (thank you all! ❤️). I made heavy use of the official Rails Guides and the _Agile Web Development with Rails_ book for this application. I also made the following decisions along the way:

* There is no cart. I built a cart-based application in _Agile Web Development with Rails_, so I wanted a to challenge myself with something different.
* The payment processor is Stripe. It seemed to be the simplest integration with the easiest (for me) to understand documentation, having never done a payments integration in the past. 
* It uses a postgresql database, because it's hosted on Heroku.
* It uses Google Cloud Storage as an ActiveStorage bucket for image hosting, because of the free tier.
* Admin authentication is handled by Device.
* The front-end leverages Bootstrap's CSS libraries.

The rest of the app is "stock" Rails. 

## Installation

### Prerequisites:
- [ ] Ruby (2.7.1) 
- [ ] PostgreSQL (a server must be running, prior to installation)
- [ ] ImageMagick
- [ ] Git
- [ ] Node.js
- [ ] Yarn

### Install
Clone git repository:

`$ git clone https://github.com/timthomasdev/warehouse.git`

Install packages

`$ cd warehouse`

`$ bundle install`

Create databases

`$ rails db:create`

Run migrations

`$ rails db:migrate`

### Operation
To start the application on localhost:3000:

`$ rails server`

To add wares (your items for sale), an Admin must be created in the Rails console (WARNING: BAD SECURITY PRACTICE, DO NOT DO THIS FOR REAL ACCOUNTS IN REAL APPLICATIONS):

`$ rails console`

`> Admin.create!(email: "YOUR_EMAIL_ADDRESS", password: "SECURITY_WEAKNESS")`

Then, you can login at `localhost:3000/login` and add new wares from `localhost:3000/wares`
