# Portfolio Site

[[_Index|← Back to Index]]

**URL:** https://jhathcock-sys.github.io/me/ | **Repo:** https://github.com/jhathcock-sys/me

---

## Overview

Personal portfolio and resume site built with Hugo and hosted on GitHub Pages.

---

## Repository

- **GitHub:** `github.com:jhathcock-sys/me.git`
- **Local:** `/home/cib/my-portfolio`
- **Live URL:** https://jhathcock-sys.github.io/me/
- **Tech Stack:** Hugo + PaperMod theme
- **Deploy:** Auto via GitHub Actions on push to main

---

## Site Structure

```
my-portfolio/
├── content/
│   ├── resume.md              # Full resume with TOC
│   └── projects/
│       ├── _index.md                        # Projects listing page
│       ├── home-lab.md                      # HomeLab project writeup
│       ├── GitOps.md                        # GitOps project writeup
│       ├── security-review.md               # Docker Security Audit writeup
│       ├── container-resource-management.md # Container Memory Limits & Prometheus Alerts
│       └── claude-memory.md                 # Claude Code Memory System writeup
├── static/
│   ├── files/
│   │   └── James_Hathcock_Resume.pdf
│   └── images/                # Profile photo, favicon (TODO)
├── hugo.yaml                  # Site config
└── .github/workflows/hugo.yaml # Auto-deploy workflow
```

---

## Features Implemented

- **Homepage Hero Card:** Name, subtitle, social links, action buttons
- **Resume Page:** Full resume with table of contents, PDF download link
- **Projects Section:** Index page listing all projects with descriptions
- **SEO:** Meta description, keywords, author tags
- **Code Highlighting:** Enabled for GitOps page code blocks
- **Reading Time:** Shows estimated read time on posts
- **Breadcrumbs:** Navigation aid on subpages
- **Dark/Light Mode:** Auto-follows system preference

---

## Important Notes

### URL Structure
Site is hosted at `/me/` subdirectory. Links must account for this:
- **Markdown links:** Use relative paths (`../gitops/` not `/projects/gitops/`)
- **Config URLs** (profileMode buttons): Use full path (`/me/resume/`)
- **Menu URLs:** Hugo handles these automatically

### PDF Resume
Generated via pandoc:
```bash
pandoc resume.md -o resume.pdf --pdf-engine=xelatex -V geometry:margin=0.75in
```

---

## Project Writeups

| Project | Status | Description |
|---------|--------|-------------|
| **Home Lab** | Published | Infrastructure overview, services, monitoring |
| **GitOps Workflow** | Published | Docker Compose management via Git |
| **Security Review** | Published | Docker security audit and hardening |
| **Container Resources** | Published | Memory limits and Prometheus alert fixes |
| **Claude Memory System** | Published | AI-assisted infrastructure development |
| **Obsidian Vault Restructure** | Published | 1,550-line file transformed into 31-file wiki |

---

## TODO

- [ ] Add profile photo (`static/images/profile.jpg`)
- [ ] Add favicon (`static/images/favicon.ico`)
- [ ] Add Open Graph image for social sharing
- [ ] Consider adding blog section
- [ ] Add more projects as completed

---

*Last updated: 2026-02-04 (Container resource management and monitoring optimization)*

---

## Related Pages

- [[Claude-Memory-System]]
- [[GitHub-Repositories]]
