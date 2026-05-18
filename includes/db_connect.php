<?php
declare(strict_types=1);

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

$dbHost = getenv('DB_HOST') ?: 'localhost';
$dbName = getenv('DB_NAME') ?: 'self_stu_db';
$dbUser = getenv('DB_USER') ?: 'root';
$dbPass = getenv('DB_PASS') ?: '';

try {
    $conn = new mysqli($dbHost, $dbUser, $dbPass, $dbName);
    $conn->set_charset('utf8mb4');
} catch (mysqli_sql_exception $exception) {
    http_response_code(500);
    exit('تعذر الاتصال بقاعدة البيانات.');
}

function h(?string $value): string {
    return htmlspecialchars((string) $value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function fetchAll(mysqli $conn, string $sql, string $types = '', array $params = []): array {
    $stmt = $conn->prepare($sql);
    if ($types !== '') {
        $stmt->bind_param($types, ...$params);
    }
    $stmt->execute();
    return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
}

function fetchOne(mysqli $conn, string $sql, string $types = '', array $params = []): ?array {
    $rows = fetchAll($conn, $sql, $types, $params);
    return $rows[0] ?? null;
}

function currentUser(mysqli $conn): array {
    if (!empty($_SESSION['user_id'])) {
        $user = fetchOne(
            $conn,
            'SELECT u.id, u.username, u.name, u.role
             FROM users u
             WHERE u.id = ? LIMIT 1',
            'i',
            [(int) $_SESSION['user_id']]
        );
        if ($user !== null) {
            return $user;
        }
    }
    return [
        'id' => 0,
        'name' => 'زائر',
        'username' => '',
        'role' => 'guest'
    ];
}

function isLoggedIn(): bool {
    return !empty($_SESSION['user_id']);
}

function requireLogin(): void {
    if (isLoggedIn()) return;
    $currentPath = (string) ($_SERVER['REQUEST_URI'] ?? 'index.php');
    header('Location: login.php?next=' . rawurlencode($currentPath));
    exit;
}

function requireAdmin(mysqli $conn): void {
    requireLogin();
    $user = currentUser($conn);
    if ($user['role'] === 'admin') return;
    http_response_code(403);
    exit('لا تملك صلاحية الوصول إلى هذه الصفحة.');
}

function generateSMCode(mysqli $conn): string {
    // Look for the highest SM number. Note: Code format is SMx, we need x.
    $row = fetchOne($conn, "SELECT code FROM files WHERE code LIKE 'SM%' ORDER BY CAST(SUBSTRING(code, 3) AS UNSIGNED) DESC LIMIT 1");
    if ($row && preg_match('/^SM([0-9]+)$/', $row['code'], $matches)) {
        $num = (int)$matches[1];
        if ($num >= 450) {
            throw new Exception("تم الوصول إلى الحد الأقصى للمواد المساندة (SM450).");
        }
        return 'SM' . ($num + 1);
    }
    return 'SM1';
}

function getMetricDisplayId(mysqli $conn, array $metric): string {
    $metrics = fetchAll($conn, 
        'SELECT id FROM metrics WHERE standard_id = ? ORDER BY order_num, id', 
        'i', [(int)$metric['standard_id']]
    );
    $position = 1;
    foreach ($metrics as $m) {
        if ($m['id'] == $metric['id']) break;
        $position++;
    }
    $standard = fetchOne($conn, 'SELECT order_num FROM standards WHERE id = ?', 'i', [(int)$metric['standard_id']]);
    return $standard['order_num'] . '-' . $position;
}
