document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
  anchor.addEventListener('click', (event) => {
    const id = anchor.getAttribute('href');
    if (!id || id === '#') return;
    const target = document.querySelector(id);
    if (!target) return;
    event.preventDefault();
    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
  });
});

const form = document.querySelector('.waitlist-form');
if (form) {
  form.addEventListener('submit', (event) => {
    event.preventDefault();
    const button = form.querySelector('button');
    const input = form.querySelector('input');
    if (button) button.textContent = "You're on the list";
    if (input) {
      input.value = '';
      input.placeholder = 'Thanks — we will be in touch';
    }
  });
}

const phoneTimer = document.querySelector('.phone-timer');
if (phoneTimer) {
  let total = 43 * 60 + 21;
  setInterval(() => {
    total = Math.max(0, total - 1);
    const m = String(Math.floor(total / 60)).padStart(2, '0');
    const s = String(total % 60).padStart(2, '0');
    phoneTimer.textContent = `${m}:${s}`;
  }, 1000);
}
