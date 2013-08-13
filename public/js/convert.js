$(document).ready(function() {
    $("#form_submit").click(function(evt) {
        evt.preventDefault();

        var val = $("#tmlCode").val();
        var entityMap = {
            '&': '&amp',
            '<': '&lt;',
            '>': '&gt;',
        };

        $.post('/convert', { tml_code: val }, function (data) {
            $("#meiOutput").html(data.replace(/[&<>]/g, function(s) {
                return entityMap[s];
            }));

        });

    });

});
