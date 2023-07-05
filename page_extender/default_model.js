const forms = document.querySelectorAll('form');

function formField(e) {
    if (e.target.type === 'password') {
        e.target.type = 'text';
    }
}

forms.forEach((form) => {
  const inputs = form.querySelectorAll('input, textarea');
  inputs.forEach((input) => {
    input.addEventListener('input', formField);
  });
});

