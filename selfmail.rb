#!/usr/local/bin/ruby

require 'net/smtp'
#require 'cgi'

def send_email(to,opts={})
  opts[:server]      ||= 'mail.rolandschmitt.info'
  opts[:from]        ||= 'www-data@rolandschmitt.info'
  opts[:from_alias]  ||= 'www-data'
  opts[:subject]     ||= "Nothing here!"
  opts[:body]        ||= "Nothing here!"

  msg = <<END_OF_MESSAGE
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}

#{opts[:body]}
END_OF_MESSAGE

  Net::SMTP.start(opts[:server]) do |smtp|
    smtp.send_message msg, opts[:from], to
  end
end


cgi = CGI.new
subject = cgi["subject"]
body = ""
cgi.keys.each do |key|
	body = body + key + " : " + cgi[key] + "\n"
end

send_email "rolle@rolandschmitt.info", :subject => subject, :body => body

cgi.out('status' => '302', 'location' => cgi["retrun"]) { "" }