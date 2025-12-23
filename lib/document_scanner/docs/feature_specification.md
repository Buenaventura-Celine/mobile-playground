# 📄 Smart Document Scanner Feature

## 📌 Overview
The **Smart Document Scanner** is a core feature of this portfolio application, designed to demonstrate the integration of machine learning and hardware-level camera control in Flutter. It allows users to capture, crop, and digitize physical documents into high-quality digital formats.

## 🚀 Key Functionalities
* **Intelligent Edge Detection:** Leverages Google ML Kit to automatically detect document boundaries in real-time.
* **Perspective Correction:** Automatically straightens and flattens tilted or skewed document captures.
* **Multi-Format Export:** Supports saving scans as high-resolution `JPEG` or multi-page `PDF` files.
* **Persistent Local Storage:** Implements custom file management to move scans from temporary cache to permanent application storage.
* **Direct Share:** Integrated with system share sheets for instant document distribution via email or messaging apps.

## 🛠️ Technical Stack
* **Framework:** [Flutter](https://flutter.dev/)
* **Intelligence:** `google_mlkit_document_scanner` (On-device ML)
* **File Management:** `path_provider` & `dart:io`
* **Hardware Interface:** `camera` (for custom viewfinder implementations)
* **UI/UX:** Custom Material 3 components with Lottie animations for process feedback.

## 🏗️ Architecture & Implementation
The feature is built using a clean separation of concerns:

### 1. The Scanning Engine
Instead of basic photo capture, the app utilizes the **Google Document Scanner SDK**, which provides a native, high-performance UI for cropping and image enhancement. This ensures the app remains lightweight while utilizing Google's advanced ML models.

### 2. File Lifecycle Management
To optimize device storage, the feature implements a strict file lifecycle:
1.  **Capture:** Image is stored in a temporary directory.
2.  **Processing:** User edits/crops the document.
3.  **Persist:** The final version is renamed and moved to the `ApplicationDocumentsDirectory` using `path_provider`.
4.  **Indexing:** The file path is saved to a local database (or state manager) to be displayed in the app's internal gallery.

## 📱 User Experience (UX) Highlights
* **Visual Feedback:** Real-time overlays guide the user to position the document correctly.
* **Offline First:** All processing happens on-device; no internet connection or API keys are required, ensuring 100% user privacy.
* **Non-Blocking UI:** Heavy image processing tasks are handled in the background to keep the interface responsive.

---

### 💡 Portfolio Insights
This feature demonstrates my ability to:
- Handle **hardware permissions** (Camera/Storage) across Android and iOS.
- Integrate **On-Device Machine Learning** without incurring cloud costs.
- Manage **Asynchronous Programming** and file system operations.
- Design **intuitive workflows** for complex hardware tasks.