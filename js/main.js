/* ============================================
   Beauty Bliss USA — Main JavaScript
   ============================================ */
document.addEventListener('DOMContentLoaded', () => {

  /* ---------- Navigation Scroll Effect ---------- */
  const nav = document.querySelector('.nav');
  const handleNavScroll = () => {
    if (window.scrollY > 50) {
      nav.classList.add('scrolled');
    } else {
      nav.classList.remove('scrolled');
    }
  };
  window.addEventListener('scroll', handleNavScroll);
  handleNavScroll();

  /* ---------- Mobile Menu Toggle ---------- */
  const toggle = document.querySelector('.nav__toggle');
  const mobileMenu = document.querySelector('.nav__mobile-menu');
  if (toggle && mobileMenu) {
    toggle.addEventListener('click', () => {
      toggle.classList.toggle('active');
      mobileMenu.classList.toggle('active');
      document.body.style.overflow = mobileMenu.classList.contains('active') ? 'hidden' : '';
    });
    mobileMenu.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', () => {
        toggle.classList.remove('active');
        mobileMenu.classList.remove('active');
        document.body.style.overflow = '';
      });
    });
  }

  /* ---------- Scroll Reveal Animations ---------- */
  const revealElements = document.querySelectorAll('.reveal');
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('revealed');
        revealObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });
  revealElements.forEach(el => revealObserver.observe(el));

  /* ---------- Smooth Scroll for Anchor Links ---------- */
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        e.preventDefault();
        const offset = 80;
        const top = target.getBoundingClientRect().top + window.pageYOffset - offset;
        window.scrollTo({ top, behavior: 'smooth' });
      }
    });
  });

  /* ---------- Testimonials Carousel ---------- */
  const track = document.querySelector('.testimonials__track');
  const prevBtn = document.querySelector('.testimonials__prev');
  const nextBtn = document.querySelector('.testimonials__next');
  if (track && prevBtn && nextBtn) {
    let currentSlide = 0;
    const cards = track.querySelectorAll('.testimonial-card');
    const totalCards = cards.length;
    const getVisibleCards = () => {
      if (window.innerWidth <= 768) return 1;
      if (window.innerWidth <= 1024) return 2;
      return 3;
    };
    const updateCarousel = () => {
      const visible = getVisibleCards();
      const maxSlide = Math.max(0, totalCards - visible);
      currentSlide = Math.min(currentSlide, maxSlide);
      const card = cards[0];
      const gap = 24;
      const cardWidth = card.offsetWidth + gap;
      track.style.transform = 'translateX(-' + (currentSlide * cardWidth) + 'px)';
    };
    prevBtn.addEventListener('click', () => { if (currentSlide > 0) { currentSlide--; updateCarousel(); } });
    nextBtn.addEventListener('click', () => {
      const visible = getVisibleCards();
      const maxSlide = Math.max(0, totalCards - visible);
      if (currentSlide < maxSlide) { currentSlide++; updateCarousel(); }
    });
    window.addEventListener('resize', updateCarousel);
  }

  /* ---------- Services Filter ---------- */
  const filterBtns = document.querySelectorAll('.services-filter__btn');
  const serviceSections = document.querySelectorAll('.service-category');
  if (filterBtns.length && serviceSections.length) {
    filterBtns.forEach(btn => {
      btn.addEventListener('click', () => {
        const filter = btn.dataset.filter;
        filterBtns.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        serviceSections.forEach(section => {
          if (filter === 'all' || section.dataset.category === filter) {
            section.style.display = 'block';
          } else {
            section.style.display = 'none';
          }
        });
      });
    });
  }

  /* ---------- Contact Form ---------- */
  const contactForm = document.getElementById('contactForm');
  if (contactForm) {
    contactForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const inputs = contactForm.querySelectorAll('input, textarea, select');
      let isValid = true;
      inputs.forEach(input => {
        if (input.hasAttribute('required') && !input.value.trim()) {
          input.style.borderColor = '#E74C3C';
          isValid = false;
        } else {
          input.style.borderColor = '';
        }
      });
      if (isValid) {
        const btn = contactForm.querySelector('button[type="submit"]');
        const originalText = btn.textContent;
        btn.textContent = 'Sending...';
        btn.disabled = true;
        setTimeout(() => {
          btn.textContent = '✓ Message Sent!';
          btn.style.background = '#25D366';
          btn.style.color = '#fff';
          setTimeout(() => {
            contactForm.reset();
            btn.textContent = originalText;
            btn.style.background = '';
            btn.style.color = '';
            btn.disabled = false;
          }, 3000);
        }, 1500);
      }
    });
  }

  /* ---------- Newsletter Form ---------- */
  const newsletterForm = document.querySelector('.newsletter__form');
  if (newsletterForm) {
    newsletterForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const input = newsletterForm.querySelector('input');
      const btn = newsletterForm.querySelector('button');
      if (input.value.trim()) {
        const originalText = btn.textContent;
        btn.textContent = '✓ Subscribed!';
        btn.style.background = '#25D366';
        btn.style.color = '#fff';
        input.value = '';
        setTimeout(() => {
          btn.textContent = originalText;
          btn.style.background = '';
          btn.style.color = '';
        }, 3000);
      }
    });
  }

  /* ---------- Parallax on Hero ---------- */
  const hero = document.querySelector('.hero');
  if (hero) {
    window.addEventListener('scroll', () => {
      const scrolled = window.scrollY;
      if (scrolled < window.innerHeight) {
        const particles = hero.querySelector('.hero__particles');
        if (particles) { particles.style.transform = 'translateY(' + (scrolled * 0.15) + 'px)'; }
      }
    });
  }

  /* ---------- Active Nav Link Highlight (only for single-page anchor navs) ---------- */
  const sections = document.querySelectorAll('section[id]');
  const navLinks = document.querySelectorAll('.nav__link');
  const usesAnchorLinks = Array.from(navLinks).some(link => link.getAttribute('href').startsWith('#'));
  if (usesAnchorLinks && sections.length && navLinks.length) {
    window.addEventListener('scroll', () => {
      let current = '';
      sections.forEach(section => {
        const top = section.offsetTop - 100;
        if (window.scrollY >= top) { current = section.getAttribute('id'); }
      });
      navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === '#' + current) { link.classList.add('active'); }
      });
    });
  }

});