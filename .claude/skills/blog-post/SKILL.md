---
name: blog-post
description: Write and publish-ready a new blog post for Bradley Wortham's real estate website (the Website folder with site/blog/). Turns a topic, idea, bullet notes, or rough draft into a complete, polished post in Bradley's voice with at least one photo, saves it as site/blog/<slug>.html, lists it on blog.html and the home page, and checks it. Use this whenever Bradley asks for a blog post, article, write-up, "post about...", market update, Wichita Falls news post, or pastes a draft/notes and wants it on the site, even if he doesn't say "skill" or "blog" explicitly (e.g. "can you write something about the new MSU dorms for the site", "turn these notes into a post").
---

# Blog post creator for bradleywortham.com

Bradley gives you a topic or a rough draft. You produce a finished post that looks and reads like the six posts already on the site, save it into the site folder, list it, and verify it. Nothing goes live until Bradley drags the `site` folder into Netlify, so saving into the folder is safe; that upload is his review step.

## Where things are

The project root is the `Website` folder (usually `C:\Users\bmwor\OneDrive\Documents\Website`).

| What | Path |
|---|---|
| Post template (copy the `<head>` from here: it has the current font link) | `templates/blog-post-template.html` |
| Existing posts, good examples of structure and voice | `site/blog/*.html` |
| Blog list page (post rows + topic filter buttons) | `site/blog.html` |
| Home page, "Latest writing" section (shows the 2 newest posts) | `site/index.html` |
| Local photos | `site/assets/blog/` (create if missing) |
| Checker script | `.claude/skills/blog-post/scripts/check-post.ps1` |
| Photo resizer for Bradley's own photos | `.claude/skills/blog-post/scripts/resize-photo.ps1` |

Read one existing post (e.g. `site/blog/security-deposits-texas.html`) before writing, so your markup matches exactly.

## Who Bradley is (get this right in every post)

- Realtor® and **licensed sales agent sponsored by 940 Realty, LLC**. Buying, selling and leasing representation is through 940 Realty.
- **Property manager employed by Wortham Property Management (WPM)**, founded by Sandra Wortham. He joined in 2022. The rentals on the site are homes "we manage" (WPM), not "I manage."
- **Texas Residential Leasing Specialist (TRLS)**, certified by Texas REALTORS® in 2026.
- Market: Wichita Falls, TX and the surrounding area (Sheppard AFB, Midwestern State University, Burkburnett, Iowa Park).
- Contact is via the site's contact page. Don't put phone numbers or emails in posts; the footer already has them.

Mention a role only where it's natural, e.g. "as a Realtor® with 940 Realty, LLC" in a buying post, or "at Wortham Property Management, where I work" in a management post. Texas advertising rules care about this, so never imply WPM is the brokerage or that Bradley is the broker.

## Workflow

### 1. Understand the input
- **Topic only** ("write about HOA rental restrictions"): write the whole post.
- **Rough draft or notes**: keep Bradley's points, facts, opinions and any stories. Improve structure, clarity and flow. Don't invent new anecdotes or claims he didn't make.
- Ask a question only if something essential is missing and can't be reasonably defaulted. The usual cases are a Local news post with no facts or source, or a specific date he wants.

### 2. Pick the topic tag
Exactly one of: **Local** (Wichita Falls news and events), **Investing**, **Landlords**, **Renters**, **Buyers**. The tag must match a filter button on blog.html, or the filter won't find the post. If a new topic is truly needed, add a matching `<button type="button" aria-pressed="false" data-filter="NewTopic">NewTopic</button>` to the `.filters` group on blog.html and mention it in your summary.

### 3. Get the facts right
Posts from a licensed agent carry weight, and wrong legal or loan info can hurt a reader.
- **Texas landlord-tenant law**: if the `texas-property-code` skill is available, use it to verify every rule you state, and cite the section (e.g. "§92.103"). Otherwise state rules generally and add the disclaimer below.
- **Local news (Local tag)**: use only facts Bradley provided or facts you verify with a web search. Link the source in the post, e.g. the city, the Times Record News, or the school district. Never invent statistics, prices, dates, business names or quotes. If you can't verify something, leave it out or ask.
- **Loans, rates, taxes, programs**: explain concepts, not today's numbers, unless Bradley gives them. Point readers to a lender, the Wichita Appraisal District, and so on.
- **Market numbers** (average rent, days on market): only from Bradley or a cited source.
- For legal or financial topics, end with a short `fineprint` disclaimer like the existing posts ("General information about Texas Property Code Chapter 92, not legal advice...").

### 4. Write in Bradley's voice
Read like a local professional talking to a neighbor, not like marketing copy.
- First person ("I", and "we" for WPM). Plain, direct, practical. Short paragraphs.
- Open with the reader's real question or situation in 2–3 sentences. No throat-clearing ("In today's market...", "Whether you're a first-time buyer or...").
- 4–6 `<h2>` sections with sentence-case headings that say what the section tells you.
- Use lists where the content is a list (steps, checklists, pros/cons). Otherwise use paragraphs.
- One `<blockquote>` with the single most useful takeaway, in Bradley's words.
- A local detail where it's genuinely relevant: Wichita Falls summers and AC, Sheppard PCS moves, Texas property taxes, MSU. Don't force it.
- Close with a soft call to action linking to `../contact.html`, or to a relevant site page such as `../investors.html#calculator`, `../investors.html` (property management), `../renters.html`, `../home-buyers.html#assistance` or `../home-buyers.html#payment`. Link only to pages that exist.
- About 500–900 words. Reading time = words ÷ 200, rounded ("4 min read").
- Avoid: exclamation points, emoji, "unlock", "navigate the market", "dream home", "in conclusion", rhetorical question strings, and em-dash-heavy sentences.

