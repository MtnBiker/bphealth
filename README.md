# README

Creates a table and graph of blood pressure and heart rate measurements. Data is recorded on a Withings BPM Connect. And then brought into Apple iOS Health app and then exported to desktop where the data is exported into this app.  Systolic Blood Pressure, Diastolic Blood Pressure and Heart Rate supported. 

I have uploaded this to Heroku for my use. May try to allow as test site. 

May be a bit of overkill, but trying to bring data into Apple Numbers and getting graphs was tedious and I couldn't figure out to automate adding new data. Since only one server can easily run on a Mac at time and it has to be launched; seemed easier just to put it in the cloud.

Here's how to use the app works in regular use, after initial set up

Step #1. Launch Health app on your iPhone.
Step #2. Tap on your Profile Picture on the top right.
Step #3. Tap on Export All Health Data → Export to somewhere on your hard drive.
Step #4. Launch the app and click the button to select the downloaded export.zip file.
Step #5. Click Import.

Rails 7.0.0
Ruby 3.0.3
Postgres. Using a view, but that may be not necessary if use Rails 7 changes. Would require add stattime to main table. But this change would probably make it easier to use other databases.
Sprockets, not Webpacker or Import Maps. 3 JavaScript handled by CDN in application.html.erb

### Issues

I'm using (Withings) Health Mate and getting data from Withings to iOS Health is flaky. I'm almost sure one has to open (Withings) Health Mate app to get data from the device to Health Mate on the iPhone. That seems to work fairly reliably. But getting from Health Mate to iOS Health is not reliably fast. Seconds to days.  Important to note because sometimes one goes through the steps and data is missing. It's because it hasn't gotten from Health Mate to Health.

## ToDo

Fix export to Heroku !!!

Make sure works on empty database for new set ups

Refresh index.html.erb after Import

Daily overlay chart. All 7 days in one chart. Abcissa is GMT. Should be local. (_last_week_by_days.html.erb)

Should have a pop up after selecting the export.zip asking if want to import.

Change comments to RichText

Put comments in roll over

Toggles for charts, i.e., so you can pick which ones

Check that sign up creates a new account that doesn't allow access to others' data.

I think Rails 7 allows creating a derived field, so could get rid of view which has stattime

Had to use CDN in application.html.erb. 

Consider converting to an app using [Electron](https://www.electronjs.org "Thousands of organizations spanning all industries use Electron to build cross-platform software.") or something similar. But I've never done this and it doesn't look trivial.

### Credits

Modified and incorporated  [Ruby script](https://github.com/effkay/convert_apple_health_export) to convert Apple iOS Health file export.zip.

Charts are built with [High Charts](http://www.highcharts.com/) and [Chartkick](https://chartkick.com). Fusion Charts would probably work in place of High Charts.

Created login using http://railscasts.com/episodes/250-authentication-from-scratch-revised?view=comments with a couple of changes for Rails changes in authentication.

[Bootstrap](https://getbootstrap.com) for formatting. 

[Ruby on Rails](https://rubyonrails.org) of course. [Postgres](https://www.postgresql.org).

#### Notes


Authentication so can use with a host like Heroku. Sign ups hidden since once you've allowed yourself, not needed unless you want anyone to see it. I'm planning to put this on Heroku so I can use it privately. To allow sign ups, uncomment <%#= link_to "Sign Up", signup_path %> <!-- Uncomment to allow sign ups --> in `views/layouts/application.html.erb`` which will need to be done initially.

<a href="https://icons8.com/icon/78394/heart-with-pulse">Heart with Pulse icon by Icons8</a>

