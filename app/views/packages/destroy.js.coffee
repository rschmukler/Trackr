<% if @package %>
smoke.confirm('<%= escape_javascript(flash.discard(:notice)) %>')
$('section[data-id=<%= @package.id %>]').slideUp();
<% else %>
smoke.alert('<%= escape_javascript(flash.discard(:alert)) %>')
