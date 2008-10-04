jQuery(document).ready(function($) {
  observeFocus();
  observeNavigation();
  animateBannerCaption();
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
      interval: 100,
      over: showSubMenu,
      timeout: 200,
      out: hideSubMenu
    };
    $("#nav li").hoverIntent(config);
  }
}
function showSubMenu(){ $(this).children('ul').slideDown(200) }
function hideSubMenu(){ $(this).children('ul').slideUp(200) }

function animateBannerCaption(){
  var bannerId = '#banner-caption';
  var defaultWidth = $(bannerId).css('width');
  $(bannerId).children().hide();
  $(bannerId).css('width','0').animate({width: defaultWidth}, 700, function(){
    $(this).children().fadeIn();
  });
}

