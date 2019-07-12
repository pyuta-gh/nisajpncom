//ページロード時
$(document).ready( function(){
    //NISA口座の年度入力制御
    set_bank_display();
});

$(function($) {
    // 現在ページのURL取得
    var url_check   = location.href;

    //NISA口座の年度入力制御
    if(url_check.match("/banks")) {
        $('#set_bank_year').change(function() {
            set_bank_display();
        });
    }
});

//NISA口座の年度入力制御
function set_bank_display() {
    // NISA口座は年度入力可能
    if ($('#bank_opt_1').is(':checked') || $('#bank_opt_2').is(':checked')){
        $('#year_field').css('display','block');
    }else
    {
        // NISA口座以外は年度入力不可
        $('#bank_year').val('')
        $('#year_field').css('display','none');
    }
}