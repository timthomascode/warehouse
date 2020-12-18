# README

## Developer Statement
Warehouse is a personal project of mine that I've created for multiple reasons. First and foremost, I've created it to serve as a portfolio project so I can show examples of my work to potential employers and/or clients. It will also serve as a playground, running in a live environment, to help in learning new (to me) Ruby on Rails features, front-end frameworks, and DevOps practices. In the distant future, I might even use it as a target to learn pentesting. 

Over time, I've learned both Ruby and Rails from official guides, API documentation, books, blogposts, video tutorials, and conference talks. My CS degree taught me fundamental concepts and abstractions, but most of my specialized programming knowledge has come from the greater community (thank you all! ❤️). I made heavy use of the official Rails Guides and the _Agile Web Development with Rails_ book for this application. 

## Design Motivations/Decisions

Warehouse was inspired by the concept of a garage sale. For that reason, there is no quantity for wares - items must be listed and sold individually. That also means there is no cart. Not the wisest decision for a _real_ e-commerce application, but it created a unique set problems for a personal project. An order timeout of 15 minutes keeps the warehouse index updated, with the help of ActionCable and ActiveJob.
