/* ==========================================================================
   SITE CONFIG — edit this block to update your info across every page.
   ========================================================================== */
const SITE = {
  name: "Bradley Wortham",
  initials: "BW",
  title: "Realtor® & Property Manager",
  company: "Wortham Property Management",
  companyUrl: "https://www.worthampm.com/",
  // Real estate license: sales agent sponsored by 940 Realty, LLC (TREC: broker shown on every page)
  broker: "940 Realty, LLC",
  brokerLicense: "9009568",
  brokerAddress: "3606 Grant St., Wichita Falls, TX 76308",
  brokerPhone: "(940) 264-4663",
  supervisor: "Sandra Wortham",
  supervisorLicense: "463872",
  license: "809779",
  credential: "Texas Residential Leasing Specialist (TRLS)",
  credentialShort: "TRLS",
  market: "Wichita Falls, TX",
  region: "Wichita Falls & the surrounding area",
  phone: "(940) 500-2199",
  email: "bradley@sandrawortham.com",
  email2: "bradley@worthampm.com",             // second email (hidden while empty)
  officeHours: "Mon–Fri, 9am–5pm",
  tenantPortal: "https://worthampm.appfolio.com/connect/users/sign_in",
  ownerPortal: "https://worthampm.appfolio.com/oportal/users/log_in",
  availability: "https://www.worthampm.com/availability",
  // MLS search (WFAR Paragon feed via the team's BoomTown site). Leads land in your BoomTown account.
  mlsSearch: "https://bradley.sandraworthamteam.com/results-gallery/",
  iabs: "assets/iabs-940-realty.pdf",          // 940 Realty's completed IABS form (TREC requirement)
  consumerNotice: "https://www.trec.texas.gov/forms/consumer-protection-notice",
};

/* NAVIGATION — add a new page by adding one line here.
   `id` must match the data-page attribute on that page's <body>. */
const NAV = [
  { id: "home",      label: "About Me",     href: "index.html" },
  { id: "investors", label: "Investors",    href: "investors.html" },
  { id: "renters",   label: "Renters",      href: "renters.html" },
  { id: "buyers",    label: "Home Buyers",  href: "home-buyers.html" },
  { id: "blog",      label: "Blog",         href: "blog.html" },
  // { id: "projects",  label: "Projects",     href: "projects.html" },   // un-comment once you post a project
];

/* ========================================================================== */

