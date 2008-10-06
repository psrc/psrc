jQuery(document).ready(function($) {
  observeFocus();
  observeNavigation();
  animateBannerCaption();
  jQuery('a[rel*=facebox]').facebox();
})

function comingSoon(elm){
  $(elm).text('This feature is not available yet').effect('highlight',{}, 3000);
}

function observeFocus(){
  if($('input.focus').length > 0)
    $('input.focus')[0].focus();
}

function disableSubmit(form){
  // Commit is the submit button name
  form.commit.disabled = true;
}

function observeNavigation(){
  // Uses MouseIntent Jquery Plugin
  if($('#nav li').length > 0){
    var config = {    
      sensitivity: 2, 
      interval: 50,
      over: showSubMenu,
      timeout: 350,
      out: hideSubMenu
    };
    $("#nav li").hoverIntent(config);
  }
}
function showSubMenu(){ $(this).addClass('current').children('ul').slideDown(300) }
function hideSubMenu(){ $(this).removeClass('current').children('ul').slideUp(300) }

function animateBannerCaption(){
  var bannerId = '#banner-caption';
  var defaultWidth = $(bannerId).css('width');
  $(bannerId).children().hide();
  $(bannerId).css('width','0').animate({width: defaultWidth}, 800, function(){
    $(this).children().fadeIn('slow');
  });
}

