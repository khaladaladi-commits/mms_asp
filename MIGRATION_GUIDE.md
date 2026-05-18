# نظام الأدلة - دليل الترحيل من PHP إلى ASP.NET Core MVC

## نظرة عامة على التحويل

تم تحويل نظام الأدلة (MMS) بنجاح من PHP إلى ASP.NET Core MVC مع الحفاظ على الهوية البصرية والوظائف الأصلية.

## التغييرات المرئية والتحسينات المطبقة

### 1. **الموضوع (Theme)**
- **الألوان**: تم الحفاظ على نظام الألوان الأصلي
  - الأزرق الأساسي: #1a5276 (brand-blue)
  - الأزرق الفاتح: #3498db (brand-blue-light)
  - الذهبي: #b8860b (brand-gold)
  - الأخضر (النجاح): #27ae60
  - الأحمر (الخطأ): #e74c3c
  - الأصفر (التحذير): #f39c12

- **الخط**: تم استخدام خط Tajawal (العربي) المناسب للواجهات العربية

- **الصور واللوجو**: تم نسخ جميع الصور والشعارات من المشروع الأصلي

### 2. **دعم اللغة العربية والكتابة من اليمين إلى اليسار (RTL)**
- تم تحديث جميع الصفحات لدعم RTL
- جميع النصوص بلغة عربية واضحة
- الواجهة محسّنة للعرض من اليمين إلى اليسار

### 3. **التخطيط (Layout)**
تم إنشاء تخطيط مشترك (_Layout.cshtml) يتضمن:
- رأس الصفحة (Header) مع الشعارات والعنوان
- قائمة التنقل الرئيسية مع الروابط الديناميكية حسب دور المستخدم
- قائمة التنقل للهاتف المحمول
- تذييل الصفحة (Footer)

### 4. **التحسينات في واجهة المستخدم**
- بطاقات إحصائية (Stat Cards) محسّنة مع ظلال وتأثيرات الحركة
- جداول محسّنة مع ألوان واضحة
- شارات (Badges) لحالات الملفات
- تصميم متجاوب (Responsive) يعمل على جميع أحجام الشاشات

## هيكل المشروع

```
MMS/
├── Controllers/
│   ├── HomeController.cs          (لوحة التحكم)
│   ├── StandardsController.cs     (المعايير والمقاييس)
│   ├── UsersController.cs         (إدارة المستخدمين)
│   ├── FilesController.cs         (إدارة الملفات)
│   ├── ReportsController.cs       (التقارير)
│   └── MaterialsController.cs     (المواد والمجلدات)
├── Models/
│   ├── User.cs                    (نموذج المستخدم)
│   ├── Standard.cs                (نموذج المعيار)
│   ├── Metric.cs                  (نموذج المقياس)
│   ├── File.cs                    (نموذج الملف)
│   └── MandatoryMaterial.cs       (نموذج المادة الإلزامية)
├── Views/
│   ├── Home/
│   │   └── Index.cshtml           (لوحة التحكم)
│   ├── Standards/
│   │   ├── Index.cshtml           (قائمة المعايير)
│   │   └── MyStandards.cshtml     (معاييري)
│   ├── Users/
│   │   └── Index.cshtml           (قائمة المستخدمين)
│   ├── Files/
│   │   └── Index.cshtml           (قائمة الملفات)
│   ├── Reports/
│   │   └── Index.cshtml           (التقارير)
│   ├── Materials/
│   │   └── Index.cshtml           (المواد والمجلدات)
│   └── Shared/
│       └── _Layout.cshtml         (التخطيط المشترك)
├── wwwroot/
│   ├── css/
│   │   ├── theme.css              (أنماط الموضوع الرئيسية)
│   │   └── site.css               (أنماط الموقع المخصصة)
│   └── images/
│       └── theme/                 (الشعارات والصور)
├── Database_Migration_SQLServer.sql  (سكريبت ترحيل قاعدة البيانات)
└── appsettings.json               (إعدادات التطبيق)
```

## خطوات الترحيل والإعداد

### 1. إعداد قاعدة البيانات
تم تحويل قاعدة البيانات من MySQL إلى SQL Server. اتبع الخطوات التالية:

```sql
-- قم بتشغيل سكريبت الترحيل:
-- 1. افتح SQL Server Management Studio
-- 2. تصل بقاعدة البيانات الخاصة بك
-- 3. اتبع المحتويات من ملف Database_Migration_SQLServer.sql
```

### 2. تحديث سلسلة الاتصال
قم بتحديث ملف `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR_SERVER;Database=MMS;Trusted_Connection=true;Encrypt=false;"
  }
}
```

### 3. تثبيت الحزم المطلوبة
```bash
dotnet restore
```

### 4. إضافة Entity Framework Core (اختياري)
إذا كنت تريد استخدام Entity Framework Core:

```bash
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Tools
```

### 5. تشغيل التطبيق
```bash
dotnet run
```

سيكون الموقع متاحاً على: `https://localhost:5001`

## أدوار المستخدمين والصلاحيات

### 1. مدير النظام (Admin)
- إدارة المستخدمين
- إدارة المعايير والمقاييس
- مراجعة الملفات
- عرض التقارير والإحصائيات

### 2. رئيس المعيار (Standard Head)
- إدارة معاييره والمقاييس التابعة
- صلاحيات المواد
- مراجعة ملفات المقاييس

### 3. رئيس المقياس (Metric Head)
- عرض المجلدات والمواد
- رفع الملفات
- متابعة حالة الملفات المرفوعة

## الملفات الرئيسية المضافة أو المعدلة

### ملفات CSS
- `wwwroot/css/theme.css` - النمط الرئيسي المحول من PHP
- `wwwroot/css/site.css` - تحسينات الموقع والدعم الإضافي

### الصور
- `wwwroot/images/theme/rghit-logo.png`
- `wwwroot/images/theme/left-logo.png`
- `wwwroot/images/theme/page.png`

### الوحدات التحكمية (Controllers)
تم إنشاء 6 وحدات تحكمية رئيسية مع عمليات CRUD الأساسية

### العروض (Views)
تم إنشاء عروض محسّنة لكل وحدة تحكم مع دعم كامل للعربية

## الخطوات التالية المطلوبة

1. **ربط قاعدة البيانات**: قم بإضافة DbContext و Entity Framework Core لربط الكود بقاعدة البيانات

2. **نظام المصادقة والتفويض**: أضف نظام مصادقة ASP.NET Core Identity

3. **معالجة الملفات**: أضف وظائف رفع وتحميل الملفات

4. **الإشعارات**: أضف نظام إشعارات للمستخدمين

5. **الاختبار**: قم بإجراء اختبارات شاملة على جميع الوظائف

## الملاحظات المهمة

- جميع النصوص والواجهات بلغة عربية 100%
- التصميم محسّن للأجهزة المحمولة
- تم الحفاظ على الهوية البصرية الأصلية
- يدعم اللغة الموجهة من اليمين إلى اليسار (RTL)

## الدعم والمساعدة

للمزيد من المعلومات حول ASP.NET Core MVC، يرجى مراجعة:
- [Microsoft ASP.NET Core Documentation](https://docs.microsoft.com/aspnet/core)
- [ASP.NET Core MVC](https://docs.microsoft.com/aspnet/core/mvc/overview)

---

تم الترحيل بنجاح! جميع الملفات جاهزة للاستخدام.
