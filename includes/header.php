<?php
require_once __DIR__ . '/db_connect.php';

// Only require login if the page isn't login.php
if (basename($_SERVER['PHP_SELF']) !== 'login.php') {
    requireLogin();
}

$user = null;
$role = null;
if (isLoggedIn()) {
    $user = currentUser($conn);
    $role = $user['role'] ?? null;
}

$page_title = $page_title ?? 'نظام الأدلة';
$current_page = basename($_SERVER['PHP_SELF']);
?>
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($page_title) ?> - نظام الأدلة</title>
    <link rel="stylesheet" href="index.css">
</head>
<body>
    <?php if ($user && $current_page !== 'login.php'): ?>
    <header class="site-header">
        <div class="top-bar">
            <div class="container header-logos">
                <img src="theme/rghit-logo.png" alt="شعار الأكاديمية" class="logo-img">
                <h1 class="site-title">نظام الأدلة</h1>
                <img src="theme/left-logo.png" alt="شعار سلاح الجو" class="logo-img">
            </div>
        </div>
        <div class="container">
            <div class="nav-container">
                <button class="menu-toggle" id="mobile-menu-btn" onclick="toggleMenu()">☰ القائمة</button>
                <nav class="nav-links" id="main-nav">
                    <a href="index.php" class="<?= $current_page === 'index.php' ? 'active' : '' ?>">لوحة التحكم</a>
                    
                    <?php if ($role === 'admin'): ?>
                        <a href="manage_users.php" class="<?= $current_page === 'manage_users.php' ? 'active' : '' ?>">المستخدمون</a>
                        <a href="manage_standards.php" class="<?= $current_page === 'manage_standards.php' ? 'active' : '' ?>">المعايير والمقاييس</a>
                        <a href="review_files.php" class="<?= $current_page === 'review_files.php' ? 'active' : '' ?>">مراجعة الملفات</a>
                        <a href="reports.php" class="<?= $current_page === 'reports.php' ? 'active' : '' ?>">التقارير والإحصائيات</a>
                    
                    <?php elseif ($role === 'standard_head'): ?>
                        <a href="my_standard.php" class="<?= $current_page === 'my_standard.php' ? 'active' : '' ?>">إدارة المقاييس</a>
                        <a href="manage_mm.php" class="<?= $current_page === 'manage_mm.php' ? 'active' : '' ?>">صلاحيات المواد</a>
                        <a href="review_files.php" class="<?= $current_page === 'review_files.php' ? 'active' : '' ?>">مراجعة الملفات</a>
                    
                    <?php else: ?>
                        <a href="materials.php" class="<?= $current_page === 'materials.php' ? 'active' : '' ?>">المجلدات والمواد</a>
                    <?php endif; ?>
                </nav>
                
                <div class="user-nav">
                    <span class="text-secondary">أهلاً، <?= htmlspecialchars($user['name']) ?></span>
                    <a href="logout.php" class="btn-logout">تسجيل الخروج</a>
                </div>
            </div>
        </div>
    </header>
    
    <script>
        function toggleMenu() {
            document.getElementById('main-nav').classList.toggle('show');
        }
    </script>
    <?php endif; ?>
    
    <main class="main-content">
        <div class="container">
