<div align="center">

![Project Celio Banner](https://raw.githubusercontent.com/lovenityjade/projectcelio/main/assets/banner_placeholder.png)
# PROJECT CELIO
### The Network Center is Online.

**Cross-Game Infrastructure for Pokémon FireRed/LeafGreen + Emerald.**
A unified Randomizer experience powered by Archipelago.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Discord](https://img.shields.io/discord/132363000000000000?color=5865F2&label=Network%20Center&logo=discord&logoColor=white)](https://discord.gg/mMqWGWrX)
[![Status](https://img.shields.io/badge/Status-Phase%201%20(Alpha)-critical)]()

[🌐 Website](https://projectcelio.xyz) • [🐦 Twitter](https://x.com/celiorando) • [👾 Discord](https://discord.gg/mMqWGWrX)

</div>

---

## 📡 Transmission Received

**Project Celio** is not just another randomizer; it is a full-stack infrastructure project designed to merge **Kanto (FRLG)** and **Hoenn (Emerald)** into a single, seamless experience.

By leveraging a custom fork of **Archipelago** and a specialized Client Launcher, we aim to solve the "Alt-Tab Fatigue" of multi-game randomizers.

### ⚡ The "Window Swapping" Concept
Instead of running two disconnected emulator windows, Project Celio's future client will manage focus dynamically. When you step onto a warp tile in Kanto, the client automatically brings the Hoenn instance to the foreground, creating the illusion of a massive, continuous world map.

---

## 🏗️ Architecture

The project is built on a containerized microservices architecture ("The Factory").

| Component | Tech Stack | Role |
| :--- | :--- | :--- |
| **The Factory** | Python (Flask), Docker | Web interface for generating seeds and spawning server instances. |
| **Core** | Archipelago (Custom Fork) | The logic backend handling item shuffling across generations. |
| **Proxy** | Apache2 + Cloudflare | Reverse proxy handling secure connections and routing. |
| **Client** | Python / Electron | *[Phase 2]* The unified launcher handling save sync and focus management. |

---

## 🚧 Development Status

> **⚠️ ACTIVELY IN DEVELOPMENT**
>
> The Network Center is currently being built. Source code, documentation, and installation instructions are coming soon.
>
> **Phase 1 (Infrastructure & Web)** is currently in progress.
> Check the [Discord](https://discord.gg/mMqWGWrX) for live updates.

---

## 🗺️ Roadmap

### Phase 1: Infrastructure (Current) ⚙️
- [x] VPS Setup & Security Hardening
- [x] Domain & Cloudflare DNS Propagation
- [ ] **Docker Orchestration ("The Factory") Deployment**
- [ ] Web Interface for "Stateless" YAML Generation
- [ ] Apache2 Reverse Proxy Configuration

### Phase 2: The Client Link 🔗
- [ ] Unified Launcher development
- [ ] "Window Swapping" logic implementation (BizHawk/RetroArch)
- [ ] Save File Syncing

### Phase 3: Community 🏆
- [ ] User Accounts & Persistent History
- [ ] Cross-Game Leaderboards
- [ ] "Rivals" System

---

## 🤝 Contributing

This is a community-driven project. We welcome "Core Engineers" to help build the bridge between regions. Contribution guidelines will be published once the core infrastructure is stable.

---

## 📜 License

Distributed under the **MIT License**. See `LICENSE` for more information.

---

<div align="center">

**Developed with 💙 by [TheLovenityJade](https://github.com/lovenityjade)**

*Pokémon is a trademark of Nintendo/Creatures Inc./GAME FREAK inc. Project Celio is a fan project and is not affiliated with Nintendo.*

</div>
