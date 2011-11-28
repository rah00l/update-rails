#Version GAMINGSTATION_ROR_ver1.0.0
#currently running application
#BASIC ENTRY MODULE WITH ALL MASTERS CREATION OPTION
#LAST UPDTAED ON 2009-08-06


require 'custom_error_message'
require 'login_system'

class ApplicationController < ActionController::Base
  include LoginSystem
#  model :user

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_GS_session_id'
  
  
  def fading_flash_message(text, seconds=3)
    puts "in fade"
  text +
    <<-EOJS
      <script type='text/javascript'>
        Event.observe(window, 'load',function() { 
          setTimeout(function() {
            message_id = $('notice') ? 'notice' : 'warning';
            new Effect.Fade(message_id);
          }, #{seconds*1000});
        }, false);
      </script>
    EOJS
end
end
