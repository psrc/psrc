require File.dirname(__FILE__) + "/../spec_helper"

describe Mail do
  dataset :mailer_page

  before :each do
    @page = pages(:mail_form)
    @page.request = ActionController::TestRequest.new
    @page.last_mail = @mail = Mail.new(@page, {:recipients => ['foo@bar.com'], :from => 'foo@baz.com'}, {'body' => 'Hello, world!'})
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.deliveries = []
  end

  describe 'config validation' do
    it "should have an invalid config when from is absent" do
      Mail.valid_config?('recipients' => 'foo@bar.com').should be_false
    end

    it "should have an invalid config when recipients are absent" do
      Mail.valid_config?('from' => 'foo@baz.com').should be_false
    end

    it "should have a valid config when recipients and from keys are present" do
      Mail.valid_config?('recipients' => 'foo@bar.com', 'from' => 'foo@baz.com').should be_true
    end

    it "should have a valid config when recipients_field stands in for recipients" do
      Mail.valid_config?('recipients_field' => 'to', 'from' => 'foo@baz.com').should be_true
    end

    it "should have a valid config when from_field stands in for from" do
      Mail.valid_config?('recipients' => 'foo@bar.com', 'from_field' => 'from').should be_true
    end
  end
  
  describe 'config error messages' do
    it 'should exist for from' do
      Mail.config_error_messages('recipients' => 'foo@bar.com').should == "'from' is required"
    end
    
    it 'should exist for recipients' do
      Mail.config_error_messages('from' => 'foo@baz.com').should == "'recipients' is required"
    end
  end

  it "should derive the from field from the configuration" do
    @mail.from.should == 'foo@baz.com'
  end

  it "should derive the from field from the data when not in the configuration" do
    @mail.config[:from] = nil
    @mail.config[:from_field] = 'from'
    @mail.data['from'] = 'radiant@foo.com'
    @mail.from.should == 'radiant@foo.com'
  end

  it "should derive the recipients field from the configuration" do
    @mail.recipients.should == ['foo@bar.com']
  end

  it "should derive the recipients field from the data when not in the configuration" do
    @mail.config[:recipients] = nil
    @mail.config[:recipients_field] = 'to'
    @mail.data['to'] = 'radiant@foo.com'
    @mail.recipients.should == %w(radiant@foo.com)
  end

  it "should derive the reply_to field from the configuration" do
    @mail.config[:reply_to] = "sean@radiant.com"
    @mail.reply_to.should == "sean@radiant.com"
  end

  it "should derive the reply_to field from the data when not in the configuration" do
    @mail.config[:reply_to_field] = 'reply_to'
    @mail.data['reply_to'] = 'sean@radiant.com'
    @mail.reply_to.should == 'sean@radiant.com'
  end

  it "should derive the sender field from the configuration" do
    @mail.config[:sender] = "sean@radiant.com"
    @mail.sender.should == "sean@radiant.com"
  end

  it "should derive the subject field from the data" do
    @mail.data[:subject] = "My subject"
    @mail.subject.should == 'My subject'
  end

  it "should derive the subject field from the configuration when not present in the data" do
    @mail.config[:subject] = "My subject"
    @mail.subject.should == 'My subject'
  end

  it "should generate the subject field when not present in data or configuration" do
    @mail.subject.should == 'Form Mail from test.host'
  end
  
  it "should derive the cc field from the data when configured" do
    @mail.data['cc'] = "sean@radiant.com"
    @mail.config[:cc_field] = 'cc'
    @mail.cc.should == "sean@radiant.com"
  end
  
  it "should derive the cc field from the configuration when not in the data" do
    @mail.config[:cc] = "sean@radiant.com"
    @mail.cc.should == "sean@radiant.com"
  end
  
  it "should return a blank cc when not in the data or configuration" do
    @mail.cc.should be_blank
  end

  it "should derive the filesize_limit from the configuration" do
    @mail.config[:filesize_limit] = 1000
    @mail.filesize_limit.should == 1000
  end
  
  it "should return 0 as filesize_limit when not in the configuration" do
    @mail.filesize_limit.should == 0
  end
  
  it "should derive the file field from the data when configured" do
    file1 = StringIO.new("test_data")
    file2 = Tempfile.new("test2")
    @mail.data['file1'] = file1
    @mail.data['file2'] = file2
    @mail.files.include?(file1).should == true
    @mail.files.include?(file2).should == true
  end
  
  it "should return an empty files array when not in the data" do
    @mail.files.should == []
  end
  
  it "should initially have no errors" do
    @mail.errors.should == {}
  end

  it "should be valid when the configuration and fields are correct" do
    @mail.should be_valid
  end

  it "should be invalid when the recipients are empty" do
    @mail.config[:recipients] = []
    @mail.should_not be_valid
    @mail.errors['form'].should_not be_blank
  end

  it "should be invalid when the recipients contains invalid email adresses" do
    @mail.config[:recipients] = ['sean AT radiant DOT com']
    @mail.should_not be_valid
    @mail.errors['form'].should_not be_blank
  end

  it "should be invalid when the from field is empty" do
    @mail.config[:from] = nil
    @mail.should_not be_valid
    @mail.errors['form'].should_not be_blank
  end

  it "should be invalid when the from field contains an invalid email address" do
    @mail.config[:from] = 'sean AT radiant DOT com'
    @mail.should_not be_valid
    @mail.errors['form'].should_not be_blank
  end

  describe "should be invalid when a required field is missing and a require set to" do
    ["true", "1", "required", "not_blank"].each do |value|
      it "should be invalid when " do
        @mail = Mail.new(@page, {:recipients => ['foo@bar.com'], :from => 'foo@baz.com'}, {:required => {'first_name' => value}})
        @mail.should_not be_valid
        @mail.errors['first_name'].should_not be_blank
      end
    end
  end
  
  describe "should be valid when a require set to" do
    ["true", "1", "required", "not_blank"].each do |value|
      it "#{value}" do
        @mail = Mail.new(@page, {:recipients => ['foo@bar.com'], :from => 'foo@baz.com'},
          {:required => {'first_name' => value}, 'first_name' => "Name"})
        @mail.should be_valid
        @mail.errors['first_name'].should be_blank
      end
    end
  end
  
  it "should be invalid when a required field is invalid email" do
    @mail = Mail.new(@page, {:recipients => ['foo@bar.com'], :from => 'foo@baz.com'},
      {:required => {'first_email' => "as_email"}, 'first_email' => "at@.com"})
    @mail.should_not be_valid
    @mail.errors['first_email'].should_not be_blank
  end
  
  describe "with regex required" do
    it "should be invalid when a required field doesn't match given regex" do
      @mail = Mail.new(@page, {:recipients => ['foo@bar.com'], :from => 'foo@baz.com'},
        {:required => {'birthday' => "/^\\d{2}\\.\\d{2}\\.\\d{4}$/"}, 'birthday' => "11.11.11"})
      @mail.should_not be_valid
      @mail.errors['birthday'].should_not be_blank
      @mail.errors['birthday'].should == "doesn't match regex (^\\d{2}\\.\\d{2}\\.\\d{4}$)"
    end
    it "should be valid when a required field matches given regex" do
      @mail = Mail.new(@page, {:recipients => ['foo@bar.com'], :from => 'foo@baz.com'},
        {:required => {'birthday' => "/^\\d{2}\\.\\d{2}\\.\\d{4}$/"}, 'birthday' => "12.21.1980"})
      @mail.should be_valid
      @mail.errors['birthday'].should be_blank
    end
  end

  it "should not send the mail if invalid" do
    @mail.should_receive(:valid?).and_return(false)
    @mail.send.should be_false
  end

  it "should send an email" do
    @mail.send.should be_true
    ActionMailer::Base.deliveries.should_not be_empty
  end

  it "should not send and should register an error if the Mailer raised an exception" do
    Mailer.should_receive(:deliver_generic_mail).and_raise("Boom!")
    @mail.should be_valid
    @mail.send.should be_false
    @mail.errors['base'].should == "Boom!"
  end
  
  it "should set the Reply-To header on the sent mail to the reply_to value given in the configuration" do
    @mail.config[:reply_to] = "reply_to@example.com"
    @mail.send
    ActionMailer::Base.deliveries.last.reply_to.should == [@mail.config[:reply_to]] # reply_to on TMail is an Array
  end

  it "should set the Reply-To header on the sent mail to the reply_to_field data value given in the configuration" do
    @mail.config[:reply_to_field] = 'email'
    @mail.data['email'] = 'reply_to_field@example.com'
    @mail.send
    ActionMailer::Base.deliveries.last.reply_to.should == [@mail.data['email']] # reply_to on TMail is an Array
  end

  it "should set the Reply-To header on the sent mail to the from value when the configuration does not specify a reply_to" do
    @mail.send
    ActionMailer::Base.deliveries.last.reply_to.should == ['foo@baz.com'] # reply_to on TMail is an Array
  end

  describe "when the page has no email body specified" do
    it "should render the submitted data as YAML to the plain body" do
      Mailer.should_receive(:deliver_generic_mail) do |params|
        params[:plain_body].should == "The following information was posted:\n--- \nbody: Hello, world!\n\n"
        params[:html_body].should be_blank
      end
      @mail.send.should be_true
    end
  end

  describe "when the page has specified a plain email body" do
    before :each do
      @page = pages(:plain_mail)
      @page.request = ActionController::TestRequest.new
      @page.last_mail = @mail = Mail.new(@page, {:recipients => ['foo@bar.com'], :from => 'foo@baz.com'}, {'body' => 'Hello, world!'})
    end

    it "should send an email with the rendered plain body" do
      Mailer.should_receive(:deliver_generic_mail) do |params|
        params[:plain_body].should == 'The body: Hello, world!'
        params[:html_body].should be_blank
      end
      @mail.send.should be_true
    end
  end

  describe "when the page has specified an HTML email body" do
    before :each do
      @page = pages(:html_mail)
      @page.request = ActionController::TestRequest.new
      @page.last_mail = @mail = Mail.new(@page, {:recipients => ['foo@bar.com'], :from => 'foo@baz.com'}, {'body' => 'Hello, world!'})
    end

    it "should send an email with the rendered plain body" do
      Mailer.should_receive(:deliver_generic_mail) do |params|
        params[:plain_body].should be_blank
        params[:html_body].should == '<html><body>Hello, world!</body></html>'
      end
      @mail.send.should be_true
    end
  end
end