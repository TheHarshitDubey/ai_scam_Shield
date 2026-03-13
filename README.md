🛡️ AI Scam Shield

AI Scam Shield is a mobile application that helps users detect potential scam messages using AI.
The app analyzes suspicious text messages or screenshots and determines whether they are scams while also suggesting a safe reply.

This project combines mobile development, AI integration, and backend APIs to create a real-world cybersecurity tool.

---

🚀 Features

- 🔍 AI Scam Detection
  Detect suspicious messages using Google Gemini AI.

- 📸 OCR Screenshot Scanner
  Extract text from screenshots using Google ML Kit and analyze it instantly.

- 🤖 AI Generated Safe Reply
  Generate a safe response to avoid sharing sensitive information with scammers.

- 🕒 Scan History
  Store previously analyzed messages for future reference.

- 📊 Analytics Dashboard
  View insights such as:
  
  - Total scans
  - Scam messages detected
  - Safe messages
  - Risk percentage

---

📱 App Screenshots

Analyze Message Screen
![Analyze](screenshots/home.jpeg)


<!-- Add screenshot here -->History Screen

<!-- Add screenshot here -->Analytics Dashboard

<!-- Add screenshot here -->---

🏗️ Architecture

Flutter Mobile App → FastAPI Backend → Gemini AI → SQLite Database

---

🛠️ Tech Stack

Frontend

- Flutter
- Dart

Backend

- FastAPI
- Python

AI Integration

- Google Gemini API

Database

- SQLite

Other Tools

- Google ML Kit (OCR)
- REST API
- Render (Backend Deployment)
- Git & GitHub

---

⚙️ Installation

Clone the repository:

git clone https://github.com/your-username/ai_scam_shield.git

Navigate to the project folder:

cd ai_scam_shield

Install dependencies:

flutter pub get

Run the app:

flutter run

---

💡 Motivation

Online scams and phishing attacks are increasing rapidly.
Many users struggle to identify suspicious messages.

AI Scam Shield aims to help users identify scam messages quickly and respond safely using AI assistance.

---

👨‍💻 Author

Harshit Dubey
B.Tech Student | Flutter Developer | AI Enthusiast

---

⭐ Future Improvements

- Real-time scam detection in messaging apps
- Scam reporting system
- More advanced AI models for fraud detection
- Multi-language scam detection
