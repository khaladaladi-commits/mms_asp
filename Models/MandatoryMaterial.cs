namespace MMS.Models;

public class MandatoryMaterial
{
    public int Id { get; set; }
    public string Code { get; set; } = string.Empty;
    public string? Name { get; set; }
    public int? MetricId { get; set; }
    public DateTime CreatedAt { get; set; }
}