(function () {
  const root = document.body.dataset.root || "";   // "../" for pages in subfolders
  const page = document.body.dataset.page || "";

  const navLinks = NAV.map(n =>
    `<a href="${root}${n.href}"${n.id === page ? ' aria-current="page"' : ""}>${n.label}</a>`
  ).join("");

  const header = document.getElementById("site-header");
  if (header) {
    header.outerHTML = `
      <header class="site-header">
        <div class="wrap header-row">
          <a class="brand" href="${root}index.html">
            <span class="brand-mark" aria-hidden="true">${SITE.initials}</span>
            <span><strong>${SITE.name}</strong><small>${SITE.title} · ${SITE.broker}</small></span>
          </a>
          <button class="nav-toggle" id="nav-toggle" aria-expanded="false" aria-controls="site-nav">Menu</button>
          <nav class="site-nav" id="site-nav" aria-label="Main">
            ${navLinks}
            <a class="btn btn-small" href="${root}contact.html">Contact</a>
          </nav>
        </div>
      </header>`;
    const toggle = document.getElementById("nav-toggle");
    const nav = document.getElementById("site-nav");
    toggle.addEventListener("click", () => {
      const open = nav.classList.toggle("open");
      toggle.setAttribute("aria-expanded", open);
    });
  }

  const footer = document.getElementById("site-footer");
  if (footer) {
    footer.outerHTML = `
      <footer class="site-footer">
        <div class="wrap footer-grid">
          <div>
            <p class="footer-name">${SITE.name}</p>
            <p>${[
              `Realtor® · ${SITE.credentialShort}`,
              `Sales agent, TREC #${SITE.license}`,
              `Sponsored by ${SITE.broker} (TREC #${SITE.brokerLicense})`,
              `Property manager at <a href="${SITE.companyUrl}">${SITE.company}</a>`
            ].join("<br>")}</p>
          </div>
          <div>
            <p class="label">Reach me</p>
            <p>${[`<a class="mono" href="tel:${SITE.phone.replace(/\D/g, "")}">${SITE.phone}</a>`, ...[SITE.email, SITE.email2].filter(Boolean).map(e => `<a href="mailto:${e}">${e}</a>`), SITE.officeHours].filter(Boolean).join("<br>")}</p>
          </div>
          <div>
            <p class="label">Pages</p>
            <p class="footer-links">${navLinks}<a href="${root}contact.html">Contact</a></p>
          </div>
          <div>
            <p class="label">WPM residents &amp; owners</p>
            <p class="footer-links">
              <a href="${SITE.tenantPortal}">Resident portal: pay rent &amp; repairs</a>
              <a href="${SITE.ownerPortal}">Owner portal</a>
              <a href="${SITE.availability}">WPM available rentals</a>
            </p>
          </div>
        </div>
        <div class="wrap footer-legal">
          <p>Real estate brokerage services (buying, selling and leasing representation) are provided by ${SITE.broker}, ${SITE.brokerAddress}, ${SITE.brokerPhone}. ${SITE.name} is a licensed sales agent sponsored by ${SITE.broker}. Property management services are provided by ${SITE.company}, where ${SITE.name.split(" ")[0]} is employed as a property manager.</p>
          <p>© ${new Date().getFullYear()} ${SITE.name}. Equal Housing Opportunity. Listing information is deemed reliable but not guaranteed.</p>
          <p><a href="${/^https?:/.test(SITE.iabs) ? SITE.iabs : root + SITE.iabs}" target="_blank" rel="noopener">Texas Real Estate Commission Information About Brokerage Services</a> · <a href="${SITE.consumerNotice}">Texas Real Estate Commission Consumer Protection Notice</a></p>
        </div>
      </footer>`;
  }

  // Fill any element marked data-site="key" with the matching config value.
  // Anything marked data-hide-empty="key" is hidden while that config value is blank.
  document.querySelectorAll("[data-site]").forEach(el => {
    const v = SITE[el.dataset.site];
    if (v !== undefined) el.textContent = v;
  });
  document.querySelectorAll("[data-hide-empty]").forEach(el => { if (!SITE[el.dataset.hideEmpty]) el.hidden = true; });
  document.querySelectorAll("[data-mailto]").forEach(a => { const v = SITE[a.dataset.mailto]; if (v) a.href = "mailto:" + v; });
  // Point any link marked data-link="key" at the matching config URL.
  document.querySelectorAll("[data-link]").forEach(a => {
    const v = SITE[a.dataset.link];
    if (v) a.href = v;
  });

  // MLS search: build BoomTown result URLs.
  // Known filters: proptype (SF homes, C condos, M manufactured, MF multi-family, RN rentals),
  // status=A (active), minprice, maxprice, minbeds, minbaths, sort, photo=1.
  const mlsUrl = params => {
    const q = new URLSearchParams({ status: "A", photo: "1" });
    Object.entries(params).forEach(([k, v]) => { if (v !== "" && v != null) q.set(k, v); });
    return SITE.mlsSearch + "?" + q.toString();
  };
  document.querySelectorAll("a[data-mls]").forEach(a => {
    a.href = mlsUrl(Object.fromEntries(new URLSearchParams(a.dataset.mls)));
    a.target = "_blank"; a.rel = "noopener";
  });
  document.querySelectorAll("form[data-mls-form]").forEach(form => {
    form.addEventListener("submit", e => {
      e.preventDefault();
      const params = Object.fromEntries(new FormData(form));
      const url = mlsUrl(params);
      const win = window.open(url, "_blank");   // "noopener" as a feature would make this return null
      if (win) win.opener = null; else location.href = url;
    });
  });

  // Contact forms: no backend yet — see README for hooking up Formspree/Netlify.
  document.querySelectorAll("form[data-demo]").forEach(form => {
    form.addEventListener("submit", e => {
      e.preventDefault();
      const note = form.querySelector(".form-note");
      if (note) note.textContent = "Thanks. This form isn't connected yet; once it is, messages will go straight to my inbox.";
    });
  });
})();
