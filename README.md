# README

Creates a table and graph of blood pressure  and heart rate measurements from Apple iOS exported data recorded on a Withings BPM Connect. Systolic Blood Pressure, Diastolic Blood Pressure and Heart Rate supported. 

I have uploaded this to Heroku for my use. May be a bit of overkill, but trying to bring data into Apple Numbers and getting graphs was tedious and I couldn't figure out to automate adding new data. Since only one server can easily run on a Mac at time and it has to be launched; seemed easier just to put it in the cloud.

Here's how the app works in regular use

Step #1. Launch Health app on your iPhone.
Step #2. Tap on your Profile Picture on the top right.
Step #3. Tap on Export All Health Data → Export to somewhere on your hard drive.
Step #4. Launch the app and click the button to select the downloaded export.zip file.
Step #5. Click Import.

### Issues

I'm using (Withings) Health Mate and getting data from Withings to iOS Health is flaky. I'm almost sure one has to open (Withings) Health Mate app to get data from the device to Health Mate on the iPhone. That seems to work fairly reliably. But getting from Health Mate to iOS Health is not reliably fast. Seconds to days.  Important to note because sometimes one goes through the steps and data is missing. It's because it hasn't gotten from Health Mate to Health.

Only Systolic Blood Pressure, Diastolic Blood Pressure and Heart Rate supported. Data is automatically added to the iOS Health app from a Withings ...

## ToDo

Make sure works on empty database

Refresh index.html.erb after Import

Date coloring is using GMT I think

Daily overlay chart. All 7 days in one chart. Abcissa is GMT. Should be local

Should have a pop up after selecting the export.zip asking if want to import.

Change comments to RichText

Put comments in roll over

Toggles for charts, i.e., so you can pick which ones

Check that sign up creates a new account that doesn't allow access to others' data.

stattime record not being used in main db. Can remove or change so it is updated

Had to use CDN in application.html.erb. 

Consider converting to an app using [Electron](https://www.electronjs.org "Thousands of organizations spanning all industries use Electron to build cross-platform software.") or something similar. But I've never done this and it doesn't look trivial.

### Credits

https://github.com/effkay/convert_apple_health_export Ruby script to convert Apple iOS Health file export.xml to export.csv for blood pressure records. Modified and incorporated.

Charts are built with [High Charts](http://www.highcharts.com/) and [Chartkick](https://chartkick.com). Fusion Charts would probably work in place of High Charts.


#### Notes

Created basic login using http://railscasts.com/episodes/250-authentication-from-scratch-revised?view=comments with a couple of changes for Rails changes in authentication. Also a bit of Bootstrap. 

Authentication so can use with a host like Heroku. Sign ups hidden since once you've allowed yourself, not needed unless you want anyone to see it. I'm planning to put this on Heroku so I can use it privately. To allow sign ups, uncomment <%#= link_to "Sign Up", signup_path %> <!-- Uncomment to allow sign ups --> in `views/layouts/application.html.erb`` which will need to be done initially.

<a href="https://icons8.com/icon/78394/heart-with-pulse">Heart with Pulse icon by Icons8</a>

### Built over since couldn't get original working with 7.0.0. Only worked with alpha

Trying to get bloodpressure app working with Rails 7.0.0.

➜ rails new rails700c --database=postgresql --css bootstrap

But got esbuild by default.

Going to copy in bloodpressure

Brought in some error handling and annotating gems

Needed to add
    "build:css": "sass ./app/assets/stylesheets/application.bootstrap.scss ./app/assets/builds/application.css --no-source-map --load-path=node_modules"
to package.json. But I need to find out how to have this added


All working in 7.0.0 which I couldn't make happen in original app.
