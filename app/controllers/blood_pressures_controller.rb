class BloodPressuresController < ApplicationController
  before_action :set_blood_pressure , only: %i[ show edit update destroy ] # if add import_data, import fails
  # helper_method :systolic_text_color # checks here first, then goes to helpers which is what I'm using

  # GET /blood_pressures or /blood_pressures.json
  def index
    # @blood_pressures = BloodPressure.all.order("statdate") # .order for sorting in index.html.erb
    @pagy, @blood_pressures= pagy(@blood_pressures = BloodPressure.all.order("statdate DESC"), items: 25) # items is no. per page(y)

    # Ransack search. Ransack gem now breaks bin/dev
    # @q = BloodPressure.ransack(params[:q]) # syntax of
    # @blood_pressures = @q.result(distinct: true)
  end

  def printable_table # needed for page to work
    @blood_pressures = BloodPressure.all.order("statdate")
  end

  # GET /blood_pressures/1 or /blood_pressures/1.json
  def show
  end

  # GET /blood_pressures/new
  def new
    @blood_pressure = BloodPressure.new
  end

  # GET /blood_pressures/1/edit
  def edit
  end

  # POST /blood_pressures or /blood_pressures.json
  def create
    @blood_pressure = BloodPressure.new(blood_pressure_params)

    respond_to do |format|
      if @blood_pressure.save
        format.html { redirect_to @blood_pressure, notice: "Blood stat was successfully created." }
        format.json { render :show, status: :created, location: @blood_pressure }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @blood_pressure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blood_pressures/1 or /blood_pressures/1.json
  def update
    respond_to do |format|
      if @blood_pressure.update(blood_pressure_params)
        # format.html { redirect_to @blood_pressure, notice: "Blood stat was successfully updated." }
        # Want to go back to index page and found one that does that
        format.html { redirect_to blood_pressures_url, notice: "Blood stat was successfully updated." }
        format.json { render :show, status: :ok, location: @blood_pressure }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @blood_pressure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blood_pressures/1 or /blood_pressures/1.json
  def destroy
    @blood_pressure.destroy
    respond_to do |format|
      redirect_to blood_pressures_url, notice: "Blood stat was successfully destroyed."
      format.json { head :no_content }
    end
  end

  def lineNum()
    caller_infos = caller.first.split(":")
    # Note caller_infos[0] is file name
    # caller_infos[1]
    return "#{caller_infos[1]}"
  end # couldn't be found in helpers/application_helper.rb

  # unzipping to one folder, but the file of interest ends up one dir down
  # extract_zip(zip_path, extract_destination)
  # Above from https://stackoverflow.com/questions/9204423/how-to-unzip-a-file-in-ruby-on-rails
  def extract_zip(file, unzip_dir, destination)
    # puts "#{lineNum}. Hello from the top of extract_zip in unzip_import_data in blood_pressures_controller. \nfile: #{file}. \nunzip_dir: #{unzip_dir}"
    # # Create folder for the export.xml which goes to /apple_health_export. That's the way the zipped file is structured
    # FileUtils.mkdir(unzip_dir) unless File.exist?(unzip_dir) # I thought the following would create this dir, but, and it won't exist now that Rails is creating a special folder for where selected files are moved to (and given a new name)
    # unzip_dir = unzip_dir + "/apple_health_export/"
    puts "#{lineNum}. file: #{file} \n   unzip_dir: #{unzip_dir}"
    FileUtils.mkdir(unzip_dir) unless File.exist?(unzip_dir)
    Zip::File.open(file) do |zip_file| # I think this meets ruby_zip 3.0 syntax
      zip_file.each do |f|
        puts "#{lineNum}. Extracting f.name: #{f.name}" # assume the name method is part of zip gem
        fpath = File.join(unzip_dir, f.name)
        # fpath is the output filepath and the first file will be export.xml
        puts "#{lineNum}. File.exist?(file in zip_file): #{File.exist?(file)}"
        puts "#{lineNum}. Next step is 'zip_file.extract(f, fpath)' where f: #{f} and \n  fpath: #{fpath}" # /Users/gscar/Documents iMac only/Ruby/Rails 7 Trials/bloodpressure/app//tmp/import/apple_health_export/export.xml
        puts "#{lineNum}. File.exist?(unzip_dir), i.e., some sort of tmp folder: #{File.exist?(unzip_dir)}"
        FileUtils.mkdir(destination) unless File.exist?(destination)
        puts "#{lineNum}. destination: #{destination}"
        puts "#{lineNum}. File.exist?(destination): #{File.exist?(destination)}"
        zip_file.extract(f, fpath) unless File.exist?(fpath)
        if f.name == "apple_health_export/export.xml" # Stopping once create the export.xml which is all I need
          puts "#{lineNum}. export.xml was extracted to #{fpath}"
          break
        else
          puts "#{lineNum}. Something went wrong."
        end
      end
    end
  end
 
  # Called second by ConvertXML
  def parse_xml(path)
    document = File.open(path) { |f| Nokogiri::XML(f) }
    # Couldn't get variable to work with the following, so put in the info directly
    systolic_records =   document.xpath("//Record[contains(@type,'HKQuantityTypeIdentifierBloodPressureSystolic')]").map(&:to_h)
    diastolic_records =  document.xpath("//Record[contains(@type,'HKQuantityTypeIdentifierBloodPressureDiastolic')]").map(&:to_h)
    resting_hr_records = document.xpath("//Record[contains(@type,'HKQuantityTypeIdentifierRestingHeartRate')]").map(&:to_h)
    hr_records =         document.xpath("//Record[contains(@type,'HKQuantityTypeIdentifierHeartRate')]").map(&:to_h)

    [systolic_records, diastolic_records, resting_hr_records, hr_records]
  end

  # Called last by ConvertXML. parses the record file add data line by line. Unfortunately going through the entire record and existing are rejected
  def add_to_db(records)
    count = 1 # only for puts debugging
    records.each do |record|
      # puts "#{lineNum}. record: #{record}"
      # puts "#{lineNum}. record.class: #{record.class}"
      # puts "#{lineNum}:#{count}. statdate: #{record[3]}. systolic: #{record[0]}"
      # count += 1
      # blood_pressure = BloodPressure.create(statdate: record.time, systolic: record.systolic, diastolic: record.diastolic, heartrate: record.hr, sourceName: record.sourceName, sourceVersion: record.sourceVersion)
      blood_pressure = BloodPressure.create(statdate: record[3], systolic: record[0], diastolic: record[1], heartrate: record[2]) #, sourceName: record.sourceName, sourceVersion: record.sourceVersion)
      # puts "#{lineNum}. BloodPressure: #{blood_pressure}" # obj
      # puts "/lib/tasks/import.rake:#{lineNum}. record.time: #{record.time} after adding to database?"
    end
  end

