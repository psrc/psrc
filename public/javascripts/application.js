// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
Event.observe(window, 'load', function() {
  observeInputsWithDefaultText();
  observeCorners();
  focusTextbox();
});


function observeInputsWithDefaultText(){
  var inputsWithDefaultText = $$('input.default-text');
  if(inputsWithDefaultText.any()){
    inputsWithDefaultText.each(function(input){
      input.observe('focus', function(){ 
        if($F(input) == input.defaultValue)
          input.clear(); input.addClassName('input-focus');
      }.bind(input))

      input.observe('blur', function(){ 
        if($F(input).empty())
          input.value = input.defaultValue; input.removeClassName('input-focus');
      }.bind(input))    
    })
  }
}

function focusTextbox(){
  if($$('.focus').any())
    $$('.focus').first().focus()
}

function observeCorners(){
  settings = {
    tl: { radius: 15 },
    tr: { radius: 15 },
    bl: { radius: 15 },
    br: { radius: 15 },
    antiAlias: true,
    autoPad: false,
    validTags: ["div"]
  }
  var cornersObj = new curvyCorners(settings, '.rounded');
  cornersObj.applyCornersToAll();
}
