(function($) { $(document).ready(function(){ $( '#hisella-minimize' ).click( function() { if( $( '#hisella-facebook' ).css( 'opacity' ) == 0 ) { $( '#hisella-facebook' ).css( 'opacity', 1 ); $( '.hisella-messages' ).animate( { right: '0' } ).animate( { bottom: '0' } ); } else { $( '.hisella-messages' ).animate( { bottom: '-300px' } ).animate( { right: '-135px' }, 400, function(){ $( '#hisella-facebook' ).css( 'opacity', 0 ) } ); } } ) }); })(jQuery);
  (function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.0";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
