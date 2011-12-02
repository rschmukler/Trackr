<% if @success %>
$('ul.email-confirms').append('<%= escape_javascript(render :partial => "settings/email_row", :object => @email_address, :as => :email) %>')
$("input[type=text]").val('');
<% else %>
smoke.alert('<%= escape_javascript flash.discard(:alert) %>')
<% end %>