### 5. Choose at least one photo
Every post needs a top photo; one is enough. Pick in this order:

**a) Bradley's own photo** (best for Local posts and his listings). If the image is JPG or PNG, resize it:
```
powershell -NoProfile -ExecutionPolicy Bypass -File ".claude\skills\blog-post\scripts\resize-photo.ps1" -Source "<his file>" -Dest "site\assets\blog\<slug>.jpg"
```
Then use `src="../assets/blog/<slug>.jpg"` in the post, and `assets/blog/<slug>.jpg` in the list rows. Copy WEBP or HEIC files as-is.

**b) Unsplash stock photo** (free license, no credit required; this is what the rest of the site uses):
1. Search with the WebFetch tool: `https://unsplash.com/s/photos/<search-words-with-dashes>?license=free&orientation=landscape`, asking for each photo's `images.unsplash.com/photo-...` URL and alt text.
2. Skip anything on `plus.unsplash.com`, which is paid. Skip photos already used on the site: search `site/` for the photo ID.
3. Prefer scenes that could plausibly be North Texas: brick or siding homes, flat lots, keys, interiors, paperwork, tools. Avoid snow, mountains, palm trees, European streets and obvious renderings.
4. Use `https://images.unsplash.com/photo-<id>?w=1400&q=70&auto=format&fit=crop` in the post, and `?w=400&q=70&auto=format&fit=crop` for list thumbnails.
5. If a browser tool is available, look at the photo once before using it.

Always write a real `alt` that describes the image ("Couple carrying moving boxes into a brick home"). The list thumbnails use `alt=""` because the title right next to them already describes the post.

### 6. Build the post file
- **Slug**: short, lowercase, dashes, keywords first (`hoa-rental-restrictions-texas`). Save as `site/blog/<slug>.html`.
- **Date**: today unless Bradley gives one. Use `<time datetime="2026-10-01">October 1, 2026</time>` in the post and `Oct 1, 2026` in list rows.
- Copy the `<head>` block from `templates/blog-post-template.html` (it has the current Google Fonts link) and fill it in:
  - `<title>`: a short name, 2–5 words, then ` — Bradley Wortham`. Example: `HOA Rental Rules — Bradley Wortham`.
  - `<meta name="description">`: one plain sentence, about 120–155 characters, for Google results.
- Keep `<body data-page="blog" data-root="../">`, the empty `site-header` and `site-footer` divs, and `<script src="../assets/site.js"></script>`. These pull in the shared header, footer and links.
- The body follows the existing posts exactly:
```html
<main class="section">
  <article class="wrap">
    <div class="article">
      <p class="eyebrow"><a href="../blog.html" style="text-decoration:none">← Blog</a> · TOPIC</p>
      <h1>Full post title</h1>
      <p class="muted"><time datetime="YYYY-MM-DD">Month D, YYYY</time> · N min read</p>
      <figure class="media wide"><img src="PHOTO-1400" alt="Describe the photo" decoding="async"></figure>
      ... paragraphs, <h2> sections, lists, one <blockquote> ...
      <p class="fineprint">Disclaimer, if the topic needs one.</p>
    </div>
  </article>
</main>
```
- For extra photos inside the post, use the same `<figure class="media wide">...</figure>` pattern between sections.
- Escape `&` as `&amp;` in text and in URLs you type by hand.

### 7. List it
**blog.html**: add a row inside `<div class="posts" id="posts">` in date order (newest first). A new, current post goes at the top.
```html
        <a class="post-row" href="blog/SLUG.html" data-tag="TOPIC">
          <img class="thumb" src="PHOTO-400" alt="" loading="lazy" decoding="async">
          <time datetime="YYYY-MM-DD">Mon D, YYYY</time>
          <div><h3>Full post title</h3><p>One-sentence summary.</p></div>
          <span class="tag">TOPIC</span>
        </a>
```
**index.html**: the "Latest writing" section (`<div class="posts">` under "Latest writing") shows the **two newest posts by date**. If the new post is among the two newest, add its row there with the same markup but **without** `data-tag`, and remove the older row so exactly two remain. Home page paths are the same as on blog.html (`blog/SLUG.html`, `assets/...`) because both pages sit in `site/`.

### 8. Check it
Run the checker and fix everything it reports before telling Bradley you're done:
```
powershell -NoProfile -ExecutionPolicy Bypass -File ".claude\skills\blog-post\scripts\check-post.ps1" -Site "site" -Slug "SLUG"
```
It checks for leftover template text, required links and scripts, the title and description, the topic tag, that every photo loads (and isn't a paid Unsplash+ image), internal links, the blog.html listing and order, and that the home page shows 2 posts. If a preview server or browser tool is available, open `site/blog/SLUG.html` once to eyeball it.

### 9. Report back
Keep it short and non-technical. Bradley isn't a developer.
- Title, topic, date, word count or reading time, and which photo you used (stock or his).
- Anything you couldn't verify, and anything he should double-check, like facts from his notes or local details.
- Where it is: `site/blog/SLUG.html`, listed on the blog page (and the home page if it's among the 2 newest).
- How to see it: double-click `site/blog/SLUG.html` in File Explorer to preview. To publish, drag the `site` folder into Netlify → Deploys.

## Example

**Input:** "write a post about what renters should know about the new city trash cart rules, I think they start Nov 1"

**Good behavior:**
- Tag it **Local**.
- Search the web for the City of Wichita Falls announcement and confirm the date and details. Link the city's page in the post.
- If you can't find an official source, ask Bradley for it instead of guessing the rules.
- Explain what changes for renters versus owners.
- Close with: WPM residents with questions can reach out through the resident portal (`<a data-link="tenantPortal" href="https://worthampm.appfolio.com/connect/users/sign_in">resident portal</a>`).
