namespace MMS.Models;

public class Metric
{
    public int Id { get; set; }
    public int StandardId { get; set; }
    public string Name { get; set; } = string.Empty;
    public int OrderNum { get; set; }
    public DateTime CreatedAt { get; set; }
    public Standard? Standard { get; set; }
}
