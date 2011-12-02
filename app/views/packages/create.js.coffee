<% if @success %>
$('#main').append('<%= escape_javascript(render :partial => "packages/package", :object => @package, :as => :package) %>');
$("input[type=text]").val('');
<% else %>
smoke.alert('<%= escape_javascript flash.discard(:alert) %>')
<% end %>