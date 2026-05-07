# 📖 FLOW ZoomIt — 만든 이의 이야기 / The Maker's Story

> **임정훈 소장 · Demin Yim** (Yim Jeonghun) · Director · AI Coordinator
> FLOW: AX 디자인연구소 · FLOW: AX Design Lab · <https://flowdesign.ai.kr>

---

## 1. 한글이 안 되는 ZoomIt, 그래서 직접 만들었습니다

오늘은 여러분께 도움이 될지도 모를 작은 앱 하나를 전해드리려 합니다.

반갑습니다. **FLOW: AX 디자인연구소** 임정훈 소장입니다. 오랜만에 다시 글을 쓰네요.

온·오프라인 강의·워크샵에서 PC 화면의 중요한 부분을 강조할 때, Microsoft 의 **ZoomIt**을 많이들 쓰시죠? 확대·네모·원·문자 입력 같은 강력한 기능이 있지만, 영문만 가능하고 **한글이 입력되지 않아서** 항상 아쉬움이 많았습니다.

"언젠가 되겠지" 하는 기다림과 "여전히 안 되네" 하는 불편함에, 한글 기능과 손글씨 폰트, 다양한 색상까지 더해 업그레이드한 **FLOW ZoomIt**을 바이브 코딩으로 이번에 직접 만들었어요.

편하게 다운로드해 사용하시고, 개선이 필요한 부분은 말씀해 주세요.

> 🇬🇧 **Why I built this** — Microsoft's ZoomIt is the de-facto Windows screen-annotation tool for trainers, but its older build couldn't render Korean text. After years of "it'll come someday" turning into "still doesn't work," I vibe-coded a Korean-friendly distribution that bundles native Hangul input, handwriting fonts, and a fuller pen-color palette. Use it freely and let me know what should improve.

---

## 🛠️ 그 뒤에 숨은 기술 여정 / The technical journey behind it

처음엔 ZoomIt 을 처음부터 다시 짜려 했습니다.

자체 IME 를 가진 **Electron 기반 "ZoomIt-Pro" 빌드를 5번 시도**했지만, 투명 윈도우와 한국어 IME 의 비양립으로 모두 실패했어요. Chromium 의 transparent BrowserWindow 와 한국어 composition 이벤트는 알려진 비호환이고, 같은 변수에서 6번째 시도해도 6번째 실패가 될 가능성이 매우 높았습니다.

그러다 2026년 5월, **ZoomIt v11.0 이 한국어를 정상 지원**한다는 사실을 확인하고 — "재개발 대신, **v11.0 을 한국어 강의 환경에 맞게 패키징**" 하는 방향으로 전환했습니다. 본체 갱신 + 손글씨 폰트(나눔바른펜 Bold) + 화살표 시인성(펜 굵기 15) + 자동 시작 + 6색 펜 팔레트 + 양국어 README/about 페이지까지, 한국어 강의자가 한 번에 세팅하고 강의에 들어갈 수 있도록 담았습니다.

> 🇬🇧 **The journey** — I first tried rebuilding ZoomIt from scratch. **Five Electron prototypes with custom Korean IMEs, all failed** — transparent Chromium windows are simply incompatible with Hangul composition events. A sixth attempt would almost certainly fail the same way. So when ZoomIt v11.0 turned out to handle Korean correctly out of the box, I pivoted from "rewrite" to "package v11.0 for Korean classroom use" — adding Nanum Barun Pen Bold as the default handwriting font, pen width 15 for arrowhead visibility, autostart, the six-color palette (R/G/B/Y/O/P), and a bilingual landing page.

---

## 2. AI 코디네이터로 독립한 지 두 달

AI 대전환의 시대, **사람과 일의 흐름을 연결하고 조직의 성장과 성과를 지원한다**는 AX 에 대한 사명과 소명을 가지고, **AI 코디네이터**로서 지난 3월 1일에 프리랜서로 독립했습니다. 어느새 두 달이 넘었네요.

퇴사 전부터 치열하게 고민했던 부분들이 — 일부는 성과로, 일부는 숙제로, 일부는 압박으로 — 다가와, 눈을 떠도 눈을 감아도, 밥을 먹어도 사람을 만나도, AI 와 AX 로 몸과 맘과 가방과 책상이 한가득입니다.

으으, 프리랜서의 삶이란 이런 것이군요. 선배님들, 존경합니다... ㅠㅠ

> 🇬🇧 **Two months independent** — On March 1st, 2026 I left my previous role to start a solo practice as an "AI Coordinator" — connecting people, work, and AX (AI Transformation) for organizations. Two months in, every waking moment is filled with AI, AX, lectures, prototypes. To every freelancer who walked this road before me — I see you.

---

## 3. 200 개 넘게 만들었고, 미완성도 그만큼입니다

사실, 2024년부터 혼자서 하나둘 만들기 시작한 게 어느새 200개가 넘어가네요.

