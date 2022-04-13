// Liczba produktow / uslug

$(document).ready(function () {
    console.log("adsads")
    $('button').on('click', function () {

        var text = $('#products').text()
        var inttext = parseInt(text) 
        inttext += 1;

        $('#products').text(inttext);

    });
});