# Called fourth by ConvertXML
  def join_records(systolic_records, diastolic_records, resting_hr_records, hr_records)
    countRecords = 0
    accu = []
    records = systolic_records.each_with_object([]) do |record|
      countRecords =+ 1
      # You can parse a String and make it a Date object with DateTime.parse
      # But this is creating a csv which probably is a string.
      startDate = DateTime.parse(record['startDate']) # convert to type date and in find_matching_value use datetime comparisons
      pair = find_matching_value(startDate, diastolic_records)
      rhr =  find_matching_value(startDate, resting_hr_records)
      hr =   find_matching_value(startDate, hr_records)
      if hr.to_i < rhr.to_i
        hr = rhr
      end
      sys = record['value']
      # puts "#{lineNum}. sys: #{sys}. dia: #{pair}. hr: #{hr}.  startDate: #{startDate}"
      # 151. startDate: 2015-10-19T09:47:00-08:00, dia: 64. hr: . record: {"type"=>"HKQuantityTypeIdentifierBloodPressureSystolic", "sourceName"=>"Health", "sourceVersion"=>"9.0.2", "unit"=>"mmHg", "creationDate"=>"2015-10-19 09:47:23 -0800", "startDate"=>"2015-10-19 09:47:00 -0800", "endDate"=>"2015-10-19 09:47:00-0800", "value"=>"128"}
      # Do I need a hash that looks like  [["statdate", "2021-11-16 16:35:30"], ["hr", 75], ["systolic", 136], ["diastolic", 70]] and forget the accu. NO add_to_db does that
      accu << [sys, pair, hr, startDate ]
      # puts "#{lineNum}. accu: #{accu}"
      # accu << (record['value'], pair, hr, record['startDate']) # leave startDate as string?
    end
    puts "#{lineNum}. accu.last (accu.count: #{accu.count}): #{accu.last}" # All of accu: [[ … , ["132", "68", "53", Sun, 14 Nov 2021 09:02:23 -0800], ["153", "80", "51", Mon, 15 Nov 2021 07:31:42 -0800], ["128", "66", "60", Mon, 15 Nov 2021 17:03:23 -0800], ["136", "70", "51", Tue, 16 Nov 2021 08:35:30 -0800]]
    # puts "#{lineNum}. countRecords]: #{countRecords}. accu[countRecords]: #{accu[countRecords]}"
    # puts accu.uniq { |p| p.time }.sort_by(&:time)
    accu
  end

  # Called by JoinRecords
  def find_matching_value(date, records)
    # Not matching complete date because heart rate is recorded slightly later. Probably show make exact match for systolic and diastolic and use this just for heart rate
    # matching_item = records.find { |sr| sr['startDate'][0..14] == date[0..14] } # for string
    # puts "#{lineNum}. date.class: #{date.class}"
    matching_item = records.find { |sr| DateTime.parse(sr['startDate']) == date } # using datetime
    # puts "#{lineNum}. matching item: #{matching_item}"
    matching_item['value'] if matching_item != nil
  end

  # Runs this first
  def convert_xml(input_path)
    systolic_records, diastolic_records, resting_hr_records, hr_records = parse_xml(input_path) # 2
    records = join_records(systolic_records, diastolic_records, resting_hr_records, hr_records) # 3
    # puts "#{lineNum}. records: #{records}" # one record   #<Record:0x00007f9f1c1cbfc0 @systolic="141", @diastolic="62", @hr="50", @time="2021-09-26 07:40:22 -0700">
    # puts "/lib/tasks/import.rake:#{lineNum}. Found #{records.count} records, will add new to db." #  NoMethodError - undefined method `count' for nil:NilClass:
    puts "#{lineNum}. processing of export.xml complete and final step to add to db using add_to_db."
    add_to_db(records) # 4
  end  # Import button triggers this. For importing from export.zip.

  def import_data
    blood_pressure_params
    # params show up anyway
    # puts "#{lineNum}. params: #{params}" # params: {"authenticity_token"=>"zDyBm6XJD6HZusFWIfNRKJP3NteiIf9mcAQLq2SvTZx4LHg9tGHJtNdYZzLIzvsXH1cjd6CUnrMQesOEpSwfOg", "blood_pressure"=>{"health_exported_zip"=>#<ActionDispatch::Http::UploadedFile:0x00007fbe22a55338 @tempfile=#<Tempfile:/var/folders/f6/59hv1f7923z2rx7yl3hjl8pm0000gn/T/RackMultipart20211224-13925-75ug17.zip>, @original_filename="export 2.zip", @content_type="application/zip", @headers="Content-Disposition: form-data; name=\"blood_pressure[health_exported_zip]\"; filename=\"export 2.zip\"\r\nContent-Type: application/zip\r\n">}, "commit"=>"Import", "controller"=>"blood_pressures", "action"=>"import_data"}
    # At Heroku: Tempfile:/tmp/RackMultipart20220109-4-4a864y.zip
    # puts "#{lineNum}. params[:blood_pressure][:health_exported_zip]: #{params[:blood_pressure][:health_exported_zip]}" # #<ActionDispatch::Http::UploadedFile:0x00007fef60a042e8>
    # puts "#{lineNum}. params[:blood_pressure][:health_exported_zip.tempfile.path]: #{params[:blood_pressure][:health_exported_zip].tempfile.path}" #
    tempfile_path = params[:blood_pressure][:health_exported_zip].tempfile.path #   = params[:blood_pressure][:health_exported_zip].path, but more expressive to leave longer version 
    # indexTempfile = params.to_s.index('/var/folders') # setting start of Tempfile location
    puts "#{lineNum}. tempfile_path: #{tempfile_path}"
  #   # paramSlice will become the path to Tempfile
  #   tempfile_path = params.to_s.slice!(indexTempfile..450) # slice off the beginning of params
  #   # puts "#{lineNum}: tempfile_path: #{tempfile_path}"
  #   indexEnd = tempfile_path.to_s.index('>') - 1 # get end of Tempfile location. Can't do all at once because some `>` at the beginning. Could of course, but this is simpler
  #   tempfile_path = tempfile_path.to_s.slice!(0..indexEnd) # slice off the end of params and left with path
  #   puts "\n#{lineNum}: tempfile_path is now the path to the Tempfile for export.zip: #{tempfile_path}"
  #   # health_exported_zip_file = params[:health_exported_zip].path # need to look at Better if worked using Rails https://api.rubyonrails.org/v7.0.0/classes/ActionDispatch/Http/UploadedFile.html to get this right
  #   # health_exported_zip_file = "/Users/gscar/Downloads/export.zip" # changed to
    # tempfile_path = "/var/folders/f6/59hv1f7923z2rx7yl3hjl8pm0000gn/T/RackMultipart20220110-56077-ecytji.zip"
    # unzip_import_data(tempfile_path) # which will unzip and then import the new data
    require 'zip' # and this does what it needs to do here

    # https://ruby-doc.org/stdlib-2.4.1/libdoc/fileutils/rdoc/FileUtils.html#method-i-makedirs
    unzip_dir = File.dirname(tempfile_path) # try to use same directory
    destination = unzip_dir + "/apple_health_export/"
    export_xml = destination + "/export.xml" # see below for original
    File.delete(export_xml) if File.exist?(export_xml) # delete old files since apparently won't overwrite, at least on macOS, but now in a new tmp folder so won't exist
    puts "#{lineNum}. unzip_dir: #{unzip_dir} \ndestination. #{destination} \nexport_xml: #{export_xml}"
    # extract_zip(health_exported_zip, unzip_to)
    extract_zip(tempfile_path, unzip_dir, destination) # since this is how the gem is set up or at least the sample
    puts "#{lineNum}. Hello from the end of unzip_import_data in blood_pressures_controller. So now unzipped and need to read and import."
    convert_xml(export_xml)
    puts "#{lineNum}. tempfile_path (working location of copy of export.zip): #{tempfile_path}" # Repeating the tempfile_path so if needed for debugging, although can get lost because log is filled up by the page refresh
    # puts "#{lineNum}. request.request_parameters: #{request.request_parameters}" #  78. request.request_parameters: {"authenticity_token"=>"oCFXN0yI-Pbu0V1cQSVyaFxB61LmBcYAEqPF2sWUeCcSYELXwwME3WOsmfbT5QDzuG9JPkNKLFhx9g0iRhp0dg", "commit"=>"Import"}
    # puts "params: #{params}" #  params: {"authenticity_token"=>"NBP3…tvOg", "commit"=>"Import", "controller"=>"blood_pressures", "action"=>"import_data"}

    # export_xml =  "#{ENV['PWD']}/import_staging/apple_health_export/export.xml" # location set in blood_pressure_controller during unzip. Had trouble using /tmp so set. Could I use a /var/folders/ like Tempfile? Using Rails default now
    redirect_to blood_pressures_url # To rerender page after import
end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_blood_pressure
    @blood_pressure = BloodPressure.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def blood_pressure_params
    params.require(:blood_pressure).permit(:statdate, :systolic, :diastolic, :heartrate, :sourceName, :sourceVersion, :comment,:health_exported_zip, :file, :filename)
  end

  # Not being used. Using helpers as seems more logical to me at the moment.  commented out helper_method at top stops this from being used, but does work if uncommented. Controller is checked first for method
  def systolic_text_color (systolic)
    case systolic
    when 0..120
      "text-success"
    when 121..139
      "text-danger"
    when 139..200
      "text-secondary" # should be danger, but using as a test to see if this method being used
    else
      "text-danger"
    end
  end
end
