# Bradley Wortham — personal site

Plain HTML/CSS/JS. No build step, so it can be hosted anywhere (Netlify, Cloudflare Pages, GitHub Pages).

## Folder layout
- `site/`: **the website. This is the folder Netlify publishes** (set in `netlify.toml`). All paths below are inside it.
- `templates/page-template.html`: starting point for new pages. Copy it into `site/` to use it.
- `README.md`, `serve.ps1`, `netlify.toml`, `.claude/`: notes, deploy config and the local preview server. Not published.

To preview locally without Claude: right-click `serve.ps1` → Run with PowerShell, then open http://localhost:8080/.

## Publish on Netlify
This folder is a Git repo linked to github.com/twodumb/BradleyWortham-Website. Netlify deploys automatically on every push to `main`.
1. Link once: in Netlify open the site → Site configuration → Build & deploy → Link repository → GitHub → `BradleyWortham-Website`.
   Leave the build command empty; `netlify.toml` already sets the publish directory to `site`.
2. Forms: in the Netlify dashboard open Forms and enable form detection if asked. Set up email alerts under Forms → Form notifications.
3. Custom domain: Domain management → Add a domain, then follow Netlify's DNS instructions. HTTPS turns on automatically.
4. To update later: commit and push (`git add -A`, `git commit -m "..."`, `git push`). Netlify redeploys within a minute.

## Photos
Stock photos load straight from Unsplash (images.unsplash.com). The Unsplash License allows free commercial use,
no credit required. Photographers, for reference: Dillon Kydd, Zac Gudakov, Tierra Mallorca, Vitaly Gariev,
Jennifer Kalenberg, Jakub Żerdzicki, Karl Solano, immo RENOVATION, Neal E. Johnson, Kara Eads.
- Top-of-page photos are set with `style="--img:url('...')"` on `<section class="page-hero photo">`.
- To use your own photo: put it in `site/assets/` (e.g. `assets/duplex.jpg`) and replace the Unsplash URL with that path.
- Headshot: see the comment in `index.html`.

## Pages
- `index.html`: About Me (home)
- `investors.html`: finding rentals, WPM management services, cash-flow calculator, MLS quick searches
- `renters.html`: WPM AppFolio rentals, MLS rental search, application checklist, Texas tenant basics
- `home-buyers.html`: MLS home search, loan options, down payment assistance, payment estimator, selling
- `blog.html` + `blog/`: posts
- `projects.html`: interests and projects
- `contact.html`: contact form (Netlify Forms) → `thank-you.html`

## Update your info
Edit the `SITE` block at the top of `assets/site.js`: license number, email, phone, portal links and the IABS link. Every page picks up the changes.
Email and license are hidden on the site while they are blank ("").

## Blog
New posts: copy `templates/blog-post-template.html` into `site/blog/`, then list it in `site/blog.html` (see the note there).
Topics (must match the filter buttons on blog.html): **Local** (Wichita Falls news; shown with a red tag), Investing, Landlords, Renters, Buyers.
The home page "Latest writing" shows the two newest posts; update it in `site/index.html` when you post.

## Font
Instrument Sans (Google Fonts), one family for everything. To change it, edit `--sans` in `site/assets/style.css`
and the Google Fonts `<link>` at the top of each page.

## Projects
Projects is hidden from the menu until you post one. See the comment in `site/projects.html`, then un-comment the Projects line in `NAV`.

## Add a page
1. Copy `templates/page-template.html` into `site/` and rename it.
2. Change its `<title>`, description and `data-page`.
3. To show it in the menu, add one line to `NAV` in `assets/site.js`.

## Wortham PM rentals (AppFolio) — already connected
`renters.html` loads WPM's live AppFolio listings (`#wpm-listings`) with AppFolio's own widget script:
`https://worthampm.appfolio.com/javascripts/listing.js`. It updates itself whenever a unit is listed or leased in AppFolio.
Nothing else to set up. Options you can change in the `Appfolio.Listing({...})` call:
- `themeColor` (currently the site red `#CC1B1B`)
- `propertyGroup`: the name of an AppFolio property list, to show only some properties
- `defaultOrder`: sort order (`date_posted` by default)

It only shows on a real web host or the local preview (`serve.ps1`). The Claude preview link blocks outside scripts, so it shows a "View available rentals" button there instead.

## MLS listings — connected through the team's BoomTown site
The WFAR Paragon MLS feed (sales and rentals) already runs on the Sandra Wortham Team's BoomTown site,
under Sandra's IDX approval. This site sends searches there instead of running a second feed:
- `SITE.mlsSearch` in `assets/site.js` is your BoomTown search page (`bradley.sandraworthamteam.com/results-gallery/`).
- Search forms (`form[data-mls-form]`) on renters.html and home-buyers.html, and quick-search links (`a[data-mls]`)
  on renters, home-buyers and investors, build a BoomTown URL and open it in a new tab.
- Leads who register or save searches on BoomTown land in your BoomTown account, same as before.

BoomTown URL filters (tested): `status=A` (active), `proptype` = `SF` homes, `C` condos, `M` manufactured,
`MF` multi-family, `RN` rentals, `VC` land (comma-separate for several), `minprice`, `maxprice`, `minbeds`,
`minbaths`, `sort` = `listprice_asc` / `listprice_desc`, `photo=1`.
To add a quick search: `<a data-mls="proptype=RN&maxprice=1000&sort=listprice_asc" href="#">Rentals under $1,000</a>`.

If you ever leave BoomTown, the steps below set up a standalone IDX feed instead.

## Standalone IDX (only if not using BoomTown)
1. **Broker approval.** Ask Sandra (as broker) to contact the WFAR MLS office and request IDX for your website. The broker signs the IDX agreement and authorizes a vendor to receive the feed. Ask WFAR:
   - whether lease/rental listings are included in the IDX feed (some MLSs exclude them),
   - whether they offer a free Paragon-based IDX search for members,
   - what the feed/licensing fees are and which vendors are already approved.
2. **Pick a vendor** that supports the WFAR MLS and works on a plain HTML site (not WordPress-only), e.g. IDX Broker or iHomefinder. Both list WFAR coverage. The vendor handles the data paperwork with the MLS.
3. **Build two saved searches** in the vendor's dashboard: Residential For Lease (Wichita Falls area), and Single-Family For Sale.
4. **Paste the embed code** each vendor gives you into `#idx-rentals` (renters.html) and `#idx-sale` (home-buyers.html), then delete the placeholder text in those boxes.
5. **Compliance:** the vendor adds the required MLS logo/disclaimer, the listing brokerage on every listing, and the data-update date. Don't remove those.

Timing is typically a few days to a few weeks after the broker submits the paperwork.

## Before going live
- Done: headshot (`site/assets/bradley.webp`), license #809779, 940 Realty details, completed IABS (`site/assets/iabs-940-realty.pdf`), TRLS certification.
- Rewrite the "About me" paragraphs in your own words.
- Have your broker (940 Realty, LLC) review the site. Its name appears in the header and footer of every page.
- When the IABS form is revised, replace `site/assets/iabs-940-realty.pdf` with the new PDF (same file name).
- After the first Netlify deploy, send yourself a test message from the contact page and confirm it arrives by email.
- Confirm the down payment assistance programs are still current.
