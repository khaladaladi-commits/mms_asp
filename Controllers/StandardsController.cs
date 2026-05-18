using Microsoft.AspNetCore.Mvc;
using MMS.Models;
using MySqlConnector;

namespace MMS.Controllers;

public class StandardsController : Controller
{
    private readonly ILogger<StandardsController> _logger;
    private readonly string _connectionString;

    public StandardsController(ILogger<StandardsController> logger, IConfiguration configuration)
    {
        _logger = logger;
        _connectionString = configuration.GetConnectionString("MySqlConnection") ?? string.Empty;
    }

    public IActionResult Index()
    {
        ViewBag.UserName = "مستخدم";
        ViewBag.UserRole = "admin";

        var standards = new List<Standard>();
        using var conn = new MySqlConnection(_connectionString);
        conn.Open();
        using var cmd = new MySqlCommand(@"SELECT s.id, s.name, s.order_num, s.created_at, COUNT(m.id) AS metrics_count
            FROM standards s
            LEFT JOIN metrics m ON m.standard_id = s.id
            GROUP BY s.id, s.name, s.order_num, s.created_at
            ORDER BY s.order_num, s.id", conn);
        using var reader = cmd.ExecuteReader();

        while (reader.Read())
        {
            var count = reader.GetInt32("metrics_count");
            standards.Add(new Standard
            {
                Id = reader.GetInt32("id"),
                Name = reader.GetString("name"),
                OrderNum = reader.GetInt32("order_num"),
                CreatedAt = reader.GetDateTime("created_at"),
                Metrics = Enumerable.Range(0, count).Select(_ => new Metric()).ToList()
            });
        }

        return View(standards);
    }

    public IActionResult MyStandards()
    {
        ViewBag.UserName = "مستخدم";
        ViewBag.UserRole = "standard_head";
        var standards = new List<Standard>(); // TODO: Load from database
        return View(standards);
    }

    public IActionResult Create()
    {
        ViewBag.UserName = "مستخدم";
        ViewBag.UserRole = "admin";
        return View();
    }

    [HttpPost]
    public IActionResult Create(Standard standard)
    {
        if (ModelState.IsValid)
        {
            // TODO: Save to database
            return RedirectToAction(nameof(Index));
        }
        return View(standard);
    }
}
