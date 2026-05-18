using Microsoft.AspNetCore.Mvc;
using MMS.Models;
using MySqlConnector;
using ModelFile = MMS.Models.File;

namespace MMS.Controllers;

public class FilesController : Controller
{
    private readonly ILogger<FilesController> _logger;
    private readonly string _connectionString;

    public FilesController(ILogger<FilesController> logger, IConfiguration configuration)
    {
        _logger = logger;
        _connectionString = configuration.GetConnectionString("MySqlConnection") ?? string.Empty;
    }

    public IActionResult Index()
    {
        ViewBag.UserName = "مستخدم";
        ViewBag.UserRole = "admin";

        var files = new List<ModelFile>();
        using var conn = new MySqlConnection(_connectionString);
        conn.Open();
        using var cmd = new MySqlCommand(@"SELECT id, type, mm_id, code, metric_id, filename, original_name, uploaded_by, status, created_at
            FROM files
            ORDER BY id DESC", conn);
        using var reader = cmd.ExecuteReader();

        while (reader.Read())
        {
            files.Add(new ModelFile
            {
                Id = reader.GetInt32("id"),
                Type = reader.GetString("type"),
                MmId = reader.GetInt32("mm_id"),
                Code = reader.IsDBNull(reader.GetOrdinal("code")) ? null : reader.GetString("code"),
                MetricId = reader.GetInt32("metric_id"),
                Filename = reader.GetString("filename"),
                OriginalName = reader.GetString("original_name"),
                UploadedBy = reader.GetInt32("uploaded_by"),
                Status = reader.GetString("status"),
                CreatedAt = reader.GetDateTime("created_at")
            });
        }

        return View(files);
    }

    public IActionResult Upload()
    {
        ViewBag.UserName = "مستخدم";
        ViewBag.UserRole = "metric_head";
        return View();
    }

    [HttpPost]
    public IActionResult Upload(IFormFile file, int metricId)
    {
        if (file != null && file.Length > 0)
        {
            // TODO: Save file to storage and database
            return RedirectToAction(nameof(Index));
        }
        return View();
    }

    public IActionResult Review(int id)
    {
        ViewBag.UserName = "مستخدم";
        ViewBag.UserRole = "standard_head";
        // TODO: Load file details from database
        return View();
    }
}
