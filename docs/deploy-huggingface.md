# Hugging Face Spaces 배포 가이드 / Hugging Face Spaces Deployment Guide

This repo doubles as a Hugging Face **static** Space — the YAML frontmatter at the top of `README.md` (and `index.html`) makes HF Spaces serve `index.html` as the landing page.

본 저장소는 동일한 코드로 Hugging Face **static** Space 도 됩니다. `README.md` 상단의 YAML 메타데이터로 HF Spaces 가 `index.html` 을 정적 페이지로 렌더링합니다.

---

## 1. Get an HF token / 토큰 발급

Visit <https://huggingface.co/settings/tokens> → Create new token → **Write** scope.

<https://huggingface.co/settings/tokens> 접속 → `Create new token` → 권한 **Write** 선택 → 토큰 복사.

## 2. Authenticate / 로그인

```powershell
hf auth login
# 토큰 붙여넣기 (Paste the token)
```

## 3. Create the Space / Space 생성

```powershell
# Replace <your-username> with your HF account name
hf repo create <your-username>/flow-zoomit --type=space --space_sdk=static
```

## 4. Push the static site / 정적 페이지 업로드

```powershell
# From the repo root:
hf upload <your-username>/flow-zoomit . . --repo-type=space --commit-message="Initial deploy"
```

The Space goes live within a minute at:
배포 완료 후 1분 내로 다음 URL 에서 확인 가능:

```
https://huggingface.co/spaces/<your-username>/flow-zoomit
```

---

## What HF Spaces will render / HF Spaces 렌더링 결과

- `index.html` — bilingual landing page (same as `about.html`)
- `screenshots/` — embedded demo images
- `README.md` — Space metadata + GitHub-style readme tab

---

## Update the Space / Space 갱신

```powershell
# After pulling latest from GitHub:
git pull
hf upload <your-username>/flow-zoomit . . --repo-type=space --commit-message="Update"
```

Or set up a GitHub Action to auto-sync. See the (separate) workflow at
`docs/release-workflow.yml.txt` — currently shipped as a `.txt` because publishing
GitHub Actions requires the `workflow` OAuth scope. To activate:

1. Move it to `.github/workflows/release.yml`
2. Run `gh auth refresh -s workflow`
3. Commit and push

---

## Why both GitHub + HF Spaces? / 왜 둘 다?

| Platform | Strength |
|----------|----------|
| **GitHub** | Source control, releases, issues, version tags, `git clone` workflows |
| **Hugging Face Spaces** | Free static hosting with zero config, easier discovery for AI/edu community, HTTPS+CDN |

The same repo serves both. No fork needed.