**만들어 본 것들 일부:**
- 50개가 넘는 프롬프트 카드 (지금의 "스킬"이라는 이름으로 부르는 그것)
- 신박하고 흥미롭고 기괴한 SF·실사·캐릭터 영상과 이미지들
- 다양한 디자인의 홈페이지·슬라이드 디자인 앱
- 동기·오늘 기분·자기소개·팀 구성·팀 빌딩·음료/식사 메뉴·참여 후기까지 가능한 워크샵 앱
- 사업장 명을 넣으면 재무·산업·정치·사회·오너·조직 관련 최신 이슈와 뉴스를 정리해 주는 고객 분석 앱
- 산업 분야와 직무 관련 세부 TASK 를 넣으면 AI 지원/대체/지원 불가 등을 리빌딩하는 AX 앱
- 사진을 넣으면 캐릭터로 만들고, 이모티콘·인형·굿즈로 만들어 주는 캐릭터 앱
- 타인 소개·스트레칭·집중력 게임·회의 퍼실리테이션과 스팟을 위한 서포트 앱
- 교육장 주소와 과정·인원을 입력하면 점심·음료·저녁 식당과 메뉴를 추천하고 주문 내역을 자동 정리해 주는 강의 운영 앱
- 패들렛, 슬라이도/아하슬라이드, 멘티미터를 하나로 통합하는 앱
- 워크샵 참여 팀원의 캐릭터·성향이 반영되고, 개인의 업무 스타일을 소개하는 팀 빌딩 앱
- 청각장애인을 위한 영상·음성 모드 안내 앱 — 주위 사람들의 소리, 입술 모양, 뒤에서 다가오는 차량 등을 거리와 함께 휴대폰 화면에 텍스트·아이콘·영상으로 안내
- 화면 터치·마우스 조작이 어려운 장애인을 위해, 음성으로 원하는 화면 위치를 터치할 수 있게 해주는 접근성 앱
- 가족과 장애인 가족 구성원이 서로의 위치를 확인하고 안내를 주고받는 위치 공유 앱
- 등등등...

**그리고 그만큼의 실패 사유:**
기술력이 부족해서, 너무 많은 욕심을 넣어서, 완성도는 높은데 효용성이 떨어져서, 기능은 많은데 품질이 낮아서, 대상자들이 사용하기 불편해서, 디자인이 너무 후져서, 프로세스가 생각보다 복잡해서, 큰 그림으로 만들었는데 마무리가 안 돼서, DB 수집과 분석 내용이 애매해서, 결과 다운로드가 잘려서, 트리거가 작동하지 않아서, 등등...

완성된 앱보다 **미완성된 앱·서비스가 더 많고**, 강의 전일·당일 오작동되는 앱들 때문에 고민·걱정·디버깅으로 날을 새고, 안타까움과 미안함과 허탈함으로 몸과 맘과 AI 를 달래고 싸우고...

> 🇬🇧 **200+ apps, most incomplete** — Since 2024 I've built over 200 small tools alone — prompt cards, SF/realistic/character video pipelines, slide-design apps, workshop helpers, customer-research dashboards, AX task-rebuilders, character-merch generators, facilitation supports, lecture-logistics tools, all-in-one Padlet/Slido/Mentimeter clones, persona-driven team-building apps; an **accessibility app for the deaf and hard-of-hearing** that surfaces ambient sounds, lip-reading cues, and approaching vehicles (with distance) as on-screen text/icons/video; a **voice-driven screen-touch app** for users who can't operate touchscreens or a mouse; a **location-sharing companion app** for families caring for someone with a disability; and more. Most are unfinished — for every reason imaginable: ambition outpacing skill, polished features but low utility, lots of features but rough quality, awkward UX, weak design, brittle data flow, broken triggers, the day-of demo failing... I've spent more nights debugging on the eve of a class than I'd like to count.

---

## 4. 그래서 이제 하나둘 풀어내려 합니다

오랜만에 글을 쓰니, 밖으로 밀어낸 생각·마음·이야기가 한가득이네요.

그동안의 고민과 노력 중 **사람들이 쓸 만한 것들**을 하나둘 풀어내려 합니다.

이미 많은 분들이 많은 것들을 만들고 전하고 계시고, 이미 많은 이들이 많은 것들을 만들고 전하고 있지만,과거의 치열한 고민이, 기본기능으로 수월하게 동작하는 허탈한 요즘이지만, 몸과 맘으로 고민하고 고생했던 부분들이 지금의 AI 를 이해하고 전하는 데 큰 도움이 되고 있어서, 이 이야기들을 같이 나누고 싶어요.

항상 많이 배우고 느끼며 앞으로 나아갑니다.

**고맙습니다.**

> 🇬🇧 **And so I'll start sharing** — Of all those experiments, a handful turned out usable. I'm going to release them one by one. Many of you are already building and sharing too, and many of yesterday's struggles are today's defaults. But the *feeling* of wrestling with those struggles — that's still the foundation of how I understand and teach AI now. So I want to share these stories alongside the apps. Thank you.

---

## 🔗 Where this app lives / 어디서 받으세요

- **Windows installer**: <https://github.com/Demian-Yim/flow-zoomit#-install--설치>
- **소개 페이지**: <https://demian-yim.github.io/flow-zoomit/>
- **Hugging Face Space**: <https://huggingface.co/spaces/Demian-Max/flow-zoomit>
- **macOS version (work-in-progress)**: <https://github.com/Demian-Yim/flow-zoomit-mac>

---

© 2026 FLOW: AX 디자인연구소 · FLOW: AX Design Lab — All Rights Reserved.
ZoomIt is a trademark of Microsoft Corporation. FLOW ZoomIt is an independent
distribution that wraps Microsoft Sysinternals ZoomIt v11.0 with FLOW defaults
and Korean classroom UX. See `LICENSE` for the FLOW packaging license (MIT)
and the Microsoft Sysinternals license that governs the upstream binary.
