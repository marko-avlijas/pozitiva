// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function setPackaging(e){
  var $div_row = e.parent().parent().parent();
  
  var $rinfuza = $div_row.find('div.form-rinfuza');
  var $paket = $div_row.find('div.form-paket');
  var $vario = $div_row.find('div.form-vario');
      
  if (e.val() === 'bulk') {
    // prikazivanje rowa i kopiranje vrijednosti atributa name u data-was-name
    $rinfuza.slideDown();
    //hide rowa i brisanje vrijednosti atributa name:
    $paket.slideUp();
    $vario.slideUp();
  
  } else if (e.val() === 'package'){
    $rinfuza.slideUp();
    $paket.slideDown();
    $vario.slideUp(); 
  
  } else if (e.val() === 'vario') {
    $rinfuza.slideUp();
    $paket.slideUp();
    $vario.slideDown();
  
  } else {
    $rinfuza.slideUp();
    $paket.slideUp();
    $vario.slideUp();
  }
  
}

function zebra() {
  $('.duplicatable_nested_form:odd').css('background-color', '#FAFCF5');
  $('.duplicatable_nested_form:even').css('background-color', '#EFF1E8');
}

$(document).on('change', '.packaging', function(e)  { setPackaging($(this)) });

$(document).ready(function(){
  zebra();
  // one-time initialize according to form values
  $('.packaging').each(function() { setPackaging($(this)) });
  
  $('.form-unit').change(function() {
    var unit_val = $(this).val();
    $(this).parent().parent().find(".price-unit").text("kn/" + unit_val);
    $(this).parent().parent().find(".min-qty-unit").text(unit_val);
  });  
  
});

// kod loadanja stranice nijedan select nije odabran - div je kolapsiran
// onchange u selectu div se pojavljuje (.slideDown), provjerava se koja je vrijednost selectanog optiona, i prema tome prikazuju odgovarajuća polja
// onchange u selectu, provjerava se koja je vrijednost selectanog optiona, ako je ista ne događa se ništa, ako je druga, skrivaju se postojeća polja i pokazuju druga odgovarajuća
// 
// ako se ispune polja i tako sejva formular, spremaju se samo ona polja koja su vidljiva