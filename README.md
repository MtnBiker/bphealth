# README

➜ rails new rails700c --database=postgresql --css bootstrap

But got esbuild by default.

Going to copy in bloodpressure

Brought in some error handling and annotating gems

Needed to add
    "build:css": "sass ./app/assets/stylesheets/application.bootstrap.scss ./app/assets/builds/application.css --no-source-map --load-path=node_modules"
to package.json. But I need to find out how to have this added