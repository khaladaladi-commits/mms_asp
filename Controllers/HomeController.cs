using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using MMS.Models;
using MySqlConnector;

namespace MMS.Controllers;

public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;
    private readonly string _connectionString;

    public HomeController(ILogger<HomeController> logger, IConfiguration configuration)
    {
        _logger = logger;
        _connectionString = configuration.GetConnectionString("MySqlConnection") ?? string.Empty;
    }

    public IActionResult Index()
    {
        using var conn = new MySqlConnection(_connectionString);
        conn.Open();

        var user = ResolveUser(conn);
        ViewBag.UserName = user.Name;
        ViewBag.UserRole = user.Role;

        var dashboardStats = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase)
        {
            { "standards", 0 },
            { "metrics", 0 },
            { "pending_files", 0 },
            { "approved_files", 0 },
            { "sh_count", 0 },
            { "mh_count", 0 },
            { "my_standards", 0 },
            { "my_metrics", 0 },
            { "pending_review", 0 },
            { "approved_by_me", 0 },
            { "my_folders", 0 },
            { "my_pending", 0 },
            { "my_approved", 0 },
            { "my_rejected", 0 }
        };

        if (user.Role == "admin")
        {
            dashboardStats["standards"] = ScalarInt(conn, "SELECT COUNT(*) FROM standards");
            dashboardStats["metrics"] = ScalarInt(conn, "SELECT COUNT(*) FROM metrics");
            dashboardStats["pending_files"] = ScalarInt(conn, "SELECT COUNT(*) FROM files WHERE status = 'pending_admin'");
            dashboardStats["approved_files"] = ScalarInt(conn, "SELECT COUNT(*) FROM files WHERE status = 'approved'");
            dashboardStats["sh_count"] = ScalarInt(conn, "SELECT COUNT(*) FROM users WHERE role = 'standard_head'");
            dashboardStats["mh_count"] = ScalarInt(conn, "SELECT COUNT(*) FROM users WHERE role = 'metric_head'");
        }
        else if (user.Role == "standard_head")
        {
            dashboardStats["my_standards"] = ScalarInt(conn, "SELECT COUNT(*) FROM standard_heads WHERE user_id = @userId", user.Id);
            dashboardStats["my_metrics"] = ScalarInt(conn, @"SELECT COUNT(m.id) FROM metrics m
                JOIN standard_heads sh ON sh.standard_id = m.standard_id
                WHERE sh.user_id = @userId", user.Id);
            dashboardStats["pending_review"] = ScalarInt(conn, @"SELECT COUNT(f.id) FROM files f
                JOIN metrics m ON m.id = f.metric_id
                JOIN standard_heads sh ON sh.standard_id = m.standard_id
                WHERE sh.user_id = @userId AND f.status = 'pending_sh'", user.Id);
            dashboardStats["approved_by_me"] = ScalarInt(conn, @"SELECT COUNT(f.id) FROM files f
                JOIN metrics m ON m.id = f.metric_id
                JOIN standard_heads sh ON sh.standard_id = m.standard_id
                WHERE sh.user_id = @userId AND (f.status = 'pending_admin' OR f.status = 'approved')", user.Id);
        }
        else
        {
            dashboardStats["my_metrics"] = ScalarInt(conn, "SELECT COUNT(*) FROM metric_heads WHERE user_id = @userId", user.Id);
            dashboardStats["my_folders"] = ScalarInt(conn, @"SELECT COUNT(DISTINCT a.mm_id) FROM metric_mm_access a
                JOIN metric_heads mh ON mh.metric_id = a.metric_id
                WHERE mh.user_id = @userId", user.Id);
            dashboardStats["my_pending"] = ScalarInt(conn, "SELECT COUNT(*) FROM files WHERE uploaded_by = @userId AND (status = 'pending_sh' OR status = 'pending_admin')", user.Id);
            dashboardStats["my_approved"] = ScalarInt(conn, "SELECT COUNT(*) FROM files WHERE uploaded_by = @userId AND status = 'approved'", user.Id);
            dashboardStats["my_rejected"] = ScalarInt(conn, "SELECT COUNT(*) FROM files WHERE uploaded_by = @userId AND (status = 'rejected_sh' OR status = 'rejected')", user.Id);
        }

        return View(dashboardStats);
    }

    private (int Id, string Name, string Role) ResolveUser(MySqlConnection conn)
    {
        var queryUserId = Request.Query.TryGetValue("userId", out var userIdValues)
            && int.TryParse(userIdValues.ToString(), out var parsedUserId)
            ? parsedUserId
            : 0;

        var sql = queryUserId > 0
            ? "SELECT id, name, role FROM users WHERE id = @userId LIMIT 1"
            : "SELECT id, name, role FROM users ORDER BY CASE WHEN role = 'admin' THEN 0 ELSE 1 END, id LIMIT 1";

        using var cmd = new MySqlCommand(sql, conn);
        if (queryUserId > 0)
        {
            cmd.Parameters.AddWithValue("@userId", queryUserId);
        }

        using var reader = cmd.ExecuteReader();
        if (reader.Read())
        {
            return (reader.GetInt32("id"), reader.GetString("name"), reader.GetString("role"));
        }

        return (0, "زائر", "metric_head");
    }

    private static int ScalarInt(MySqlConnection conn, string sql, int userId = 0)
    {
        using var cmd = new MySqlCommand(sql, conn);
        if (sql.Contains("@userId", StringComparison.Ordinal))
        {
            cmd.Parameters.AddWithValue("@userId", userId);
        }

        var value = cmd.ExecuteScalar();
        return value == null ? 0 : Convert.ToInt32(value);
    }

    public IActionResult Privacy()
    {
        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
