<% if @email_address %>
smoke.alert('<%= escape_javascript(flash.discard(:notice)) %>')
$('li[data-id=<%= @email_address.id %>]').slideUp();
<% else %>
smoke.alert('<%= escape_javascript(flash.discard(:alert)) %>')
<% end %>
