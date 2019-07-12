//ページロード時
$(document).ready( function(){
    //株式分類の表示設定
    set_visible_stock_name();

    //銘柄名表示
    set_stock_name();

});

//イベント時
$(function($) {

    //株式分類変更時
    $('select#stock_hold_stock_type').change(function() {
        set_visible_stock_name();
    });
    $('select#dividend_stock_type').change(function() {
        set_visible_stock_name();
    });

    // 保有銘柄、譲渡銘柄、ウオッチリストのページの銘柄コード変更時
    $('#set_stock_name').change(function() {
        if ($(this).val() !="" && jQuery.isNumeric($(this).val())){
            set_stock_name();
        }else
        {
            $(this).val('');
            $('#stock_input_code_name').text('');
        }
    });
});

//日本株式、日本株式以外の入力欄制御
function set_visible_stock_name(){
    // 現在ページのURL取得
    var url_check   = location.href;

    // 保有銘柄、譲渡銘柄のページの株式分類変更時の銘柄名の制御
    if(url_check.match("/stock_holds")||url_check.match("/dividends")) {
        //日本株式の場合
        if (($('select[name="stock_hold[stock_type]"] option:selected').val() == 'jpn_stock') || ($('select[name="dividend[stock_type]"] option:selected').val() == 'jpn_stock')){
            $('#stock_input_code').css('display','block');
            $('#stock_input_name').css('display','none');
            $('#stock_hold_stock_name').val('');
            $('#dividend_stock_name').val('');
            $('#stock_input_code_name').text('');

        }
        //日本株式以外の場合
        else{
            $('#stock_input_code').css('display','none');
            $('#stock_input_name').css('display','block');
            $('#set_stock_name').val('');
            $('#stock_input_code_name').text('');
        }
    }
}

//銘柄コードの名称設定
function set_stock_name() {
    // 現在ページのURL取得
    var url_check   = location.href;
    if((url_check.match("/stock_holds")||url_check.match("/stock_monitors")||url_check.match("/dividends")) ) {
        url=location.href.split("/");
        if($('#set_stock_name').val() != ""){
            $.getJSON(url[0]+"//"+url[1]+url[2] + '/stock_infos/search/'+ $('#set_stock_name').val())
                .done(function(data) {
                    if(data == null){
                        $('#stock_input_code_name').text('該当なし');
                    }else {
                        $('#stock_input_code_name').text(data.stock_name);
                    }
                });
        }
    }
}