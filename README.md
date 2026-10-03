# MB Reminder App Specification & AI Prompt

This document serves as a complete prompt and design specification for reproducing or extending the **MB Reminder** application. You can copy and feed this entire prompt to any AI coding assistant to reconstruct or continue developing the app.

---

## 🚀 App Spec / System Prompt (Arabic & English)

### [English Version]
```markdown
Create a Flutter bookmarking and links organizer application called "MB Reminder". The app is designed to help users organize bookmarks, links, and reminders categorized by platform.

### Core Features & Architecture

1. **Category Navigation (HomeScreen):**
   - The Home Screen features a customized Bottom Navigation Bar wrapped in a capsule-shaped floating container at the bottom.
   - It manages 4 main platform categories inside an `IndexedStack` to preserve state:
     - **YouTube**
     - **Instagram**
     - **TikTok**
     - **Reminder**

2. **Category Screens (YouTube, Instagram, TikTok, Reminder):**
   - Each screen displays a responsive grid of folders using `CardWidget`.
   - A `FloatingActionButton` (FAB) with a platform-specific `heroTag` (e.g., `youtube_fab`, `instagram_fab`) allows adding new folder cards via an input dialog asking for the folder name ("اسم الملف").
   - Clicking on a folder card navigates to the `DetailsScreen` for that folder.

3. **Folder Items Screen (DetailsScreen):**
   - Displays bookmark items inside the selected folder using `DetailsItem`.
   - A `FloatingActionButton` with `heroTag: 'item_fab'` triggers an "Add Item" dialog ("إضافة عنصر") containing three inputs:
     - **Link (اللينك):** A validated input field. Automatically trims the input, checks validity, and prepends `https://` if the protocol scheme is missing so it doesn't crash on launch.
     - **Name (الاسم):** An optional name/title for the bookmark.
     - **Description (الديسكربشن):** An optional description for the bookmark.
   - Includes full form validation to keep the dialog open if constraints are not met.

4. **Bookmark Cards (DetailsItem):**
   - Clean, modern dark cards displaying:
     - The bookmark's title/name as a bold header.
     - The bookmark's description text below the title.
     - A modern button labeled **"Open Link"** with a link icon that opens the saved URL in an external browser using the `url_launcher` package.

### Tech Stack & Packages
- **Framework:** Flutter (Dart)
- **State Management:** StatefulWidget / setState
- **Packages:**
  - `flutter_svg` (for platform-specific SVG icons)
  - `url_launcher` (for opening external links)

### Design & Theme
- **Theme Color Palette:**
  - `AppColors.black` (0xFF000000)
  - `AppColors.white` (0xFFFFFFFF)
  - `AppColors.grey` (0xFFCFC4C5)
  - `AppColors.greyDark` (0xFF6E6C6C)
- Scaffold background is clean white, with contrasting dark glassmorphic widgets for list items and navigation components.
```

---

### [النسخة العربية]
```markdown
أنشئ تطبيق فلاتر (Flutter) لتنظيم وحفظ الروابط والتذكيرات باسم "MB Reminder". يهدف التطبيق إلى مساعدة المستخدمين على تنظيم روابطهم المفضلة وتذكيراتهم وتصنيفها حسب المنصة الاجتماعية.

### الميزات الأساسية وبنية التطبيق

1. **التنقل بين الأقسام (HomeScreen):**
   - يحتوي التطبيق على شريط تنقل سفلي (Bottom Navigation Bar) عائم ومصمم على شكل كبسولة أنيقة في الأسفل.
   - يدير 4 أقسام رئيسية باستخدام `IndexedStack` للحفاظ على حالة الصفحات عند التنقل:
     - **YouTube**
     - **Instagram**
     - **TikTok**
     - **Reminder**

2. **شاشات الأقسام (YouTube, Instagram, TikTok, Reminder):**
   - تعرض كل شاشة شبكة متجاوبة من البطاقات (Grid of Cards) تمثل المجلدات التي أنشأها المستخدم باستخدام `CardWidget`.
   - زر عائم `FloatingActionButton` (FAB) مخصص ومعرّف بـ `heroTag` فريد لكل شاشة (مثل `youtube_fab` و `instagram_fab`) يتيح للمستخدم إضافة مجلد جديد عبر نافذة منبثقة تطلب اسم المجلد ("اسم الملف").
   - النقر على أي مجلد ينقل المستخدم إلى شاشة التفاصيل `DetailsScreen`.

3. **شاشة تفاصيل المجلد (DetailsScreen):**
   - تعرض قائمة الروابط المحفوظة داخل المجلد المحدد باستخدام ويدجت `DetailsItem`.
   - زر عائم `FloatingActionButton` يحمل الـ `heroTag: 'item_fab'` يفتح نافذة منبثقة لإضافة رابط جديد ("إضافة عنصر") تحتوي على ثلاثة حقول:
     - **اللينك (الرابط):** حقل إجباري ومحمي بالـ Validation. يقوم التطبيق تلقائياً بقص الفراغات الزائدة، والتحقق من صحته، وإضافة بروتوكول `https://` تلقائياً إذا نسيه المستخدم لضمان فتح الرابط بنجاح.
     - **الاسم:** حقل اختياري لتسمية الرابط.
     - **الديسكربشن (الوصف):** حقل اختياري لشرح محتوى الرابط.
   - يتم التحقق من المدخلات بشكل كامل ولا يتم إغلاق النافذة أو مسح الحقول إلا بعد نجاح التحقق والإضافة الفعالة للبيانات.

4. **بطاقات الروابط (DetailsItem):**
   - بطاقات داكنة حديثة وأنيقة تعرض:
     - عنوان/اسم الرابط بخط عريض في الأعلى.
     - وصف الرابط أسفله مباشرة.
     - زر واضح يحمل اسم **"Open Link"** مع أيقونة رابط، عند الضغط عليه يقوم بفتح الرابط المحفوظ في المتصفح الخارجي باستخدام حزمة `url_launcher`.

### التقنيات والمكتبات المستخدمة
- **بيئة العمل:** Flutter (Dart)
- **إدارة الحالة:** StatefulWidget / setState
- **المكتبات:**
  - `flutter_svg` (لعرض أيقونات منصات التواصل بصيغة SVG)
  - `url_launcher` (لفتح الروابط في المتصفح الخارجي)

### التصميم والألوان
- **مجموعة الألوان الرئيسية:**
  - `AppColors.black` (0xFF000000)
  - `AppColors.white` (0xFFFFFFFF)
  - `AppColors.grey` (0xFFCFC4C5)
  - `AppColors.greyDark` (0xFF6E6C6C)
- خلفية التطبيق بيضاء بالكامل، مع تباين أنيق باستخدام البطاقات الداكنة وشريط التنقل العائم.
```
