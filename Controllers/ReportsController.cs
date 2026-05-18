using Microsoft.AspNetCore.Mvc;

namespace MMS.Controllers;

public class ReportsController : Controller
{
    private readonly ILogger<ReportsController> _logger;

    public ReportsController(ILogger<ReportsController> logger)
    {
        _logger = logger;
        // TODO: Inject database context
    }

    public IActionResult Index()
    {
        ViewBag.UserName = "مستخدم";
        ViewBag.UserRole = "admin";
        var reportData = new Dictionary<string, object>(); // TODO: Load from database
        return View(reportData);
    }

    public IActionResult StandardsReport()
    {
        ViewBag.UserName = "مستخدم";
        ViewBag.UserRole = "admin";
        return View();
    }

    public IActionResult MetricsReport()
    {
        ViewBag.UserName = "مستخدم";
        ViewBag.UserRole = "admin";
        return View();
    }

    public IActionResult FileStatusReport()
    {
        ViewBag.UserName = "مستخدم";
        ViewBag.UserRole = "admin";
        return View();
    }
}
