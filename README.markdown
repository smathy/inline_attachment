Inline Attachment
=================

This package adds full support for embedding inline images into your HTML emails
through ActionMailer.

Installation
------------

### As a Gem ###

To perform a system wide installation:

	gem source -a http://gems.github.com
	gem install JasonKing-inline_attachment

To use inline_attachment in your project, add the following line to your project's
config/environment.rb:

	config.gem 'JasonKing-inline_attachment', :lib => 'inline_attachment'


### As a Rails Plugin ###

Use this to install as a plugin in a Ruby on Rails app:

	$ script/plugin install git://github.com/JasonKing/inline_attachment.git

### As a Rails Plugin (using git submodules) ###

Use this if you prefer the idea of being able to easily switch between using edge or a tagged version:

	$ git submodule add git://github.com/JasonKing/inline_attachment.git vendor/plugins/inline_attachment


Usage
-----

I've rewritten most of Edmond's great work in this version.  I now override
path_to_image instead of `image_tag` because a big reason for all the Rails2
breakages was because `image_tag` was basically reproduced in previous versions,
so broke when that method changed.

Now we override the very simple path_to_image, and most importantly we really
just add our own stuff for ActionMailer templates, and resort to the existing
code for everything else.

I've also integrated in with the new implicit multipart stuff.  So now, there is
so little code required!

#### notifier.rb
	class Notifier < ActionMailer::Base
	  def signup
	    recipients %q{"Testing IA" <testing@handle.it>}
		  from       %q{"Mr Tester" <tester@handle.it>}
		  subject "Here's a funky test"
	  end
	end
	
Oh yeah baby!  Read it and weep!  So how's this work?  Well, you'll need
your templates named properly - see the _Multipart email_ section of the
ActionMailer::Base docs.
	
#### signup.text.plain.erb
	Your username is: <%= @username %>
	
#### signup.text.html.erb
	<html><head><title>Signup Notification</title></head><body>
	  <%= image_tag "logo.png" %>
		<p>Your username is: <%=h @username %>
	</body></html>


That's it!  InlineAttachment will look for
`#{RAILS_ROOT}/public/images/logo.png` and will do the right thing and embed it
inline into the HTML version of the email.  ActionMailer will do the right thing
and offer the recipient both the `text/plain` and `text/html` parts as alternatives.

**Note the filenames include the (unusual) major.minor MIME type, look above at
the filenames closely.**


Note, that you should still be able to use this in the 0.3.0 way if you have
code that uses that.  But there were a lot of alternatives, and the examples in
here didn't show a crucial step of shuffling the parts around to be sure that
the image parts came after the html.

You can also do the old _manual_ method if you want.


Contributors
------------
 
* Jason King (JasonKing)
* Matt Griffin (betamatt) - file:// and chaining cleanup
* Logan Raarup (logandk)  - pluginified
* Jeffrey Damick (jdamick) - bugfix
