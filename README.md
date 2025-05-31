# 📜 Project Overview

> ## 함께하루 : 노인과 가족 간 소통을 위한 음성 기반 커뮤니케이션 앱
![표지](https://github.com/user-attachments/assets/acb7e0b1-cb25-4dc3-abe3-19695aa8545f)


**모바일 앱개발 협동조합 주관 산학협력 프로젝트**
독거 노인의 안전과 일정 관리를 위해, 가족 연동 기능과 음성 기반 소통(STT/TTS), 비상 호출, 일정 공유 등을 통합한 커뮤니케이션 앱입니다.

---

### ⏳ Project Schedule

| 단계 | 기간                       |
| -- | ------------------------ |
| 개발 | 2025.03.07 \~ 2025.05.31 |

---

### 💭 Project Motivation

❓Problem

* 📱 디지털 기기에 익숙하지 않은 노인의 소통 단절
* 🧓 독거노인의 안전 확인 어려움

❗Solution
**노인을 위한 직관적 UX + 음성 기반 인터페이스로 소통과 안전을 지원하는 앱**

---

### 🛠️ Tech Stack

* **Language & Framework**: Flutter 3.32.0 / Dart 3.8.0
* **State Management**: Riverpod
* **Routing**: go\_router
* **Socket**: STOMP over WebSocket
* **Secure Storage**: flutter\_secure\_storage
* **Notification**: Firebase Cloud Messaging
* **Design Pattern**: MVVM

---

### ⭐ Key Features (FE 기준)

| 기능           | 설명                                 |
| ------------ | ---------------------------------- |
| 👵 피보호자 전용 홈 | 일정 확인, 긴급 호출, 음성 메모 기능 제공          |
| 👨 보호자 전용 홈  | 피보호자 목록, 일정 등록, 알람 설정 기능           |
| 🔔 푸시 알림     | 일정 및 비상 상황에 따른 알림 수신               |
| 📅 일정 등록/조회  | 보호자가 일정 추가, 피보호자는 음성으로 확인          |
| 🧠 음성 인터페이스  | 음성 인식(STT), 음성 안내(TTS) 기반 화면 설계    |
| 💬 실시간 채팅    | STOMP 기반 실시간 채팅 구현                 |
| 🔒 로그인 & 인증  | Flutter Secure Storage 기반 인증 토큰 처리 |

---

### 👩‍💻 My Role – Frontend

* **MVVM 패턴 적용**: 역할 분리 및 유지보수성 강화
* **상태관리 설계**: Riverpod 기반 전역 상태 흐름 구축
* **Socket 통신 구현**: STOMP 기반 채팅 클라이언트 개발
* **Push 알림 처리**: Firebase 연동 및 알림 UI 처리
* **접근성 고려한 UI 설계**: 고령 사용자를 위한 버튼 배치, 음성 안내, 시각적 대비 등 적용

---

### 🤗 Our Team

| 이름        | 역할                              |
| --------- | ------------------------------- |
| PM 외 총 7명 | PM 1, FE 1, BE 1, AI 3, 디자이너 1명 |
| 김지현       | 프론트엔드 개발                        |

---

### 🔗 Resources

* 🧠 [백엔드 레포지토리](https://github.com/CareConnect0/server)
* 📒 [Notion 협업 문서](https://www.notion.so/25-1-1b55fff05b49813aa5c9c8e27b4a4484)
