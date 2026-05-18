using Microsoft.AspNetCore.Mvc;

namespace MMS.Controllers;

public class MaterialsController : Controller
{
    private readonly ILogger<MaterialsController> _logger;

    public MaterialsController(ILogger<MaterialsController> logger)
    {
        _logger = logger;
        // TODO: Inject database context
    }

    public IActionResult Index()
    {
        ViewBag.UserName = "مستخدم";
        ViewBag.UserRole = "metric_head";
        var materials = new List<object>(); // TODO: Load from database
        return View(materials);
    }

    public IActionResult ManageMaterials()
    {
        ViewBag.UserName = "مستخدم";
        ViewBag.UserRole = "standard_head";
        var materials = new List<object>(); // TODO: Load from database
        return View(materials);
    }
}
