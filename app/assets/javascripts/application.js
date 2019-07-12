//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require moment
//= require bootstrap-datetimepicker
//= require pickers
//= require moment/ja
//= require data-confirm-modal
//= require_tree .

jQuery(document).ready(function ($) {
    // メニューフォーカス時ドロップダウンメニュー
    $('.dropdown-toggle').click(function(e) {
        // 要素で親メニューリンクとドロップダウンメニュー表示を切り分ける
        if ($(e.target).hasClass('link-menu')) {
            var location = $(this).attr('href');
            window.location.href = location;
            return false;
        }
        return true;
    });

});

/* inputフォーカス時の色設定 */
$(function(){
    $('select,input[type=email],input[type=text],textarea').focus(function(){
        $(this).addClass('focus');
    }).blur(function(){
        $(this).removeClass('focus');
    });
});

// toastr
function toastrMsg(str){
    toastr.options = {
        "closeButton": false,
        "debug": false,
        "newestOnTop": false,
        "progressBar": false,
        "positionClass": "toast-top-center",
        "preventDuplicates": false,
        "onclick": null,
        "showDuration": "300",
        "hideDuration": "1000",
        "timeOut": "4000",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    }
    toastr.info(str);
}