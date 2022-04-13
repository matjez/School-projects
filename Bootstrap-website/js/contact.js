//js walidacja

function validateForm() {
    var email = document.forms["ContactForm"]["email"].value;
    var phoneNumber = document.forms["ContactForm"]["phoneNumber"].value;
    var message = document.forms["ContactForm"]["message"].value;
    var terms = document.forms["ContactForm"]["terms"];

    if (email == "") {
      alert("Podaj e-mail!");
      return false;
    }
    if (phoneNumber.length < 9) {
      alert("Nieprawidłowy numer telefonu!");
      return false;
    }
    if (phoneNumber.length > 12) {
      alert("Nieprawidłowy numer telefonu!");
      return false;
    }
    if (message.length < 9) {
      alert("Wiadmość jest za krótka!");
      return false;
    }
    if (message.length > 500) {
      alert("Wiadmość jest za długa!");
      return false;
    }    
    if(terms.checked == false){
      alert("Zaznacz zgodę na przetwarzanie danych!");
      return false;
    }

    return true;
  }
  